import './index.css';
import './index.html';
// NOTE: importing and running logic form the below js files appears to be working ...yay!
import './utils/google-analytics';

// LOGOs
// import kegCopLogo from './images/kegcop-logo.svg' // OG logo
import kegCopLogoNeo from './images/kegcop-logo-neo-not-fin.svg'

function component() {
  const element = document.createElement('div');

  element.innerHTML = kegCopLogoNeo;

  return element;
}

document.body.appendChild(component());

