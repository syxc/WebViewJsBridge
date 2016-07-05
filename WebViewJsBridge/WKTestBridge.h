//
//  WKTestBridge.h
//  WebViewJsBridge
//
//  Created by syxc on 7/5/16.
//  Copyright © 2016 tsinghua. All rights reserved.
//

#import "WKWebViewJsBridge.h"
#import "TestBridgeDelegate.h"

@interface WKTestBridge : WKWebViewJsBridge

@property id<TestBridgeDelegate> delegate;

@end
