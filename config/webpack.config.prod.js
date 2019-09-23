const merge = require('webpack-merge');

// NOTE: setting up `webpack-bundle-analyzer`
const { BundleAnalyzerPlugin } = require('webpack-bundle-analyzer');

const baseConfig = require('./webpack.config.base');

module.exports = merge(baseConfig, {
  mode: 'production',
  module: {
    rules: [
      {
        test: /\.html$/,
        use: [ {
          loader: 'html-loader',
          options: {
            removeComments: true,
          }
        }],
      }
    ]
  },
  plugins: [
    new BundleAnalyzerPlugin({
      analyzerMode: 'static',
      openAnalyzer: false,
      reportFilename: 'bundle_sizes.html',
    }),
  ],
});
