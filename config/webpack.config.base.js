const path = require('path');
const webpack = require('webpack');

module.exports = {
  // `mode:` is defined in the `...prod.js` and `...dev.js`
  entry: [
    './src/index.js'
    // './src/hello.js'
  ],
  output: {
    // `path:` has to be absolute NOT relative
    path: path.join(__dirname, '../docs'),
    filename: 'app.bundle.js',
  },
  module: {
    rules: [
      {
        test: /\.js?x$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        },
      },
    ]
  },

  plugins: [
    new webpack.EnvironmentPlugin([
      'NODE_ENV',
    ]),
  ],
};
