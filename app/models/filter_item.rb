class FilterItem < ActiveRecord::Base
  belongs_to :filter
  validates_presence_of :category, :condition, :value
  
  def get_cards
    if self.condition == "contains"
      return Card.find(:all, :conditions => [category+" LIKE ?", '%'+value+'%'])
    end
    
    if category == 'Characteristic'
      return CardCharacteristic.find_by_name(self.value).cards
    
    elsif CardAttribute.find_by_name(category)
      cards = []
      card_attrs = CardAttribute.find(:all, :conditions => ["name LIKE ? AND value"+condition+"?", category, value] )
      card_attrs.each do |c|
          cards << Card.find(c.card_id)
      end
      return cards
    
    else
      return Card.find(:all, :conditions => [ "LOWER(?)"+condition+"?", category, '%' + value.downcase + '%' ])
    end
  end
end