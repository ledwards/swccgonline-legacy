class Card < ActiveRecord::Base
  has_many :deck_items
  has_many :card_attributes
  has_many :card_characteristic_connections
  has_many :card_characteristics, :through => :card_characteristic_connections

  def shortened_title(n)
    if self.title.length > n
      suffix = "..."
    else
      suffix = ""
    end
    return self.title.first(n) + suffix
  end

  def cards_wiki_url
    url = "http://www.swccgpc.com/wiki/index.php?title="+title.sub(' ','_')
  end
  
  def large_image_url
    image_front_url
  end
  
  def type_and_subtype
    if subtype.nil?
      type_and_subtype = card_type
    else
      type_and_subtype = card_type + ' - ' + subtype
    end
    return type_and_subtype
  end
  
  def self.get_cards
    find(:all)
  end
  
  def self.get_cards_by_side(side)
    find(:all, :conditions => ["side = ?", side])
  end
  
  def self.find_all_by_user_input(title, side = nil, expansion = nil)
    # title is mandatory, side and expansion are not
    # this is where we would implement nicknames if possible
    results = self.find_all_by_title(title)
    # TODO: if results is empty, check the list of nickname
    
    if results.is_a? Array and results.length > 1 and side
      results = results.find_all {|card| card.side == side}
    end

    if results.is_a? Array and results.length >1 and expansion
      results = results.find_all {|card| card.expansion == expansion}
    end
    
    if results.is_a? Array: return results else return [results]
    end
  end
  
end
