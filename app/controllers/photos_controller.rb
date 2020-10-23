class PhotosController < ApplicationController
  def create
    photo = Photo.create(
      image: params[:photo_uri],
      time: params[:time],
      name: params[:name],
      app_group: params[:app_group]
    )
    render json: photo.image_path
  end
end
