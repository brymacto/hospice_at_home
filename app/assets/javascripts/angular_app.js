angular.module('hospiceAtHome', [])
    .controller('MainCtrl', [
      '$http',
      '$scope',
      function($http, $scope, matches){
        $scope.test = 'Hello world!';

        $http.get('/matches.json').success(function(data) {
          $scope.matches = data;
        });
      }])
    .filter('capitalize', function() {
      return function(input, scope) {
        if (input!=null)
          input = input.toLowerCase();
        return input.substring(0,1).toUpperCase()+input.substring(1);
      }
    });;