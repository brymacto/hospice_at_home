//= require 'angular_app.js'
//= require 'angular-mocks'

describe('MatchCtrl', function(){

  beforeEach(module('hospiceAtHome'));

  it('sets acsending order to false', inject(function($controller) {
    var scope = {},
        ctrl = $controller('MatchCtrl', {$scope:scope});
    expect(scope.orderAscending).toBe(false);
  }));

});