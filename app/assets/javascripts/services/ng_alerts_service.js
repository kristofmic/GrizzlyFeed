GrizzlyFeedApp.factory('alerts', function(){

	var alert_error = function(errorsArr){
		var errors = errorsArr.length > 1 ? "errors" : "error";

		var errorList = "";
		for (var i = 0; i < errorsArr.length; i++){
			errorList += "<li>" + errorsArr[i] + "</li>";
		}

		var $alert = angular.element(	"<div class='row flash ng-flash' style='display: none;'>" +
							          					"<div class='alert alert-danger alert-dismissable col-sm-6 col-xs-8 col-sm-offset-3'>" +
							          					"The form contains " + errorsArr.length + " " + errors +
							          					"<button type='button' class='close' onclick=\"$('.ng-flash').slideUp(function(){$(this).remove})\" aria-hidden='true'>&times;</button>" +
							          					"<ul>" + errorList + "</ul>" +
							        						"</div>" + 
							        						"</div>"
							        						);
		insert_element($alert);
	};

	var alert_success = function(message){
		var $alert = angular.element(	"<div class='flash ng-flash row' style='display: none;'>" +
							          					"<div class='alert alert-success alert-dismissable col-sm-6 col-xs-8 col-sm-offset-3'>" +
							          					message + 
							          					"<button type='button' class='close' onclick=\"$('.ng-flash').slideUp(function(){$(this).remove})\" aria-hidden='true'>&times;</button>" +
							        						"</div>" + 
							        						"</div>"
							        						);
		insert_element($alert);
	}

	function insert_element($element){
		$('.flash').remove();
		angular.element('.container').prepend($element);
		$element.slideDown();
		window.setTimeout(function(){ $element.slideUp(function(){$(this).remove}); }, 5000);
	}

	function clear_alerts(){
		if ($('.flash').length > 0){
			window.setTimeout(function(){ $('.flash').slideUp(function(){$(this).remove}); }, 5000);
		}
	}

	return {
		alert_error: alert_error,
		alert_success: alert_success,
		clear_alerts: clear_alerts
	}
});