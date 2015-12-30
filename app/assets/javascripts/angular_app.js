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
        $scope.orderAscending = false;
        $scope.orderAscendingClient = false;
        $scope.orderAscendingVolunteer = false;
        $scope.orderAscendingDate = false;
        $scope.matches = matchFactory.query(function () {
          generateDayNumbers($scope.matches);
        });

        var day_numbers = {
          'sunday': 0,
          'monday': 1,
          'tuesday': 2,
          'wednesday': 3,
          'thursday': 4,
          'friday': 5,
          'saturday': 6
        };

        function generateDayNumbers (collection) {
          angular.forEach(collection, function(object) {
            object.day_number = day_numbers[object.day];
          });
        }

        $scope.setOrder = function(orderBy) {
          if (orderBy === 'client') {
            $scope.orderProp = ['client.last_name', 'client.first_name'];
            $scope.orderAscendingClient = !$scope.orderAscendingClient;
            $scope.orderAscending = $scope.orderAscendingClient;
          } else if (orderBy === 'volunteer') {
            $scope.orderProp = ['volunteer.last_name', 'volunteer.first_name'];
            $scope.orderAscendingVolunteer = !$scope.orderAscendingVolunteer;
            $scope.orderAscending = $scope.orderAscendingVolunteer;
          } else if (orderBy === 'date') {
            $scope.orderProp = ['day_number', 'start_time'];
            $scope.orderAscendingDate = !$scope.orderAscendingDate;
            $scope.orderAscending = $scope.orderAscendingDate;
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