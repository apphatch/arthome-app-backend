class PhotoSerializer < ApplicationSerializer
  attributes :id, :time, :name, :image

  def image
    object.image_path
  end
end
