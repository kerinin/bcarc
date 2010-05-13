class SitemapController < ApplicationController
  layout nil
  
  caches_action :geo, :image, :index, :video, :web
end
