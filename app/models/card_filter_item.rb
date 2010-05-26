class CardFilterItem < ActiveRecord::Base
  belongs_to :card_filter
  validates_presence_of :category, :condition, :value
  
  def get_cards    
    if category == 'Characteristic'
      results = CardCharacteristic.find_by_name(value)
      return results.nil? ? [] : results.cards
      
    elsif self.condition == "contains"
      return Card.find(:all, :conditions => [sanitized_category+" LIKE ?", '%'+value+'%'])
    
    elsif CardAttribute.find_by_name(category)
      cards = []
      card_attrs = CardAttribute.find(:all, :conditions => ["name LIKE ? AND value"+condition+"?", sanitized_category, value] )
      card_attrs.each { |c| cards << Card.find(c.card_id) }
      return cards
    
    else
      return Card.find(:all, :conditions => [ "LOWER(?)"+condition+"?", sanitized_category, '%' + value.downcase + '%' ])
    
    end
  end
  
  def proper_category
    category.split('_').each{|word| word.capitalize!}.join(' ')
  end
  
  def sanitized_category
    category.downcase.gsub(" ", "_")
  end
  
  def self.options
    # don't be stupid, do this intelligently
    #options = {}
    #CardAttribute.get_card_attributes.each { |a| options[a.name] = a.to_symbol }
    #return options
    categories = ["Title", "Lore", "Gametext", "Expansion", "Rarity", "Uniqueness", "Card type", "Subtype", "Power", "Ability",
                  "Armor", "Maneuver", "Landspeed", "Hyperspeed", "Destiny", "Deploy", "Forfeit", "Politics", "Characteristic"]
  end
    
end