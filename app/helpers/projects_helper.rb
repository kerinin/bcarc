module ProjectsHelper
  def project_image( image )
    image_tag image.attachment.url(:thumb), :size => '55x40', :swapover => image_path( image.attachment.url(:thumb) )
  end
  
  def project_video( video )
    image_tag video.thumbnail.url(:thumb), :size => '55x40', :swapover => image_path( video.thumbnail.url(:thumb) )
  end
end
