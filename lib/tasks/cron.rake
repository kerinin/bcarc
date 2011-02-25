desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  puts "running cron task"
  
  # Download webcam image URL's
  require 'net/ftp'
  ftp = Net::FTP.new('ftp.bcarc.com')
  ftp.login(user = "ftpuser", passwd = "rSW0WstxFTJvNNHP")
  
  r = /(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})(\d+).jpg/
  
  #Project.where(:has_webcam => true).each do |project|
  Project.all(:conditions => { :has_webcam => true }).each do |project|
    ftp.chdir(project.webcam_ftp_dir)
    files = ftp.nlst().select {|v| v=~ r && !WebcamImage.exists?(:source_url => v)}
    files.each do |url|
      begin
        image = WebcamImage.new(:project => project, :source_url => url)
        image.date_from_url
        image.save!
        
      rescue
        puts "error adding image #{url}"
      else
        puts "added image #{url}"
      end
    end
  end
  
  ftp.quit()
end
