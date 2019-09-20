const path = require('path');
const FaviconsWebpackPlugin = require('favicons-webpack-plugin');

module.exports = {
  // `mode:` is defined in the `...prod.js` and `...dev.js`
  entry: ['./src/index.js'],
  output: {
    // `path:` has to be absolute NOT relative
    path: path.join(__dirname, '../dist'),
    filename: 'app.bundle.js',
  },
  module: {
    rules: [
      {
        test: /\.js?x$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
      },
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
  plugins: [
    new FaviconsWebpackPlugin({
      logo: './src/images/kegcop-logo.svg',
      cache: true,
      prefix: 'assets/',
      inject: true,
      favicons: {
        appName: 'KegCop',
        appDescription: null,
        developerName: '@ipatch',
        developerURL: null,
        icons: {
          coast: false,
          yandex: false,
        }
      },
    }),
  ]
}
