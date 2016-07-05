//
//  WKWebViewJsBridge.m
//  WebViewJsBridge
//
//  Created by syxc on 7/4/16.
//  Copyright © 2016 tsinghua. All rights reserved.
//

#import "WKWebViewJsBridge.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

#import <objc/runtime.h>

@interface WKWebViewJsBridge ()

@property (weak, nonatomic) id webViewDelegate;
@property (weak, nonatomic) NSBundle *resourceBundle;

@end

@implementation WKWebViewJsBridge

+ (instancetype)bridgeForWebView:(WKWebView *)webView webViewDelegate:(NSObject<WKNavigationDelegate> *)webViewDelegate {
  return [self bridgeForWebView:webView webViewDelegate:webViewDelegate resourceBundle:nil];
}

+ (instancetype)bridgeForWebView:(WKWebView *)webView webViewDelegate:(NSObject<WKNavigationDelegate> *)webViewDelegate resourceBundle:(NSBundle*)bundle {
  WKWebViewJsBridge *bridge = [[[self class] alloc] init];
  [bridge _platformSpecificSetup:webView webViewDelegate:webViewDelegate resourceBundle:bundle];
  return bridge;
}


#pragma mark - init & dealloc

- (void)_platformSpecificSetup:(WKWebView *)webView webViewDelegate:(id<WKNavigationDelegate>)webViewDelegate resourceBundle:(NSBundle*)bundle {
  _webView = webView;
  _webViewDelegate = webViewDelegate;
  _webView.navigationDelegate = self;
  _resourceBundle = bundle;
}

- (void)dealloc {
  _webView = nil;
  _webViewDelegate = nil;
  _webView.navigationDelegate = nil;
  _resourceBundle = nil;
}


#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
  if (webView != _webView) { return; }
  
  // is js insert
  if (![[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"typeof window.%@ == 'object'", kBridgeName]] isEqualToString:@"true"]) {
    // get class method dynamically
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList([self class], &methodCount);
    NSMutableString *methodList = [NSMutableString string];
    @autoreleasepool {
      for (int i = 0; i < methodCount; i++) {
        NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(methods[i])) encoding:NSUTF8StringEncoding];
        // 防止隐藏的系统方法名包含“.”导致js报错
        if ([methodName rangeOfString:@"."].location != NSNotFound) {
          continue;
        }
        [methodList appendString:@"\""];
        [methodList appendString:[methodName stringByReplacingOccurrencesOfString:@":" withString:@""]];
        [methodList appendString:@"\","];
      }
    }
    if (methodList.length > 0) {
      [methodList deleteCharactersInRange:NSMakeRange(methodList.length - 1, 1)];
    }
    free(methods);
    NSBundle *bundle = _resourceBundle ? _resourceBundle : [NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:@"WebViewJsBridge" ofType:@"js"];
    NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:js, methodList]];
  }
  
  __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
  if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
    [strongDelegate webView:webView didFinishNavigation:navigation];
  }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
  if (webView != _webView) { return; }
  
  __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
  if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didReceiveAuthenticationChallenge:completionHandler:)]) {
    [strongDelegate webView:webView didReceiveAuthenticationChallenge:challenge completionHandler:completionHandler];
  }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  if (webView != _webView) { return; }
  
  NSURL *url = navigationAction.request.URL;
  NSString *requestString = [url absoluteString];
  if ([requestString hasPrefix:kCustomProtocolScheme]) {
    NSArray *components = [[url absoluteString] componentsSeparatedByString:@":"];
    
    NSString *function = (NSString*)[components objectAtIndex:1];
    NSString *argsAsString = [(NSString*)[components objectAtIndex:2]
                              stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *argsData = [argsAsString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *argsDic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:argsData options:kNilOptions error:NULL];
    // convert js array to objc array
    NSMutableArray *args = [NSMutableArray array];
    for (int i = 0; i < [argsDic count]; i++) {
      [args addObject:[argsDic objectForKey:[NSString stringWithFormat:@"%d", i]]];
    }
    // ignore warning
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    SEL selector = NSSelectorFromString([args count] > 0 ? [function stringByAppendingString:@":"] : function);
    if ([self respondsToSelector:selector]) {
      [self performSelector:selector withObject:args];
    }
    decisionHandler(WKNavigationActionPolicyCancel);
  }
  
  __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
  if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
    [_webViewDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
  } else {
    decisionHandler(WKNavigationActionPolicyAllow);
  }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
  if (webView != _webView) { return; }
  
  __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
  if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
    [strongDelegate webView:webView didStartProvisionalNavigation:navigation];
  }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
  if (webView != _webView) { return; }
  
  __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
  if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didFailNavigation:withError:)]) {
    [strongDelegate webView:webView didFailNavigation:navigation withError:error];
  }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
  if (webView != _webView) { return; }
  
  __strong typeof(_webViewDelegate) strongDelegate = _webViewDelegate;
  if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
    [strongDelegate webView:webView didFailProvisionalNavigation:navigation withError:error];
  }
}


#pragma mark - call js

// 执行js方法
- (void)excuteJS:(NSString *)script {
  [self _evaluateJavaScript:script];
}

- (void)excuteJSWithFunction:(NSString *)function {
  [self excuteJSWithObj:nil function:function];
}

- (void)excuteJSWithObj:(NSString *)obj function:(NSString *)function {
  NSString *js = function;
  if (obj) {
    js = [NSString stringWithFormat:@"%@.%@", obj, function];
  }
  [self excuteJS:js];
}

- (void)_evaluateJavaScript:(NSString *)script {
  if (!script) { return; }
  [self.webView evaluateJavaScript:script completionHandler:nil];
}

@end

#endif
