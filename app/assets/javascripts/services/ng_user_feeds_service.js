GrizzlyFeedApp.factory('user_feeds', function($http, alerts){

  var create = function(id, successCallBack){
    $http.post('/api/user_feeds', {feed_id: id})
    .success(function(data, status, headers, config){
      successCallBack(data);
    })
    .error(function(data, status, headers, config){
      if (data.errors.length > 0 ){ 
        alerts.alert_error(data.errors);
      }
    });
  };

  var destroy = function(id, successCallBack){
    $http.delete('/api/user_feeds/' + id)
    .success(function(data, status, headers, config){
      successCallBack(data);
    })
    .error(function(data, status, headers, config){
      if (data.errors.length > 0 ){ 
        alerts.alert_error(data.errors);
      }
    });
  };

  var update = function(id, requestData, successCallBack){
    $http.put('api/user_feeds/' + id, requestData)
    .success(function(data, status, headers, config){
      successCallBack(data);
    })
    .error(function(data, status, headers, config){
      if (data.errors.length > 0 ){ 
        alerts.alert_error(data.errors);
      }
    });
  };

  var update_all = function(requestData, successCallBack){
    $http.put('api/user_feeds_all', requestData)
    .success(function(data, status, headers, config){
      successCallBack(data);
    })
    .error(function(data, status, headers, config){
      if (data.errors.length > 0 ){ 
        alerts.alert_error(data.errors);
      }
    });
  }

  return {
    create: create,
    destroy: destroy,
    update: update,
    update_all: update_all
  }
  
});