module.exports = {
  test: /\.scss$/,
  use: [
    "to-string-loader", // creates style nodes from JS strings
    "css-loader", // translates CSS into CommonJS
    "sass-loader" // compiles Sass to CSS
  ]
}
