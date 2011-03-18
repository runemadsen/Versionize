class Text < Item
  attr_accessor :body, :order
  validates_presence_of :body, :order
end