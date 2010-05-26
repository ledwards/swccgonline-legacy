class DeckItem < ActiveRecord::Base
    belongs_to :deck
    belongs_to :card
    
  def self.from_decklist_item(decklist_item)
    di = self.new
    di.card = decklist_item.card
    di.quantity = decklist_item.quantity
    di.tab = decklist_item.tab
    di
  end
  
end
