import './index.css';
// import KegCopLogoSrc from './images/kegcop-logo-no-gradient.svg';
// import KegCopLogoSrc from './images/kegcop-logo-neo-neo-03.svg';

function addLogo() {
  let kegCopBackgroundLogoDiv = document.createElement('div');
  // add logo to DOM
  const kegCopLogo = new Image();
  kegCopLogo.src = KegCopLogoSrc
  kegCopLogo.className = 'logo';
  kegCopLogo.id = 'logo-background';
  kegCopBackgroundLogoDiv.appendChild(kegCopLogo);
  return kegCopLogo
}

// document.body.appendChild(addLogo());

// 100% working with webpack | add div to DOM and add text to div
let newdiv = document.createElement('div');
newdiv.appendChild(document.createTextNode('text added from index.js using JavaScript'));
newdiv.id = 'mr-fancy-new-div';
document.body.appendChild(newdiv);

// EXP > sanity check
// alert('wtf');
//

// 1. create an svg element
// 2. assign an ID to the newly created svg element
// 3. see if a imported SVG can be appended to existing svg element
// 4. objective: avoid using the <img> tag

// setup namespace for SVG
var svgns = 'http://www.w3.org/2000/svg';
var svg = document.createElementNS(svgns, 'svg');
document.body.appendChild(svg);
svg.setAttribute('version', '1.1');
svg.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
// baseProfile
// width
// height

// bring in external svg
var use1 = document.createElementNS(svgns, "use");
use1.setAttributeNS('http://www.w3.org/1999/xlink', 'xlink:href', './images/purple-circle-plain.svg#circle-purple'); 

svg.appendChild(use1);

// let svgElement = document.createElement('svg');
// document.body.appendChild(svgElement);
// var svg = document.getElementsByTagName('svg')[0];
// var newElement1 = document.createElementNS('http://www.w3.org/2000/svg', 'g');
// var useElement = document.createElement('use');
// useElement.href='./images/purple-circle-plain.svg#circle-purple';
// newElement1.append(useElement);
// svg.appendChild(newElement1);


// 1. An svg tag must be added to the DOM first!
// let svgElement = document.createElement('svg');
// document.body.appendChild(svgElement);
// var svg = document.getElementsByTagName('svg')[0]; //Get svg element
// var newElement = document.createElementNS("http://www.w3.org/2000/svg", 'path'); //Create a path in SVG's namespace
// newElement.setAttribute("d","M 0 0 L 10 10"); //Set path's data
// newElement.style.stroke = "#000"; //Set stroke colour
// newElement.style.strokeWidth = "5px"; //Set stroke width
// svg.appendChild(newElement);

// Exp #2
// let svgElement1 = document.createElement('svg');
// document.body.appendChild(svgElement1);
// var svg1 = document.getElementsByTagName('svg')[1];
// var newElement1 = document.createElementNS('http://www.w3.org/2000/svg', 'g');
// var useElement = document.createElement('use');
// useElement.href='./images/kegcop-logo-neo-neo-03.svg';
// newElement1.append(useElement);
// svg1.appendChild(newElement1);

// var useElement = document.createElementNS('http://www.w3.org/2000/svg', 'use');

// NOTE: only seems to reference via URL ...wtf?
// useElement.setAttributeNS(
// 	'http://www.w3.org/1999/xlink', // xline NS URI
// 	'href',
// 	// './images/kegcop-logo-neo-neo-03.svg#kegcop-logo-root');
// 	'./images/purple-circle.svg#svg8')

// document.querySelector('svg').appendChild(useElement);



// document.createElementNS('http://www.w3.org/2000/svg', 'svg');
// document.svg.appendChild(KegCopLogoSrc);

// var svg = document.getElementsByTagName('svg')[0]; //Get svg element
// var newElement = document.createElementNS("http://www.w3.org/2000/svg", 'g'); //Create a path in SVG's namespace
// newElement.setAttribute("d","M 0 0 L 10 10"); //Set path's data
// newElement.style.stroke = "#000"; //Set stroke colour
// newElement.style.strokeWidth = "5px"; //Set stroke width
// svg.appendChild(newElement);
// document.getElementsByTagName(newElement.appendTo


// let svgLogoDiv = document.createElement('div');
// svgLogoDiv.id = 'svg-logo-div';
// document.body.appendChild(svgLogoDiv);

// let kegCopSVGFile = 'KegCopLogoSrc';
// var loadXML = new XMLHttpRequest;
// loadXML.open('GET', kegCopSVGFile, true);
// loadXML.send();

// svgLogoDiv.innerHTML = loadXML.responseText


// // #1 NOT HOTDOG
// let svgElKegcopLogo = document.createElement('div');
// // document.body.appendChild('svgElKegcopLogo');
// svgElKegcopLogo.id = 'svg-el-kegcop-logo';

// // svgElKegcopLogo.appendChild(document.createElement('svg'));
// // svgElKegcopLogo.appendChild('KegCopLogoSrc');
// // document.body.appendChild(svgElKegcopLogo);


// svgElKegcopLogo.id = 'svg-kegcop-logo';
// // NOT HOTDOG svgElKegcopLogo.appendChild('KegCopLogoSrc');
// svgKegCopLogoSVG = document.createElement('KegCopLogoSrc');
// svgElKegcopLogo.appendChild(svgKegCopLogoSVG);
// document.body.appendChild(svgElKegcopLogo);


