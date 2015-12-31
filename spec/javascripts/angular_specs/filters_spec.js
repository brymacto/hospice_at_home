describe('filter', function () {

  describe('fullDate', function () {

    it('formats a date correctly', inject(function (fullDateFilter) {
      date_input = {day: 'monday', start_time: 9, end_time: 10}

      result = fullDateFilter(date_input);

      expect(result).toBe("monday, 9 to 10");
    }));
  });

  describe('capitalize', function () {

    it('capitalizes first letter correctly', inject(function (capitalizeFilter) {
      string_input = "monday, 9 to 10";

      result = capitalizeFilter(string_input);

      expect(result).toBe("Monday, 9 to 10");
    }));

    it('downcases letters correctly', inject(function (capitalizeFilter) {
      string_input = "MONDAY, 9 to 10";

      result = capitalizeFilter(string_input);

      expect(result).toBe("Monday, 9 to 10");
    }));
  });
});