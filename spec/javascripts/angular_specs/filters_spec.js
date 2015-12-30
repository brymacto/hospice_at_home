describe('filter', function () {

  describe('fullDate', function () {

    it('formats a date correctly', inject(function (fullDateFilter) {
      date_input = {day: 'monday', start_time: 9, end_time: 10 }

      result = fullDateFilter(date_input);

      expect(result).toBe("monday, 9 to 10");
    }));
  });
});