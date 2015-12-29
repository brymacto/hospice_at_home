angular.module('hospiceAtHome', [])
    .controller('MainCtrl', [
      '$http',
      '$scope',
      function($http, $scope, matches){
        $scope.test = 'Hello world!';

        $http.get('/matches.json').success(function(data) {
          $scope.matches = data;
        });
        //$scope.matches = matches.matches;
      }]);