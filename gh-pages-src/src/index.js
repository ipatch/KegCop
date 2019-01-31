// NOTE html files can not be required using just
// ...`html-webpack-plugin`
//
// require('./index.css')
import './index.css'
//
// import './test.html'
// require('./test.html')
//
// require('./images/abe.circle.png')
// import './images/abe.circle.png'
//
console.log('hello browser console')
console.log('more hellos')
console.log('edit `./src/index.html`')
import _ from 'lodash'
import test from './test.html'
import greatCheesebergers from './hello.html'

function component() {
  let element = document.createElement('div');
  // use lodash
  element.innerHTML = _.join(['Hello', 'webpack'], ' ');
  return element;
}
document.body.appendChild(component());

function componentTwo() {
  let element = document.createElement('div');
  element.innerHTML = _.join([test]);
  return element;
}
document.body.appendChild(componentTwo());

function helloOne() {
  let element = document.createElement('div');
  element.innerHTML = greatCheesebergers
  return element
}
document.body.appendChild(helloOne());


