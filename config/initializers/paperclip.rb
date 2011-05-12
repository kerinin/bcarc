Paperclip.interpolates :project_id do |attachment, style|
  attachment.instance.project_id
end

Paperclip.interpolates :source_url do |attachment, style|
  attachment.instance.source_url
end