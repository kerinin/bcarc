desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  puts "running cron task"
  
  puts "downloading new images"
  
  # Download webcam image URL's
  require 'net/ftp'
  ftp = Net::FTP.new('ftp.bcarc.com')
  ftp.passive = true
  ftp.login(user = "ftpuser", passwd = "rSW0WstxFTJvNNHP")
  
  #r = /(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})(\d+).jpg/
  r = /(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2})(.*).jpg/

  #Project.where(:has_webcam => true).each do |project|
  Project.all(:conditions => { :has_webcam => true }).each do |project|
    ftp.chdir(project.webcam_ftp_dir)
    files =  ftp.nlst().select {|v| v.include?(project.webcam_file_prefix) && v=~ r && !WebcamImage.exists?(:source_url => v)}
    files.each do |url|
      #image = WebcamImage.new(:project => project, :source_url => url)
      #image.download_remote_image
      #image.save!
      
      begin
        image = WebcamImage.new(:project => project, :source_url => url)
        image.date_from_url
        image.download_remote_image
        image.save!
        
      rescue
        puts "error adding image #{url}"
      else
        puts "added image #{url}"
      end
    end
  end
  
  ftp.quit()

  puts "determining daily images"
  WebcamImage.where(:daily_image => nil).each do |image|
    noon = DateTime.new(image.date.year, image.date.month, image.date.day, 12)
    midnight = DateTime.new(image.date.year, image.date.month, image.date.day, 24)
    
    unless image == WebcamImage.where("date >= ? AND date < ?", noon, midnight).first
      image.daily_image = false
    else
      image.daily_image = true
      puts "Daily Image for #{image.date.to_s(:long)} is #{image.id}"
    end
    image.save!
  end
end
