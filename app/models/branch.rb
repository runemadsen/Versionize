class Branch < ActiveRecord::Base
  
  belongs_to :idea
  
  def alias=(a)
    a.gsub!(/[Ää]+/i,'ae') 
    a.gsub!(/[Üü]+/i,'ue') 
	  a.gsub!(/[Öö]+/i,'oe') 
	  a.gsub!(/[ß]+/i,'ss') 
	  a.downcase!
	  a.gsub!(/[^a-z0-9]+/i, '-')
	  a.gsub!(/(^[-]+|[-]+$)/, '')
    write_attribute(:alias, a)
  end
  
end
