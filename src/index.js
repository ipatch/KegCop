import './styles.css';
import './index.html';
// NOTE: importing and running logic form below js file appears working ...yay!
import './utils/google-analytics';

// LOGOs
// import kegCopLogo from './images/kegcop-logo.svg' // OG logo

function addContainerComponent() {
  const element = document.createElement('div');
  element.className = 'container';
  element.id = 'container';
  element.innerHTML = '';
  document.body.appendChild(element);
}
addContainerComponent();

import kegCopLogoNeo from './images/kegcop-logo-dynamic-wh.svg'

function addLogoToContainer() {
  const element = document.createElement('div');
  element.innerHTML = kegCopLogoNeo;
  document.getElementById('container').appendChild(element);
}
addLogoToContainer();
