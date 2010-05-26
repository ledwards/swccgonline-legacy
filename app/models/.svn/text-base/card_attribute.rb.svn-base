class CardAttribute < ActiveRecord::Base
    belongs_to :cards
    
    def self.get_card_attributes
        find(:all, :order => :name)
    end
    
    def to_symbol
      return name.downcase.gsub(" ", "_").intern
    end

end
