const merge = require('webpack-merge');
const baseConfig = require('./webpack.config.base');

module.exports = merge(baseConfig, {
  mode: 'development',
  devServer: {
    overlay: true,
    host: '0.0.0',
    useLocalIp: true,
  },
  devtool: 'source-map',
});
