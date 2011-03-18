class Image
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization
  extend ActiveModel::Naming
  
  attr_accessor :key, :order
  validates_presence_of :key, :order
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def generate_name
    'image_' + UUID.generate + '.json'
  end
  
  def persisted?
    false
  end
  
end