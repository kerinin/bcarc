namespace 'cache' do
  desc "Clears javascripts/cache and stylesheets/cache"   
  task :clear do
    puts "Clearing javascripts/cache and stylesheets/cache"
    FileUtils.rm(Dir['public/javascripts/cache/[^.]*']) # use :cache => 'cache_all.js' in stylesheet_link_tag
    FileUtils.rm(Dir['public/stylesheets/cache/[^.]*']) # use :cache => 'cache_all.css' in javascript_include_tag
  end

  desc "Recreate the javascripts/stylesheets cache."
  task :generate do
    puts "Recreate the javascripts/stylesheets cache"
    ActionController::Base.perform_caching = true
    app = ActionController::Integration::Session.new
    app.get '/'
  end
end