class Text
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization
  extend ActiveModel::Naming
  
  attr_accessor :body, :order
  validates_presence_of :body, :order
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def generate_name
    'text_' + UUID.generate + '.json'
  end
  
  def persisted?
    false
  end
  
end