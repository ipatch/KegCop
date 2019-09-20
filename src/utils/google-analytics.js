// console.log('hello from ga file');

function loadGoogleAnalytics() {
  var ga = document.createElement('script');
  ga.type = 'text/javascript';
  ga.async = true;
  ga.src ='https://www.googletagmanager.com/gtag/js?id=UA-43223650-1';

  var s = document.getElementsByTagName('script')[0];
  s.parentNode.insertBefore(ga, s);
}

// NOTE: don't local GA if running app locally
if (document.location.hostname.search('localhost') === -1) {
  console.log("GA loaded because app is not running locally");

  loadGoogleAnalytics();
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'UA-43223650-1');
} 
