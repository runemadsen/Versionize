class Version < ActiveRecord::Base
  
  acts_as_tree :order => :id
  belongs_to :idea
  
  def self.clean_alias(a)
    a.gsub(/[Ää]+/i,'ae').gsub(/[Üü]+/i,'ue').gsub(/[Öö]+/i,'oe').gsub(/[ß]+/i,'ss').downcase.gsub(/[^a-z0-9]+/i, '-').gsub(/(^[-]+|[-]+$)/, '')
  end
  
end
