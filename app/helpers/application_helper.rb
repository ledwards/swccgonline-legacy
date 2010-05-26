# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  include TagsHelper
  
  def format_body(text)
    text.gsub("\n","<br />")
  end
  
  def make_draggable(card_id, options={})
    function = "new Draggable('#{card_id}', {})"
    javascript_tag(function)
  end
  
  def make_droppable() #this function needs parameters
    function = "Droppables.add('test_pile', {
                accept: 'game-card',
                hoverclass: 'hover',
                onDrop: function() {$('test_pile').highlight(); $('test_pile').setStyle({zIndex:'-1'});} })"
  end
  
  def create_static_tooltip(card_id, image_url, options={})
    function = ""
    javascript_tag(function)
  end
  
  def create_floating_tooltip(card_id, image_url, options={})
    function = ""
    javascript_tag(function)
  end
  
  def close_lightbox()
    function = "Lightview.hide();"
    javascript_tag(function)
  end
  
  # JQuery below
  def setup_modal_blanket
    setup_blanket_function = "qTipModalBlanket();"
    javascript_tag(setup_blanket_function)
  end
  
  def create_modal(selector, title, body, close_text)
    modal_function = "qTipModal('"+ selector +"', '"+ title.gsub("'","\\'") +"', '"+ body.gsub("'",'&lsquo') +"', '"+ close_text +"');"   
    javascript_tag(modal_function)
  end
  
  def close_boxy()
    function = "Boxy.get(this).hide(); return false;"
    javascript_tag(function)
  end
  
end
