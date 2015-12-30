describe('MatchCtrl', function () {

  it('sets acsending order to false', inject(function ($controller) {
    var scope = {}
    var ctrl = $controller('MatchCtrl', {$scope: scope});

    expect(scope.orderAscending).toBe(false);
  }));

});