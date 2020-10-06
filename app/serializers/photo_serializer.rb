class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :time, :name, :image

  def image
    object.image_path
  end
end
