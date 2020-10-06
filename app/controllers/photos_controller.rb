class PhotosController < ApplicationController
  def create
    photo = Photo.create(
      image: params[:photo],
      time: params[:time],
      name: params[:name]
    )
    render json: photo.image_path
  end
end
