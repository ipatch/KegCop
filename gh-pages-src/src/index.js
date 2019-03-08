import './index.css';
// import KegCopLogoSrc from './images/kegcop-logo-no-gradient.svg';
import KegCopLogoSrc from './images/kegcop-logo-gradient.svg';

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

document.body.appendChild(addLogo());
