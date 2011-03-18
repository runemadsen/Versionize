class Text < Item
  attr_accessor :body
  validates_presence_of :body
end