class CreateCardCharacteristics < ActiveRecord::Migration
  def self.up
    create_table :card_characteristics do |t|
      t.string :name
    end
    
    create_table :card_characteristic_connections do |t|
      t.integer :card_id, :null => false, :options =>
        "CONSTRAINT: fk_card_characteristic_connections REFERENCES cards(id)"
      t.integer :card_characteristic_id, :null => false, :options =>
        "CONSTRAINT: fk_card_characteristic_connections REFERENCES card_characteristics(id)"
    end
  end

  def self.down
    drop_table :card_characteristics
    drop_table :card_characteristic_connections
  end
end
