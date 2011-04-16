class Link < Item
  
  attr_accessor :url, :notes
  validates_presence_of :url
  
  def file_extension
     File.extname(url)
  end
  
end