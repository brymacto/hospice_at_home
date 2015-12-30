//= require 'angular_app.js'
//= require 'angular-mocks'

describe('filter', function () {

  beforeEach(module('hospiceAtHome'));
  describe('fullDate', function () {
    it('formats a date correctly', inject(function (fullDateFilter) {
      input = {day: 'monday', start_time: 9,
        end_time: 10 }
      result = fullDateFilter(input);
      expect(result).toBe("monday, 9 to 10");
    }));

  });
});