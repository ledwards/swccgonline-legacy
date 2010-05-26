class CreateCardAttributes < ActiveRecord::Migration
  def self.up
    create_table :card_attributes do |t|
      t.string :name
      t.integer :value
      
      t.integer :card_id, :options =>
        "CONSTRAINT: fk_card_attribute_cards REFERENCES cards(id)"
    end
  end

  def self.down
    drop_table :card_attributes
  end
end
