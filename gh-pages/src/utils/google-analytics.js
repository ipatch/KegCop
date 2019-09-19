// console.log('hello from ga file');

function loadGoogleAnalytics() {
  var ga = document.createElement('script');
  ga.type = 'text/javascript';
  ga.async = true;
  ga.src ='https://www.googletagmanager.com/gtag/js?id=UA-43223650-1';

  var s = document.getElementsByTagName('script')[0];
  s.parentNode.insertBefore(ga, s);
}

// NOTE: only load GA on production domain
if (document.location.hostname.search('https://ipatch.github.io/KegCop') !== -1) {

  loadGoogleAnalytics();

  window.dataLayer = window.dataLayer || [];

  function gtag(){dataLayer.push(arguments);}

  gtag('js', new Date());

  gtag('config', 'UA-43223650-1');

}

