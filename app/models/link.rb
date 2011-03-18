class Link < Item
  
  attr_accessor :url
  validates_presence_of :url
  
  def file_extension
     File.extname(url)
  end
  
end