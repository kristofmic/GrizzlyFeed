GrizzlyFeedApp.factory('feeds', function($http, alerts){
  
  var indexData;

  var get_index_cache = function(){
    return indexData;
  };

  function set_index_cache(data){
    indexData = data;
  };

  var index = function(successCallBack){
    $http.get('/api/feeds')
    .success(function(data, status, headers, config){
      set_index_cache(data);
      successCallBack(data);
    })
    .error(function(data, status, headers, config){
      if (data.errors.length > 0 ){ 
        alerts.alert_error(data.errors);
      }
    });
  };

  var refresh = function(successCallBack){
    $http.get('/api/feeds/refresh')
    .success(function(data, status, headers, config){
      set_index_cache(data);
      successCallBack(data);
    })
    .error(function(data, status, headers, config){
      if (data.errors.length > 0 ){ 
        alerts.alert_error(data.errors);
      }
    });
  }

  var browse = function(limit, offset, successCallBack){
    $http.get('/api/feeds/browse', {params: {limit: limit, offset: offset}})
    .success(function(data, status, headers, config){
      successCallBack(data);
    })
    .error(function(data, status, headers, config){
      if (data.errors.length > 0 ){ 
        alerts.alert_error(data.errors);
      }
    });
  }

  var update_timestamp = function(datestring){
    var lastUpdated = new Date(datestring);
    return lastUpdated.toDateString() + " at " + lastUpdated.toLocaleTimeString().replace(/:\d+ (\w\w)$/, '$1');
  }

  var search = function(searchParams, successCallBack){
    $http.post('/api/feeds/search', {search: searchParams})
    .success(function(data, status, headers, config){
      successCallBack(data);
    })
    .error(function(data, status, headers, config){
      if (data.errors.length > 0 ){ 
        alerts.alert_error(data.errors);
      }
    });
  }

  var add = function(data, successCallBack){
    $http.post('/api/feeds', data)
    .success(function(data, status, headers, config){
      alerts.alert_success('Feed successfully added');
      successCallBack(data);
    })
    .error(function(data, status, headers, config){
      if (data.errors.length > 0 ){ 
        alerts.alert_error(data.errors);
      }
    });
  }

  var get_feed_entries = function(limit, offset, successCallBack){
    $http.get('/api/feeds/home', {params: {limit: limit, offset: offset}})
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
    index: index,
    get_index_cache: get_index_cache,
    refresh: refresh,
    browse: browse,
    update_timestamp: update_timestamp,
    search: search,
    add: add,
    get_feed_entries: get_feed_entries
  }
  
});