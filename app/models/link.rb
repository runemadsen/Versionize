class Link
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization
  extend ActiveModel::Naming
  
  attr_accessor :url
  validates_presence_of :url
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def file_extension
     File.extname(url)
  end
  
  def generate_name
    'link_' + UUID.generate + '.json'
  end
  
  def persisted?
    false
  end
  
end