if (!process.browser) {
  require('coffee-script/register');
}


module.exports = require('./src/hamlc.coffee');
