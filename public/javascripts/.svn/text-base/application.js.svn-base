// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Initialize
	
	// Use qTip to create a modal box
	// selector: css selector string
	// title: title as a string
	// body: body of the modal as a string
	function qTipModal(selector, title, body, close_text){
	   $(selector).qtip(
	   {
	      content: {
	         title: {
	            text: title,
	            button: close_text
	         },
	         text: body
	      },
	      position: {
	         target: $(document.body), // Position it via the document body...
	         corner: 'center' // ...at the center of the viewport
	      },
	      show: {
	         when: 'click', // Show it on click
	         solo: true // And hide all other tooltips
	      },
	      hide: false,
	      style: {
	         width: { max: 350 },
	         padding: '14px',
	         border: {
	            width: 9,
	            radius: 9,
	            color: '#666666'
	         },
	         name: 'dark'
	      },
	      api: {
	         beforeShow: function()
	         {
	            // Fade in the modal "blanket" using the defined show speed
	            $('#qtip-blanket').fadeIn(this.options.show.effect.length);
	         },
	         beforeHide: function()
	         {
	            // Fade out the modal "blanket" using the defined hide speed
	            $('#qtip-blanket').fadeOut(this.options.hide.effect.length);
	         }
	      }
	   });
	};

	// Create the modal backdrop on document load so all modal tooltips can use it
	function qTipModalBlanket(){
	   $('<div id="qtip-blanket">')
	      .css({
	         position: 'absolute',
	         top: $(document).scrollTop(), // Use document scrollTop so it's on-screen even if the window is scrolled
	         left: 0,
	         height: $(document).height(), // Span the full document height...
	         width: '100%', // ...and full width

	         opacity: 0.7, // Make it slightly transparent
	         backgroundColor: 'black',
	         zIndex: 5000  // Make sure the zIndex is below 6000 to keep it below tooltips!
	      })
	      .appendTo(document.body) // Append to the document body
	      .hide(); // Hide it initially
	};
	

	// for jQuery compatibility
	jQuery.ajaxSetup({ 
	  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")} 
	});
	
	// Always send the authenticity_token with ajax
	$(document).ajaxSend(function(event, request, settings) {
	  if (typeof(AUTH_TOKEN) == "undefined") return;
	  // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
	  settings.data = settings.data || "";
	  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
	});

	
	
	// When I say html I really mean script for rails
	$.ajaxSettings.accepts.html = $.ajaxSettings.accepts.script;
	
	// for ajax-enabled pagination
	jQuery(document).ready(function($) {
	  $('div.pagination a').livequery('click', function() {
	    $('#search_results').load(this.href)
	    return false
	  })
	});
	
	// Enable tabs
	$(document).ready(function() {
		$('#tabs').tabs();
		$('.decklist #tabs').bind('tabsselect', function(event, ui) {
		  $.post("deckbuilder/switch_tab",
		 		{tab: ui.panel.id, type: 'get', dataType: 'html'}
			);
		});
 	});

	function readyTabs() {
		$('#tabs').tabs();
		$('.decklist #tabs').bind('tabsselect', function(event, ui) {
		  $.post("deckbuilder/switch_tab",
		 		{tab: ui.panel.id, type: 'get', dataType: 'html'}
			);
		});
	}