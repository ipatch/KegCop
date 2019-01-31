import './index.css'
import Logo from './images/kegcop-logo.svg'

function addLogo() {
  let element = document.createElement('div');
  // Add logo to DOM
  const myLogo = new Image();
  myLogo.src = Logo;
  element.appendChild(myLogo);
  return element;
}
document.body.appendChild(addLogo());
