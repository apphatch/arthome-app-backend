class ObjectStatusRecord < ApplicationRecord
  belongs_to :subject, polymorphic: true, optional: true

  serialize :data, Hash

  def count key, data
    self.data[key.to_sym] = data.length
  end

  def decrement_1 key
    if self.data[key.to_sym].present?
      self.data[key.to_sym] -= 1
    end
  end

  def empty? key
    return self.data[key].empty? if self.data[key].respond_to?(:empty?)
    return self.data[key] == 0
  end

  def present? key
    return self.data[key].present? if self.data[key].respond_to?(:present?)
    return self.data[key] != 0
  end
end
