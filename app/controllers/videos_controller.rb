class VideosController < ApplicationController

  def index
    @videos = Video.all
    @categories = Category.all
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
  end


end