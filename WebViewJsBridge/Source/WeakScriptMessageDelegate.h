//
//  WeakScriptMessageDelegate.h
//  WebViewJsBridge
//
//  Created by syxc on 7/6/16.
//  Copyright © 2016 tsinghua. All rights reserved.
//

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface WeakScriptMessageDelegate : NSObject <WKScriptMessageHandler>

@property (weak, nonatomic) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end

#endif