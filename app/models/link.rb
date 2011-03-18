class Link < Item
  
  attr_accessor :url, :order
  validates_presence_of :url, :order
  
  def file_extension
     File.extname(url)
  end
  
end