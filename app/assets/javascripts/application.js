// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require materialize        
//= require jquery
//= require materialize-sprockets
//= require jquery_ujs


$(document).on('turbolinks:load', function() {
    $('.button-collapse').sideNav({
      closeOnClick: true
    });

    // Remove the notice/alert when clicked by the user 
    $('.notice').click(function(){
    	$(this).hide();
    }); 
    $('.alert').click(function(){
    	$(this).hide();
    });

    $('select').material_select();

    $('.alert.alert-danger').show(function(){
      console.log(this);
      $(this).animate({
        backgroundColor: 'red',
        fontSize: "125%"
        }, 2000, function(){
          $(this).animate({
            backgroundColor: 'white',
          }, 1000);
      });
    });
  
  });
