angular.module('hospiceAtHome', ['ngResource'])
    .factory('matchFactory', ['$resource',
      function ($resource) {
        return $resource('/matches.json', {}, {
          query: {method: 'GET', params: {}, isArray: true}
        });
      }])
    .controller('MainCtrl', [
      '$http',
      '$scope',
      'matchFactory',
      function ($http, $scope, matchFactory, matches) {
        $scope.orderProp = 'client.first_name';
        $scope.matches = matchFactory.query();

        $scope.setOrder = function(orderBy) {
          if (orderBy === 'client') {
            $scope.orderProp = ['client.last_name', 'client.first_name'];
          } else if (orderBy === 'volunteer') {
            $scope.orderProp = ['volunteer.last_name', 'volunteer.first_name'];
          } else if (orderBy === 'date') {
            //var dates = {
            //  'monday': 0,
            //  'tuesday': 1,
            //  'wednesday': 2,
            //  'thursday': 3,
            //  'friday': 4,
            //  'saturday': 5,
            //  'sunday': 6,
            //}
            $scope.orderProp = ['start_time'];
          }
        };
      }])
    .filter('capitalize', function () {
      return function (input) {
        if (input != null)
          input = input.toLowerCase();
        return input.substring(0, 1).toUpperCase() + input.substring(1);
      }
    })
    .filter('full_date', function() {
      return function (input) {
        full_date = "";
        full_date += input['day'];
        full_date += ' ';
        full_date += input['start_time'];
        full_date += ' to ';
        full_date += input['end_time'];
        return full_date;
      }
    })
;