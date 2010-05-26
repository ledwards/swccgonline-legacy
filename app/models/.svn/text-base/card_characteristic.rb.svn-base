class CardCharacteristic < ActiveRecord::Base
  has_many :card_characteristic_connections
  has_many :cards, :through => :card_characteristic_connections
    
  def self.get_card_characteristics
    find(:all, :order => :name)
  end
  
  def to_symbol
    return name.downcase.gsub(" ", "_").intern
  end
  
end
