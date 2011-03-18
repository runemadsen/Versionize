class Item
  
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization
  extend ActiveModel::Naming
  
  attr_accessor :file_name, :id, :order
  validates_presence_of :file_name, :id, :order
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def update(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def self.name_from_uuid(uuid)
    self.name.downcase + "_" + uuid + '.json'
  end
  
  def uuid
    @file_name.split("_")[1].split(".")[0]
  end
  
  def generate_name
    @file_name ||= self.class.name.downcase + "_" + UUID.generate + '.json'
  end
  
  def persisted?
    if id.nil?
      false
    else
      true
    end
  end
  
end