const merge = require('webpack-merge');
const baseConfig = require('./webpack.config.base');

module.exports = merge(baseConfig, {
  mode: 'development',
  devServer: {
    // overlay: true,
    host: '0.0.0.0',
    // useLocalIp: true,
  },
  devtool: 'eval-source-map', // `eval-source-map` faster rebuild time over `source-map`

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
        ],
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
});
