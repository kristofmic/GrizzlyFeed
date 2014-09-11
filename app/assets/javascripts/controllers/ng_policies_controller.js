function PoliciesCtrl($scope, alerts){
  /* Main */
  $scope.terms = true;
  $scope.privacy = false;
  alerts.clear_alerts();
  /* End Main */

  /* Helpers */
  /* End Helpers */

  /* Events */
  $scope.toggle = function(){
    $scope.terms = !$scope.terms;
    $scope.privacy = !$scope.privacy;
  }
  /* End Events */
}

GrizzlyFeedApp.controller('PoliciesCtrl', ['$scope', 'alerts', PoliciesCtrl]);