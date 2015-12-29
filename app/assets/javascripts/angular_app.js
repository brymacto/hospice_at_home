angular.module('hospiceAtHome', [])
    .controller('MainCtrl', [
      '$scope',
      function($scope){
        $scope.test = 'Hello world!';


        $scope.matches = [
          {
            id: 16,
            client_id: 7,
            volunteer_id: 14,
            created_at: "2015-12-24T20:08:18.086Z",
            updated_at: "2015-12-24T20:08:18.086Z",
            day: "monday",
            start_time: 9,
            end_time: 12,
            match_request_id: 15
          },
          {
            id: 16,
            client_id: 7,
            volunteer_id: 14,
            created_at: "2015-12-24T20:08:18.086Z",
            updated_at: "2015-12-24T20:08:18.086Z",
            day: "monday",
            start_time: 9,
            end_time: 12,
            match_request_id: 15
          },
          {
            id: 16,
            client_id: 7,
            volunteer_id: 14,
            created_at: "2015-12-24T20:08:18.086Z",
            updated_at: "2015-12-24T20:08:18.086Z",
            day: "monday",
            start_time: 9,
            end_time: 12,
            match_request_id: 15
          }
        ];
      }]);