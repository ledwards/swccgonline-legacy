module DeckbuilderHelper

  def add_card_filter_item_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :card_filter_items, :partial => 'card_filter_item', :object => CardFilterItem.new
    end
  end

end
