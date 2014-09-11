function FeedsCtrl($scope, feeds, user, user_feeds, user_feed_entries, alerts){
	var columns = 3 
  var refreshing; 

  /* Main */
  index();
  get_layouts();
  user_welcome_stage();
  alerts.clear_alerts();
  /* End Main */

  /* Helpers */
  function index(){
    if (feeds.get_index_cache()) {
      map_scope_data(feeds.get_index_cache());
    } else {
      set_refresh_animation();
      feeds.index(function(data){
        map_scope_data(data);
        clear_refresh_animation();
      });
    }
  }

  function map_scope_data(data){
    $scope.last_updated = feeds.update_timestamp(data.updated);
    $scope.feeds = {};
    for(var i = 1; i <= columns; i++){
      $scope.feeds['col'+i] = data[i];
    }
  }

  function find_feed(feed){
  	return $.inArray(feed, $scope.feeds['col'+feed.column]);
  }

  function get_layouts(){ 
    if (user.get_layout_cache()){
      $scope.layouts = user.get_layout_cache();
    } else {
      user.get_layouts(function(data){
        $scope.layouts = data;
      });
    }
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

  function user_welcome_stage(){
    user.get_welcome(function(response){
      if (response.welcome_stage > 0){
        welcome_guide(response.welcome_stage);
      }
    });
  }

  window.welcome_guide = function(stage){
    switch (stage){
      case 1:
        var stopWatch = $scope.$watch('feeds', function(newVal, oldVal){
          if($scope.feeds['col1'].length === 0 && $scope.feeds['col2'].length === 0 && $scope.feeds['col3'].length === 0){
            $($('.feed-column')[1]).popover({
              html: true,
              placement: 'bottom',
              trigger: 'manual',
              container: '.container',
              content: '<p>Welcome to Grizzly Feed!</p>' + 
                       '<p>Would you like to take a brief tour?</p>' + 
                       '<button class="btn btn-primary" onclick="$($(\x27.feed-column\x27)[1]).popover(\x27destroy\x27); welcome_guide(2)">Begin</button>' +
                       '<button class="btn btn-link btn-sm" onclick="$($(\x27.feed-column\x27)[1]).popover(\x27destroy\x27); welcome_guide(11)">No thanks</button>'
            });
            $($('.feed-column')[1]).popover('show');
            $('.popover .arrow').remove();
          } else {
            user.update_welcome(0, function(data){});
          }
          stopWatch();
        });
        break;
      case 2:
        user.update_welcome(stage, function(data){});
        $($('.feed-column')[1]).popover({
          html: true,
          placement: 'bottom',
          trigger: 'manual',
          container: '.container',
          content: '<p>This is your dashboard where your feeds will live.</p>' + 
                   '<button class="btn btn-primary" onclick="$($(\x27.feed-column\x27)[1]).popover(\x27destroy\x27); welcome_guide(3)">Next</button>'+
                   '<button class="btn btn-link btn-sm" onclick="$($(\x27.feed-column\x27)[1]).popover(\x27destroy\x27); welcome_guide(11)">I\x27m done</button>'
        });
        $($('.feed-column')[1]).popover('show');
        break;
      case 3:
        user.update_welcome(stage, function(data){});
        $('#add_feed_popover').popover({
          html: true,
          placement: 'bottom', 
          trigger: 'manual',
          container: '.container',
          content: '<p>You can add feeds from your favorite news and entertainment sources to your dashboard here.</p>' +
                   '<button class="btn btn-primary"  onclick="event.preventDefault(); welcome_guide(4)" >Take me there</button>'+
                   '<button class="btn btn-link btn-sm" onclick="$(\x27#add_feed_popover\x27).popover(\x27destroy\x27); welcome_guide(11)">I\x27m done</button>'
        });
        $('#add_feed_popover').popover('show');
        break;
      case 4:
        user.update_welcome(stage, function(data){
          window.location = $('#add_feed').attr('href');
        });
        break;
      case 7:
        var stopWatch = $scope.$watch('feeds', function(newVal, oldVal){
          if($scope.feeds['col1'].length > 0 || $scope.feeds['col2'].length > 0 || $scope.feeds['col3'].length > 0){
            $($('.panel .icons .icon')[0]).show();
            $($('.panel .icons .icon')[1]).show();
            $($('.panel .icons .icon')[1]).popover({
              html: true,
              placement: 'bottom', 
              trigger: 'manual',
              container: '.container',
              content: '<p>Click the <span class="glyphicon glyphicon-cog"></span> icon to edit your feed settings or remove a feed.</p>' +
                       '<p>You can also drag and drop the location of the feed using the handle to the right of the cog.</p>' +
                       '<button class="btn btn-primary"  onclick="$($(\x27.panel .icons .icon\x27)[1]).popover(\x27destroy\x27); welcome_guide(8)" >Next</button>'+
                   '<button class="btn btn-link btn-sm" onclick="$($(\x27.panel .icons .icon\x27)[1]).popover(\x27destroy\x27); welcome_guide(11)">I\x27m done</button>'
            });
            $($('.panel .icons .icon')[1]).popover('show');
            stopWatch();
          }
        });
        break;
      case 8:
        user.update_welcome(stage, function(data){});
        $($('.panel .icons .icon')[0]).css('display', '');
        $($('.panel .icons .icon')[1]).css('display', '');
        $('#layouts').popover({
          html: true,
          placement: 'bottom', 
          trigger: 'manual',
          container: '.container',
          content: '<p>You can adjust the visual layout of all the feeds to suit your preference.</p>' +
                   '<button class="btn btn-primary"  onclick="$(\x27#layouts\x27).popover(\x27destroy\x27); welcome_guide(9)" >Next</button>'+
                   '<button class="btn btn-link btn-sm" onclick="$(\x27#layouts\x27).popover(\x27destroy\x27); welcome_guide(11)">I\x27m done</button>'
        });
        $('#layouts').popover('show');
        break;
      case 9:
        user.update_welcome(stage, function(data){});
        $('#refresh').parent().popover({
          html: true,
          placement: 'bottom', 
          trigger: 'manual',
          container: '.container',
          content: '<p>Feeds are updated regularly. You can also manually update them by clicking the <span class="glyphicon glyphicon-refresh"></span> icon.</p>' +
                   '<button class="btn btn-primary"  onclick="$(\x27#refresh\x27).parent().popover(\x27destroy\x27); welcome_guide(10)" >Next</button>'+
                   '<button class="btn btn-link btn-sm" onclick="$(\x27#layouts\x27).popover(\x27destroy\x27); welcome_guide(11)">I\x27m done</button>'
        });
        $('#refresh').parent().popover('show');
        break;
      case 10:
        user.update_welcome(stage, function(data){});
        $($('footer .navbar-right a')[0]).popover({
          html: true,
          placement: 'top', 
          trigger: 'manual',
          container: '.container',
          content: '<p>That wraps up the tour! If you like what you see, consider a small donation to help keep the lights on.</p>' +
                   '<button class="btn btn-primary"  onclick="$($(\x27footer .navbar-right a\x27)[0]).popover(\x27destroy\x27); welcome_guide(11)" >Done</button>'
        });
        $($('footer .navbar-right a')[0]).popover('show');
        break;
      case 11:
        user.update_welcome(0, function(data){});
        break;
    }
  };

  function set_refresh_animation(){
    var el = angular.element('#refresh');
    el.animateRotate(360, 1200, 'linear');
    refreshing = window.setInterval(function(){ el.animateRotate(360, 1200, 'linear'); }, 1200);
    $scope.updating = true;
  }

  function clear_refresh_animation(){
    window.clearInterval(refreshing);
    $scope.updating = false;
  }

  /* End Helpers */

  /* Events */
  $scope.edit_feed = function(feed){
  	$scope.editFeed = feed;
  	$scope.entries = feed.entries.length
  	$scope.removeFeed = false;
  	$('#edit-feed-modal').modal();
  }

  $scope.edit_feed_save = function(){
  	if($scope.removeFeed){
  		user_feeds.destroy($scope.editFeed.id, function(data){
  			var index = find_feed($scope.editFeed)
  			if(index !== -1){
  				$scope.feeds['col'+$scope.editFeed.column].splice(index, 1);
  			}
  		});
  	}else{
  		user_feeds.update($scope.editFeed.id, {entries: $scope.entries}, function(data){
  			var index = find_feed($scope.editFeed)
  			if(index !== -1){
  				$scope.feeds['col'+$scope.editFeed.column][index].entries = data.feed.entries;
  			}
  		});
  	}
  }

  $scope.update_positions = function(){
  	positions = [];
    for(var i = 1; i <= columns; i++){
      for(var j = 0; j < $scope.feeds['col'+i].length; j++){
      	$scope.feeds['col'+i][j].column = i;
      	$scope.feeds['col'+i][j].row = (j+1);
        positions.push({ id: $scope.feeds['col'+i][j].id, row: (j+1), column: i });
      }
    }
    user_feeds.update_all({positions: positions}, function(data){});
  }

  $scope.refresh = function(event){
    set_refresh_animation();
    
    feeds.refresh(function(data){
      for(var i = 1; i <= columns; i++){
        for(var j = 0; j < $scope.feeds['col'+i].length; j++){
          $scope.feeds['col'+i][j].entries = data.feeds[$scope.feeds['col'+i][j].id];
        }
      }
      $scope.last_updated = feeds.update_timestamp(data.updated);
      
      clear_refresh_animation();
    });
  }

  $scope.expand = function(event, entry){
    angular.element(event.target).toggleClass('expanded');
    if(!entry.expand){
      entry.expand = true;
      if(!entry.visited){
        user_feed_entries.create(entry.id, {viewed: true}, function(data){});
      }else{
        user_feed_entries.update(entry.id, {viewed: true}, function(data){});
      }
      entry.visited = true;
    }else{
      entry.expand = false;
    }
  }

  $scope.visit = function(entry){
    if(!entry.visited){
      user_feed_entries.create(entry.id, {visited: true}, function(data){});
      entry.visited = true;
    }else{
      user_feed_entries.update(entry.id, {visited: true}, function(data){});
    }
  }

  $scope.mark_as_read = function(entry){
    if(!entry.visited){
      user_feed_entries.create(entry.id, {marked_as_viewed: true}, function(data){});
      entry.visited = true;
    }
  }

  $scope.active_layout = function(){
    if ($scope.layouts){
      for (var i = 0; i < $scope.layouts.length; i++){
        if ($scope.layouts[i].active) {
          return $scope.layouts[i].name.toLowerCase();
        }
      }
    }
  }

  $scope.update_layout = function(layout){
    user.update_layout(layout.id, function(data){
      for (var i = 0; i < $scope.layouts.length; i++){
        $scope.layouts[i].active = false;
      }
      layout.active = true;
    });
  }
  /* End Events */
}

GrizzlyFeedApp.controller('FeedsCtrl', ['$scope', 'feeds', 'user', 'user_feeds', 'user_feed_entries', 'alerts', FeedsCtrl]);













