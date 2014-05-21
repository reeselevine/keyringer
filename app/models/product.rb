class Product < ActiveRecord::Base
  attr_accessible :description, :image_path, :name, :price
end
