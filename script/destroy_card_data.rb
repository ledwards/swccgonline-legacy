#!/usr/bin/env ruby
require 'config/environment'

#puts "Destroying current card data..."
for card in Card.get_cards
  card.destroy
end
for card_characteristic in CardCharacteristic.get_card_characteristics
  card_characteristic.destroy
end
for card_characteristic_connection in CardCharacteristicConnection.get_card_characteristic_connections
  card_characteristic_connection.destroy
end
for card_attribute in CardAttribute.get_card_attributes
  card_attribute.destroy
end