GrizzlyFeedApp.factory('user', function($http, alerts){

  var password_change = function(data, successCallBack){
    $http.put('/api/users/update_pass', data)
    .success(function(data, status, headers, config){
      alerts.alert_success("Password successfully changed");
      successCallBack(data);
    })
    .error(function(data, status, headers, config){
      if (data.errors.length > 0 ){ 
        alerts.alert_error(data.errors);
      }
    });
  };

  var password_forgot = function(email, successCallBack){
    $http.post('/api/users/forgot_pass', {email: email})
    .success(function(data, status, headers, config){
      alerts.alert_success("An email has been sent to " + email + " with instructions on resetting your password.");
      successCallBack(data);
    })
    .error(function(data, status, headers, config){
      if (data.errors.length > 0 ){ 
        alerts.alert_error(data.errors);
      }
    });
  };

  var get_themes = function(successCallBack){
    $http.get('/api/users/themes')
    .success(function(data, status, headers, config){
      successCallBack(data);
    })
    .error(function(data, status, headers, config){
      if (data.errors.length > 0 ){ 
        alerts.alert_error(data.errors);
      }
    });
  }

  var update_theme = function(id, successCallBack){
    $http.put('/api/users/update_theme', {theme_id: id})
    .success(function(data, status, headers, config){
      successCallBack(data);
    })
    .error(function(data, status, headers, config){
      if (data.errors.length > 0 ){ 
        alerts.alert_error(data.errors);
      }
    });
  };

  var layoutData;

  var get_layout_cache = function(){
    return layoutData;
  };

  function set_layout_cache(data){
    layoutData = data;
  };

  var get_layouts = function(successCallBack){
    $http.get('/api/users/layouts')
    .success(function(data, status, headers, config){
      set_layout_cache(data);
      successCallBack(data);
    })
    .error(function(data, status, headers, config){
      if (data.errors.length > 0 ){ 
        alerts.alert_error(data.errors);
      }
    });
  }

  var update_layout = function(id, successCallBack){
    $http.put('/api/users/update_layout', {layout_id: id})
    .success(function(data, status, headers, config){
      successCallBack(data);
    })
    .error(function(data, status, headers, config){
      if (data.errors.length > 0 ){ 
        alerts.alert_error(data.errors);
      }
    });
  };

  var get_welcome_stage = function(successCallBack){
    $http.get('/api/users/welcome')
    .success(function(data, status, headers, config){
      successCallBack(data);
    })
    .error(function(data, status, headers, config){
      if (data.errors.length > 0 ){ 
        alerts.alert_error(data.errors);
      }
    });
  };

  var update_welcome_stage = function(next_stage, successCallBack){
    $http.put('/api/users/next_welcome', {next: next_stage})
    .success(function(data, status, headers, config){
      successCallBack(data);
    })
    .error(function(data, status, headers, config){
      if (data.errors.length > 0 ){ 
        alerts.alert_error(data.errors);
      }
    });
  };

  return {
    password_change: password_change,
    password_forgot: password_forgot,
    get_themes: get_themes,
    update_theme: update_theme,
    get_layouts: get_layouts,
    get_layout_cache: get_layout_cache,
    update_layout: update_layout,
    get_welcome: get_welcome_stage,
    update_welcome: update_welcome_stage
  }
});