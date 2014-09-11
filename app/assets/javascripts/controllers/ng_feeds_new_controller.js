function FeedsNewCtrl($scope, user, feeds, user_feeds, alerts){

	/* Main */
  var browseFeeds = [];
  $scope.feeds = [];
  var set = 0;
  var rows = 7;
  var cols = 4;
  var feed_height = 156;
 
  get_feeds_to_browse();
  set_scroll_listener();
  

  user_welcome_stage();

  alerts.clear_alerts();
  /* End Main */

  /* Helpers */
  function get_feeds_to_browse(){
    var limit = cols*rows || 28;

  	feeds.browse(limit, limit*set++, function(data){
  		$scope.feeds = $scope.feeds.concat(data);
      browseFeeds = $scope.feeds;
      $scope.searchResults = false;
    });
  }

  $scope.update_timestamp = function(datetimestring){
    return feeds.update_timestamp(datetimestring);
  }

  function user_welcome_stage(){
    user.get_welcome(function(response){
      if (response.welcome_stage > 0){
        welcome_guide(response.welcome_stage);
      }
    });
  }

  function set_scroll_listener(){
    $(window).scroll(function(){
      if(window.scrollY+window.innerHeight >= feed_height*rows*set){
        get_feeds_to_browse();
      }
    });
  }

  function cancel_scroll_listener(){
    $(window).off('scroll');
  }

  window.welcome_guide = function(stage){
    switch (stage){
      case 4:
        $('.new-feed-forms-container').popover({
          html: true,
          placement: 'bottom', 
          trigger: 'manual',
          container: '.container',
          content: '<p>Search for feeds here.</p>' +
                   '<p>Can\x27t find the feed you want? Click the <span class="glyphicon glyphicon-link"></span> icon to the right to manually add an RSS or Atom feed from a valid URL.</p>' +
                   '<a class="btn btn-primary" onclick="$(\x27.new-feed-forms-container\x27).popover(\x27destroy\x27); welcome_guide(5);">Next</a>'+
                   '<button class="btn btn-link btn-sm" onclick="$(\x27.new-feed-forms-container\x27).popover(\x27destroy\x27); welcome_guide(11)">I\x27m done</button>'
        });

        $('.new-feed-forms-container').popover('show');
        break;
      case 5:
        user.update_welcome(stage, function(data){});
        $($('.new-feed .icons')[1]).popover({
          html: true,
          placement: 'bottom',
          trigger: 'manual',
          container: '.container',
          content: '<p>Browse through and select your favorite feeds.</p>' +
                   '<p>Click the plus icon to add the feed content to your dashboard.</p>' + 
                   '<button class="btn btn-primary" onclick="$(\x27.new-feed .icons\x27).popover(\x27destroy\x27); $($(\x27.new-feed .icons .icon.glyphicon-plus-sign\x27)[1]).click(); welcome_guide(6);">Add feed</button>'+
                   '<button class="btn btn-link btn-sm" onclick="$($(\x27.new-feed .icons\x27)[1]).popover(\x27destroy\x27); welcome_guide(11)">I\x27m done</button>'
        });

        $($('.new-feed .icons')[1]).popover('show');
        break;
      case 6:
        user.update_welcome(stage, function(){});
        $($('.new-feed .icons')[1]).popover({
          html: true,
          placement: 'bottom',
          trigger: 'manual',
          container: '.container',
          content: '<p>Great! Your first feed has been added and will appear on your dashboard.</p>' +
                   '<button class="btn btn-primary" onclick="$(\x27.new-feed .icons\x27).popover(\x27destroy\x27); welcome_guide(7);">Go to dashboard</button>'+
                   '<button class="btn btn-link btn-sm" onclick="$($(\x27.new-feed .icons\x27)[1]).popover(\x27destroy\x27); welcome_guide(11)">I\x27m done</button>'
        });

        $($('.new-feed .icons')[1]).popover('show');
        break;
      case 7:
        user.update_welcome(stage, function(data){
          window.location = $('#feed_index').attr('href');
        });
        break;
      case 11:
        user.update_welcome(0, function(data){});
        break;
    }
  };

  /* End Helpers */

  /* Events */
  $scope.add_user_feed = function(feed){
    user_feeds.create(feed.id, function(data){
      feed.added = true;
      feed.subscribers = data.feed.subscribers;
    });
  }

  $scope.remove_user_feed = function(feed){
    user_feeds.destroy(feed.id, function(data){
      feed.added = false;
      feed.subscribers = data.feed.subscribers;
    });
  }

  $scope.search = function(query){
    $scope.query = query;
    $scope.searchView = true;
    if(!query){
      $scope.feeds = browseFeeds;
      $scope.searchResults = false;
      set_scroll_listener();
    }else{
      feeds.search(query, function(data){
        $scope.searchResults = true;
        $scope.feeds = data;
        cancel_scroll_listener();
      });
    }
  }

  $scope.add_feed = function(){
    request = {feed_url: $scope.feed_url, categories: $scope.query}
    feeds.add(request, function(data){
      $scope.feeds.push(data);
      $scope.feed_url = undefined;
    });
  }

  $scope.toggle_add = function(){
    $('.new-feed-forms').animate({marginTop: '-50px'}, {duration: 200});
  }

  $scope.toggle_search = function(){
    $('.new-feed-forms').animate({marginTop: '0px'}, {duration: 200});
  }
  /* End Events */
}

GrizzlyFeedApp.controller('FeedsNewCtrl', ['$scope', 'user', 'feeds', 'user_feeds', 'alerts', FeedsNewCtrl]);








