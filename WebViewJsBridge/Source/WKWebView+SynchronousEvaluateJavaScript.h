//
//  WKWebView+SynchronousEvaluateJavaScript.h
//  WebViewJsBridge
//
//  @via http://stackoverflow.com/a/27981872
//
//  Created by syxc on 7/5/16.
//  Copyright © 2016 tsinghua. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (SynchronousEvaluateJavaScript)

- (NSString * _Nullable)stringByEvaluatingJavaScriptFromString:(NSString * _Nullable)script;

@end
