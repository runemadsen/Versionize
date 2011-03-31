class Image < Item
  attr_accessor :key
  validates_presence_of :key
  
  def amazon_url
    "http://#{Rails.application.config.bucket}.s3.amazonaws.com/" + self.key
  end
  
end