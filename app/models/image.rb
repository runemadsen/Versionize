class Image < Item
  
  attr_accessor :key, :order
  validates_presence_of :key, :order
  
end