function HomeCtrl($scope, feeds, alerts){
  var columns = 3  
  var set = 0;
  var limit = 28;
  var min_height = 90*(limit/columns);
  $scope.feed_entries = {};

  /* Main */
  get_feed_entries();

  $(window).scroll(function(){
    var $last_children = $('.feed-column .feed-entry:last-child');
    if ($last_children.length > 0){
      var top_of_bottom_feed = Math.min($last_children[0].offsetTop, $last_children[1].offsetTop, $last_children[2].offsetTop);
      if(window.scrollY+window.innerHeight >= (min_height)){
        get_feed_entries();
        min_height = 90*(limit/columns) + top_of_bottom_feed;
      }
    }
  });

  alerts.clear_alerts();
  /* End Main */

  /* Helpers */
  function get_feed_entries(){
    feeds.get_feed_entries(limit, limit*set++, function(data){
      for(var i = 1; i <= columns; i++){
        if ($scope.feed_entries['col'+i]){
          $scope.feed_entries['col'+i] = $scope.feed_entries['col'+i].concat(data[i]);
        }else {
          $scope.feed_entries['col'+i] = data[i];
        }
      }
    });
  }

  $scope.update_timestamp = function(datetimestring){
    return feeds.update_timestamp(datetimestring);
  }

  $scope.show_author = function(entry){
    if(entry.author){
      return true;
    }
    return false;
  }

  /* End Helpers */

  /* Events */

  /* End Events */
}

GrizzlyFeedApp.controller('HomeCtrl', ['$scope', 'feeds', 'alerts', HomeCtrl]);












