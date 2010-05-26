class CreateDeckItems < ActiveRecord::Migration
  def self.up
    create_table :deck_items do |t|
      t.integer :card_id, :null => false, :options =>
        "CONSTRAINT fk_deck_item_cards REFERENCES cards(id)"
      t.integer :deck_id, :null => false, :options =>
        "CONSTRAINT fk_deck_item_decks REFERENCES decks(id)"
        
      t.integer :quantity, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :deck_items
  end
end
