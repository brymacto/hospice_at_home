//= require 'angular_app.js'
//= require 'angular-mocks'

describe('service', function () {

  beforeEach(module('hospiceAtHome'));
  describe('orderingService', function () {
    describe('setOrderProp', function () {
      it('sets order property correctly when sorting client', inject(function (orderingService) {
        orderBy = 'client';
        result = orderingService.setOrderProp(orderBy);
        expect(result).toEqual(['client.last_name', 'client.first_name']);
      }));
      it('sets order property correctly when sorting volunteer', inject(function (orderingService) {
        orderBy = 'volunteer';
        result = orderingService.setOrderProp(orderBy);
        expect(result).toEqual(['volunteer.last_name', 'volunteer.first_name']);
      }));
      it('sets order property correctly when sorting day and time', inject(function (orderingService) {
        orderBy = 'date';
        result = orderingService.setOrderProp(orderBy);
        expect(result).toEqual(['day_number', 'start_time']);
      }));
      it('sets order property correctly when sorting other value', inject(function (orderingService) {
        orderBy = 'foo';
        result = orderingService.setOrderProp(orderBy);
        expect(result).toEqual('foo');
      }));
    });

  });
});