//= require 'angular-resource'

describe('MatchCtrl', function () {
  var scope, ctrl, $httpBackend;

  beforeEach(function () {
    jasmine.addMatchers({
      toEqualData: function () {
        return {
          compare: function (actual, expected) {
            return {
              pass: angular.equals(actual, expected)
            };
          }
        };
      }
    });
  });

  beforeEach(inject(function (_$httpBackend_, $rootScope, $controller) {
    $httpBackend = _$httpBackend_;
    $httpBackend.expectGET('/matches.json').
    respond(
        [
          {
            id: 1,
            day: "monday",
            day_number: 1,
            start_time: 9,
            end_time: 12,
            volunteer: {
              id: 14,
              last_name: "Dietrich",
              first_name: "Anna"
            },
            client: {
              id: 7,
              last_name: "Adams",
              first_name: "Golda"
            }
          },
          {
            id: 2,
            day: "friday",
            day_number: 5,
            start_time: 9,
            end_time: 13,
            volunteer: {
              id: 30,
              last_name: "Lind",
              first_name: "Brendon"
            },
            client: {
              id: 27,
              last_name: "Barrows",
              first_name: "Arturo"
            }
          }
        ]
    );

    scope = $rootScope.$new();
    ctrl = $controller('MatchCtrl', {$scope: scope});
  }));

  it('sets acsending order to false', function () {
    expect(scope.orderAscending).toBe(false);
  });

  it('creates a matches model with two matches', function () {
    expect(scope.matches).toEqualData([]);
    $httpBackend.flush();
    expect(scope.matches).toEqualData(
        [
          {
            id: 1,
            day: "monday",
            day_number: 1,
            start_time: 9,
            end_time: 12,
            volunteer: {
              id: 14,
              last_name: "Dietrich",
              first_name: "Anna"
            },
            client: {
              id: 7,
              last_name: "Adams",
              first_name: "Golda"
            }
          },
          {
            id: 2,
            day: "friday",
            day_number: 5,
            start_time: 9,
            end_time: 13,
            volunteer: {
              id: 30,
              last_name: "Lind",
              first_name: "Brendon"
            },
            client: {
              id: 27,
              last_name: "Barrows",
              first_name: "Arturo"
            }
          }
        ]
    );
  });
});

describe('MatchProposalCtrl', function () {
  var scope, ctrl, $httpBackend;

  beforeEach(function () {
    jasmine.addMatchers({
      toEqualData: function () {
        return {
          compare: function (actual, expected) {
            return {
              pass: angular.equals(actual, expected)
            };
          }
        };
      }
    });
  });

  beforeEach(inject(function (_$httpBackend_, $rootScope, $controller) {
    $httpBackend = _$httpBackend_;
    $httpBackend.expectGET('/match_proposals.json').
    respond(
        [
          {
            id: 5,
            day: "monday",
            day_number: 1,
            start_time: 9,
            end_time: 12,
            status: "accepted",
            proposal_date: "2015-12-24",
            match_requests_size: 3,
            client: {
              id: 7,
              last_name: "Adams",
              first_name: "Golda"
            },
            match_requests: [
              {
                status: "accepted",
                volunteer: {
                  id: 14,
                  last_name: "Dietrich",
                  first_name: "Anna"
                }
              },
              {
                status: "accepted",
                volunteer: {
                  id: 25,
                  last_name: "Fadel",
                  first_name: "Kristina"
                }
              },
              {
                status: "accepted",
                volunteer: {
                  id: 15,
                  last_name: "Rutherford",
                  first_name: "Rosalinda"
                }
              }
            ]
          }
        ]
    );

    scope = $rootScope.$new();
    ctrl = $controller('MatchProposalCtrl', {$scope: scope});
  }));

  it('sets acsending order to false', function () {
    expect(scope.orderAscending).toBe(false);
  });

  it('creates a match proposals model with match proposal JSON data', function () {
    expect(scope.matchProposals).toEqualData([]);
    $httpBackend.flush();
    expect(scope.matchProposals).toEqualData(
        [
          {
            id: 5,
            day: "monday",
            day_number: 1,
            start_time: 9,
            end_time: 12,
            status: "accepted",
            proposal_date: "2015-12-24",
            match_requests_size: 3,
            client: {
              id: 7,
              last_name: "Adams",
              first_name: "Golda"
            },
            match_requests: [
              {
                status: "accepted",
                volunteer: {
                  id: 14,
                  last_name: "Dietrich",
                  first_name: "Anna"
                }
              },
              {
                status: "accepted",
                volunteer: {
                  id: 25,
                  last_name: "Fadel",
                  first_name: "Kristina"
                }
              },
              {
                status: "accepted",
                volunteer: {
                  id: 15,
                  last_name: "Rutherford",
                  first_name: "Rosalinda"
                }
              }
            ]
          }
        ]
    );
  });
});