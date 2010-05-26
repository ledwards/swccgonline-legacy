class CardCharacteristicConnection < ActiveRecord::Base
  belongs_to :card
  belongs_to :card_characteristic
  
  def self.get_card_characteristic_connections
    find(:all, :order => :card_id)
  end
end