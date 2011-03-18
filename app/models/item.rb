class Item
  
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization
  extend ActiveModel::Naming
  
  attr_accessor :name, :id
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def generate_name
    self.class.name.downcase + "_" + UUID.generate + '.json'
  end
  
  def persisted?
    false
  end
  
end