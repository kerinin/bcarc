module ProjectsHelper
  def project_image( image )
    image_tag image.attachment.url(:thumb), :size => '55x40', :swapover => image_path( image.attachment.url(:thumb) )
  end
end
