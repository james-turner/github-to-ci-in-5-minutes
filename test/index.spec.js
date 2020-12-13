const {handler} = require('../src/index');
const chai = require('chai');
chai.should();

describe('Index', function() {
  describe('handler', function() {
    it('should return a power of 2', function() {
      handler(2).should.equal(4)
    });
  });
});
