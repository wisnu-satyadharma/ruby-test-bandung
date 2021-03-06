// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require prefixfree.min
//= require bootstrap.min
//= require jquery-ui.min
//= require chart.min
//= require easypiechart
//= require bootstrap-datepicker
//= require jquery.easytree.min
//= require_tree .


$(document).ready(function(){
	$(".notification").on("click", function(){
		$(this).parent().fadeOut(function(){
			$(this).parent().remove();	
		});		
		return false;
	});

	$(".confirmation_dialog").on("click", function(){
		if (confirm('Are you sure ?')) {
       return true;
    }else{
    	return false;
    }		
	});

	$(".ajax_loading").on("click", function(){
		$(".file_contain:visible").html("<img src='/assets/loading.gif' />");		
	});
	

	$(".easytree-title a").on("click", function(){
		$(".file_contain:visible").html("<img src='/assets/loading.gif' />");
		$.ajax({url: $(this).attr("href"),dataType:"script"});		
		return false;
	});


});
	
	
	
	
	
	
	

