;(function() {
  var messagingIframe,
  bridge = 'external',
  CUSTOM_PROTOCOL_SCHEME = 'jscall';

  if (window[bridge]) {
    return;
  }

  function _createQueueReadyIframe(doc) {
    messagingIframe = doc.createElement('iframe');
    messagingIframe.style.display = 'none';
    doc.documentElement.appendChild(messagingIframe);
  }

  window[bridge] = {};
  var methods = [%@];
  for (var i = 0; i < methods.length; i++) {
    (function(index) {
      var method = methods[index];
      var code = "window[bridge][method] = function() {messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + ':' + method + ':' + encodeURIComponent(JSON.stringify(arguments));}";
      eval(code);
    })(i)
  }

  // 创建iframe，必须在创建external之后，否则会出现死循环
  _createQueueReadyIframe(document);
  // 通知js开始初始化
  //initReady();
})();
