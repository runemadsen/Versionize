class Item
  
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization
  extend ActiveModel::Naming
  
  attr_accessor :name, :id
  
  def name_from_uuid(uuid)
    self.class.name.downcase + "_" + uuid + '.json'
  end
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def uuid
    self.name.split("_")[1].split(".")[0]
  end
  
  def generate_name
    self.name ||= self.class.name.downcase + "_" + UUID.generate + '.json'
  end
  
  def persisted?
    false
  end
  
end