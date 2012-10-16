(function(jsUrl, callback) {
  if (typeof jQuery == 'undefined' || jQuery("script[src='"+jsUrl+"']").size() == 0) {
    var script = document.createElement('script');
    var head = document.getElementsByTagName('head')[0];
    var done = false;
    script.onload = script.onreadystatechange = (function() {
      if (!done && (!this.readyState || this.readyState == 'loaded' || this.readyState == 'complete')) {
        done = true;
        script.onload = script.onreadystatechange = null;
        head.removeChild(script);
        callback();
      }
    });
    script.src = jsUrl;
    head.appendChild(script);
  }
  else {
    callback();
  }
})(arguments[0], arguments[arguments.length - 1]);
