const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const ExtractCssChunks = require('extract-css-chunks-webpack-plugin')

module.exports = {
  entry: [
    './src/index.js'
  ],
  mode: "development",
  devtool: 'source-map',
  output: {
    filename: "app.bundle.js",
    // `resolve` will construct an absolute path
    path: path.resolve(__dirname, "../dist"),
  },
  devServer: {
    overlay: true, // print errors in browser
    host: '0.0.0.0',
    useLocalIp: true
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: [
          ExtractCssChunks.loader,
          'css-loader'
        ]
      },
      {
        test: /\.(jpe?g|gif|png|bmp|svg)$/,
        use: [
          {
            // NOTE file-loader can also be used to work with the below font types as well
            // woff,woff2,eot,ttf,otf
            loader: "file-loader",
            options: {
              name: "images/[name].[ext]"
            }
          }
        ]
      }
    ]
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: './src/index.html'
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
