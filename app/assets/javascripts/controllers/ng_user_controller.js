function UserCtrl($scope, user, alerts){
  /* Main */
  $scope.password = false;
  get_themes();
  //alerts.clear_alerts();
  /* End Main */

  /* Helpers */
  function get_themes(){
    user.get_themes(function(data){
      $scope.themes = data;
    });
  }
  /* End Helpers */

  /* Events */
  $scope.change_pw = function(){
    data = {
      current_password: $scope.current_password,
      password: $scope.new_password,
      password_confirmation: $scope.password_confirmation
    };
    user.password_change(data, function(response){
      $scope.current_password = undefined;
      $scope.new_password = undefined;
      $scope.password_confirmation = undefined;
    });
  };

  $scope.forgot_pw = function(){
    user.password_forgot($scope.resetEmail, function(response){
      console.log(response);
    })
    $scope.resetEmail = "";
  };

  $scope.update_theme = function(theme){
    user.update_theme(theme.id, function(data){
      for (var i = 0; i < $scope.themes.length; i++){
        $scope.themes[i].active = false;
      }
      theme.active = true;
      document.getElementsByTagName('body')[0].className = 'theme-' + theme.style;
    });
  }
  /* End Events */
}

GrizzlyFeedApp.controller('UserCtrl', ['$scope', 'user', 'alerts', UserCtrl])