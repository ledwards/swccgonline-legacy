$.editInPlace = {
  tags : {
    waitText    : function(){
      return 'Wait...';
    },
    saveText    : function(){
      return 'Save';
    },
    savingText  : function(){
      return 'Saving...';
    },
    cancelText  : function(){
      return 'Cancel';
    },
    orText      : function(){
      return 'or';
    },
    wait        : function(){
      return "<span>"+this.waitText()+"</span>";
    },
    save        : function(){
      return "<input type='submit' value='"+this.saveText()+"'/>";
    },
    cancel      : function(){
      return "<a href='#'>"+this.cancelText()+"</a>";
    },
    otherwise   : function(){
      return "<span>"+this.orText()+"</span>";
    },
    form        : function(action, token){
      return "<form action='"+action+"' method='post'>"
        + "<input type='hidden' name='_method' value='put'/>"
        + "<input type='hidden' name='authenticity_token' value='"+token+"'/>"
      + "</form>";
    },
    field       : function(name, data, type){
      if(type == "text"){
        return this.textArea(name, data);
      } else { //string
        return this.textField(name, data);
      }
      //TODO - add more types
    },
    textField   : function(name, data){
      return "<input type='text' name='"+name+"' value='"+data+"'/>";
    },
    textArea    : function(name, data){
      return "<p><textarea name='"+name+"' rows='9'>"+data+"</textarea></p>";
    },
    actions     : function(){
      return "<div></div>";
    },
    saving      : function(){
      return "<span>"+this.savingText()+"</span>";
    },
    error       : function(message){
      return "<div><p>"+message+"</p></div>";
    }
  },
  
  animations : {
    formAppear    : function(form, field, elm){
      $(".eip-wait").hide();
      elm.fadeOut("fast");
      elm.queue(function(){
        form.fadeIn("fast");
        form.queue(function(){
          field.select();
          $(this).dequeue();
        });
        $(this).dequeue();
      });
    },
    formSubmit    : function(form, field, actions){
      form.addClass('.eip-submitted');
      actions.hide();
    },
    formDisappear : function(form, elm, trigger){
      form.fadeOut("fast");
      $(".eip-error").hide("fast");
      form.queue(function(){
        elm.fadeIn("fast");
        trigger.show();
        form.remove();
        $(this).dequeue();
      });
    },
    formError     : function(error){
      error.show(800);
      function hide(){ error.hide(800); }
      setTimeout(hide, 5000);
    }
  },
  
  formatOptions : function(element, options){
    if(!options.token) throw "Missing authenticity token";
    if(!options.url) throw "Missing url for inplace form action";
    if(!options.model) throw "Missing model for in place editing";
    if(!options.attr) throw "Missing attribute for in place editing";
    
    return $.extend(options, {
      data : options.data || $.trim($(element).text()),
      type : options.type || "string",
      fieldName : options.model+"["+options.attr+"]"
    });
  }
};

$.fn.editInPlace = function(options){
  if(!this.attr("id")) return this;
  
  try{
    var opt = $.editInPlace.formatOptions(this, options);
    var elm = $(this);
    var tags = $.editInPlace.tags;
    var anims = $.editInPlace.animations;
    var trigger = $('#eip_'+opt.model+'-'+opt.attr+'_trigger');
    var form = $(tags.form(opt.url, opt.token)).addClass('eip-form');
    var field = $(tags.field(opt.fieldName, opt.data, opt.type)).addClass('eip-field');
    var actions = $(tags.actions()).addClass('eip-form-actions');
    var save = $(tags.save()).addClass('eip-save').addClass('save');
    var cancel = $(tags.cancel()).addClass('eip-cancel').addClass('cancel');
    var otherwise = $(tags.otherwise()).addClass('eip-or');
    var saving = $(tags.saving()).addClass('eip-saving');
    
    field.prependTo(form);
    cancel.prependTo(actions);
    otherwise.prependTo(actions);
    save.prependTo(actions);    
    actions.appendTo(form);
    field.after(saving);
    elm.after(form);
    form.hide();
    saving.hide();
    
    save.click(function(){ form.submit(); return false; });
    cancel.click(function(){ anims.formDisappear(form, elm, trigger); return false; });
    form.submit(function(){
      try{
        anims.formSubmit(form, field, actions);
        saving.show();
        $.ajax({
          url : opt.url,
          type : "POST",
          dataType : "json",
          data : form.serializeArray(),
          success : function(jsonObj, status){
            elm.html(jsonObj[opt.attr]);
            anims.formDisappear(form, elm, trigger);
          },
          error : function(request, status, error){
            $(eval(request.responseText)).each(function(i,value){
              error = $(tags.error(value)).addClass('eip-error');
              form.after(error);
              error.hide();
              actions.fadeIn("fast");
              anims.formError(error);
            });
          },
          complete : function(){
            saving.hide();
          }
        });
      } catch(e){
        console.log(e);
        anims.formDisappear(form, elm, trigger);
      }
      return false;
    });
    
    anims.formAppear(form, field, elm);
  }
  catch(e){ console.log(e); }
  
  return this;
};

$(function(){
  $('.trigger').click(function(){
    $.getScript($(this).attr("href"));
    $(this).hide().after($($.editInPlace.tags.wait()).addClass('eip-wait'));
    return false;
  });
});