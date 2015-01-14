class PagesController < ApplicationController
  
  def home
    @emptyphoto = Photo.new
    @top5 = Photo.popular
  end
  
end