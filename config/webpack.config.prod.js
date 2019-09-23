const merge = require('webpack-merge');

// NOTE: set up `webpack-bundle-analyzer`
const { BundleAnalyzerPlugin } = require('webpack-bundle-analyzer');

const baseConfig = require('./webpack.config.base');

module.exports = merge(baseConfig, {
  mode: 'production',
  module: {
    rules: [
      {
        test: /\.css$/i,
        use: [
          { 
            loader: 'style-loader',
            options: {
            }
          },
          {
            loader: 'css-loader',
            options: {
            }
          }
        ]
      },
      {
        test: /\.htm?l$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: '[name].html',
            }
          },
          {
            loader: 'extract-loader'
          },
          {
            loader: 'html-loader',
            options: {
              removeComments: true,
            }
          }
        ]
      },
      {
        test: /\.(jpe?g|gif|png|bmp)$/,
        use: [
          // NOTE file-loader can also be used to work with the below font types as well
          // woff,woff2,eot,ttf,otf
          {
            loader: 'file-loader',
            options: {
              name: '[path][name].[ext]',
            },
          },
        ],
      },
      {
        test: /\.(svg)$/,
        loader: 'svg-inline-loader',
      },
    ],
  },

  plugins: [
    new BundleAnalyzerPlugin({
      analyzerMode: 'static',
      openAnalyzer: false,
      reportFilename: 'bundle_sizes.html',
    }),
  ],
});
