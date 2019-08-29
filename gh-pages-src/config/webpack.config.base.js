const path = require('path');
// const HtmlWebpackPlugin = require('html-webpack-plugin');
const WebappWebpackPlugin = require('webapp-webpack-plugin');
const ExtractCssChunks = require('extract-css-chunks-webpack-plugin');

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
        test: /\.css$/,
        use: [ExtractCssChunks.loader, 'css-loader'],
      },
      {
        test: /\.htm?l$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: '[name].html',
              // minimize: true
            }
          },
          {
            loader: 'extract-loader'
          },
          {
            loader: 'html-loader',
            options: {
              // attr: ['img:src']
            }
          }
        ]
      },
      {
        test: /\.(jpe?g|gif|png|svg|bmp)$/,
        use: [
          // NOTE file-loader can also be used to work with the below font types as well
          // woff,woff2,eot,ttf,otf
          {
            loader: 'file-loader',
            options: {
              name: 'images/[name].[ext]',
            },
          },
        ],
      },
    ],
  },
  plugins: [
    // new HtmlWebpackPlugin({
    //   // html-webpack-plugin can be used to minify an HTML document, see cra-exp for more details
    //   template: './src/index.html',
    // }),
    new WebappWebpackPlugin({
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
    new ExtractCssChunks({
      filename: '[name].css',
      chunkFilename: '[id].css',
      hot: true,
      orderWarning: true,
      reloadAll: true,
      cssModules: true
    })
  ]
}
