//
//  WebViewJsBridge.h
//  VoxStudent
//
//  Created by zhaoxy on 14-3-8.
//  Copyright (c) 2014年 17zuoye. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCustomProtocolScheme @"jscall"
#define kBridgeName           @"external"

@interface WebViewJsBridge : NSObject<UIWebViewDelegate>

@property (weak, nonatomic) UIWebView *webView;

+ (instancetype)bridgeForWebView:(UIWebView*)webView webViewDelegate:(NSObject<UIWebViewDelegate>*)webViewDelegate;
+ (instancetype)bridgeForWebView:(UIWebView*)webView webViewDelegate:(NSObject<UIWebViewDelegate>*)webViewDelegate resourceBundle:(NSBundle*)bundle;

- (void)excuteJS:(NSString *)script;
- (void)excuteJSWithFunction:(NSString *)function;
- (void)excuteJSWithObj:(NSString *)obj function:(NSString *)function;

@end
