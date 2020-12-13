class PhotosController < ApplicationController
  def create
    photo = Photo.create(
      image: params[:photo],
      time: params[:time],
      name: params[:name],
      app_group: @current_app.get(:app_group)
    )
    render json: photo.image_path
  end
end
