class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def deleted!
    self.deleted = true
    self.save validate: false
  end
end
