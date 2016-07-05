//
//  WKWebViewJsBridge.h
//  WebViewJsBridge
//
//  Created by syxc on 7/4/16.
//  Copyright © 2016 tsinghua. All rights reserved.
//

/* Supports WKWebView */
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "WKWebView+SynchronousEvaluateJavaScript.h"

#define kCustomProtocolScheme @"jscall"
#define kBridgeName           @"external"

@interface WKWebViewJsBridge : NSObject <WKNavigationDelegate>

@property (weak, nonatomic) WKWebView *webView;

+ (instancetype)bridgeForWebView:(WKWebView *)webView webViewDelegate:(NSObject<WKNavigationDelegate> *)webViewDelegate;
+ (instancetype)bridgeForWebView:(WKWebView *)webView webViewDelegate:(NSObject<WKNavigationDelegate> *)webViewDelegate resourceBundle:(NSBundle*)bundle;

- (void)excuteJS:(NSString *)script;
- (void)excuteJSWithFunction:(NSString *)function;
- (void)excuteJSWithObj:(NSString *)obj function:(NSString *)function;

@end

#endif