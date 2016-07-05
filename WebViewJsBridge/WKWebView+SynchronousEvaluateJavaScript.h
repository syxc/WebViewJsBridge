//
//  WKWebView+SynchronousEvaluateJavaScript.h
//  WebViewJsBridge
//
//  Created by syxc on 7/5/16.
//  Copyright © 2016 tsinghua. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (SynchronousEvaluateJavaScript)

- (nullable NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;

@end
