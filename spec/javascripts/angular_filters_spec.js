//= require 'angular_app.js'
//= require 'angular-mocks'

describe('MatchCtrl', function(){

  beforeEach(module('hospiceAtHome'));

  it('should create "phones" model with 3 phones', function() {
    var scope = {},
        ctrl = new MatchCtrl(scope);

    expect(scope.phones.length).toBe(3);
  });

});