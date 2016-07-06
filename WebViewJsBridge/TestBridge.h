//
//  TestBridge.h
//  WebViewJsBridge
//
//  Created by zhaoxy on 14-4-2.
//  Copyright (c) 2014年 tsinghua. All rights reserved.
//

#import "WebViewJsBridge.h"
#import "TestBridgeDelegate.h"

@interface TestBridge : WebViewJsBridge

@property (weak, nonatomic) id<TestBridgeDelegate> delegate;

@end
