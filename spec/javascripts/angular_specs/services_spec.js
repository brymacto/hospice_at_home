//= require 'angular_app.js'
//= require 'angular-mocks'

describe('service', function () {

  beforeEach(module('hospiceAtHome'));

  describe('orderingService', function () {

    beforeEach(inject(function (_orderingService_) {
      orderingService = _orderingService_;
    }));

    describe('setOrderProp', function () {

      it('sets order property correctly when sorting client', function () {
        var orderBy = 'client';
        result = orderingService.setOrderProp(orderBy);
        expect(result).toEqual(['client.last_name', 'client.first_name']);
      });

      it('sets order property correctly when sorting volunteer', function () {
        var orderBy = 'volunteer';
        result = orderingService.setOrderProp(orderBy);
        expect(result).toEqual(['volunteer.last_name', 'volunteer.first_name']);
      });

      it('sets order property correctly when sorting day and time', function () {
        var orderBy = 'date';
        result = orderingService.setOrderProp(orderBy);
        expect(result).toEqual(['day_number', 'start_time']);
      });

      it('sets order property correctly when sorting other value', function () {
        var orderBy = 'foo';
        result = orderingService.setOrderProp(orderBy);
        expect(result).toEqual('foo');
      });
    });

    describe('setOrderAscending', function () {
      it('reverses orderAscending value when last call was for same column', function () {
        var orderBy = 'client';
        var orderAscending = true;
        var orderByLast = 'client';

        result = orderingService.setOrderAscending(orderBy, orderByLast, orderAscending);

        expect(result).toBe(false)
      });

      it('sets orderAscending value to false when last call was for different column', function () {
        var orderBy = 'client';
        var orderAscending = false;
        var orderAscending_2 = true;
        var orderByLast = 'volunteer';

        result = orderingService.setOrderAscending(orderBy, orderByLast, orderAscending);
        result_2 = orderingService.setOrderAscending(orderBy, orderByLast, orderAscending_2);

        expect(result).toBe(false)
        expect(result_2).toBe(false)
      });
    });
  });
});