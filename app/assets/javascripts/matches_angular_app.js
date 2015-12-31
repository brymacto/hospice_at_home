angular.module('matchesAngularApp', ['ngResource'])

    .factory('matchFactory', ['$resource',
      function ($resource) {
        return $resource('/matches.json', {}, {
          query: {method: 'GET', params: {}, isArray: true}
        });
      }])

    .factory('matchProposalFactory', ['$resource',
      function ($resource) {
        return $resource('/match_proposals.json', {}, {
          query: {method: 'GET', params: {}, isArray: true}
        });
      }])

    .factory('orderingService', function() {
      return {
        setOrderAscending: function(orderBy, orderByLast, orderAscending) {
          if (orderByLast === orderBy) {
            return !orderAscending;
          } else {
            return false;
          }
        },

        setOrderProp: function(orderBy) {
          if (orderBy === 'client') {
            return ['client.last_name', 'client.first_name'];
          } else if (orderBy === 'volunteer') {
            return ['volunteer.last_name', 'volunteer.first_name'];
          } else if (orderBy === 'date') {
            return ['day_number', 'start_time'];
          } else {
            return orderBy;
          }
        }
      }
    })

    .controller('MatchCtrl', [
      '$http',
      '$scope',
      'matchFactory',
      'orderingService',
      function ($http, $scope, matchFactory, orderingService) {
        $scope.orderProp = 'client.first_name';
        $scope.orderAscending = false;
        $scope.orderByLast = null;
        $scope.matches = matchFactory.query();

        $scope.setOrder = function (orderBy) {
          $scope.orderAscending = orderingService.setOrderAscending(orderBy, $scope.orderByLast, $scope.orderAscending);
          $scope.orderByLast = orderBy;
          $scope.orderProp = orderingService.setOrderProp(orderBy);
        };

      }])

    .controller('MatchProposalCtrl', [
      '$http',
      '$scope',
      'matchProposalFactory',
      'orderingService',
      function ($http, $scope, matchProposalFactory, orderingService) {
        $scope.orderProp = 'client.first_name';
        $scope.orderAscending = false;
        $scope.orderByLast = null;
        $scope.matchProposals = matchProposalFactory.query();

        $scope.setOrder = function (orderBy) {
          $scope.orderAscending = orderingService.setOrderAscending(orderBy, $scope.orderByLast, $scope.orderAscending);
          $scope.orderByLast = orderBy;
          $scope.orderProp = orderingService.setOrderProp(orderBy);
        };
      }])

    .filter('capitalize', function () {
      return function (input) {
        if (input != null)
          input = input.toLowerCase();
        return input.substring(0, 1).toUpperCase() + input.substring(1);
      }
    })

    .filter('fullDate', function () {
      return function (input) {
        full_date = "";
        full_date += input['day'];
        full_date += ', ';
        full_date += input['start_time'];
        full_date += ' to ';
        full_date += input['end_time'];
        return full_date;
      }
    })
;