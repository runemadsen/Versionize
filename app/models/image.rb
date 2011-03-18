class Image < Item
  attr_accessor :key
  validates_presence_of :key
end