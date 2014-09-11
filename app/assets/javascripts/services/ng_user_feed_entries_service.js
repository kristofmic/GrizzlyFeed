GrizzlyFeedApp.factory('user_feed_entries', function($http, alerts){
  
  var create = function(id, params, successCallBack){
    params.feed_entry_id = id;
    $http.post('api/user_feed_entries', {feed_entry_id: id, user_feed_entry: params})
    .success(function(data, status, headers, config){
      successCallBack(data);
    })
    .error(function(data, status, headers, config){
      if (data.errors.length > 0 ){ 
        alerts.alert_error(data.errors);
      }
    });
  };

  var update = function(id, params, successCallBack){
    $http.put('api/user_feed_entries/' + id, {user_feed_entry: params})
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
    update: update
  }
  
});