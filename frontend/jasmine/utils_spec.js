describe('AS global object', function() {

  describe('modulization for dummies', function() {
    var x = 0;    

    beforeEach(function(done) {

      AS.module('foo', function() {
        this.bar = 10;
      });

      AS.module('bar', function() {
        x += 1;
      });

      $(document).ready(function() {
        done();
      });
    });

    it('can register and load modules', function() {
      expect(AS.module('foo').bar).toEqual(10);
    });

    it("can reload modules", function() {
      AS.module('bar');
      expect(x).toEqual(1);
      AS.module('bar', true);
      expect(x).toEqual(2);
    });

  });
});
