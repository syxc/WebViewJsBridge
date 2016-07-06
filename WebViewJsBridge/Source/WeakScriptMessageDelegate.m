//
//  WeakScriptMessageDelegate.m
//  WebViewJsBridge
//
//  Created by syxc on 7/6/16.
//  Copyright © 2016 tsinghua. All rights reserved.
//

#import "WeakScriptMessageDelegate.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

@implementation WeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
  self = [super init];
  if (self) {
    _scriptDelegate = scriptDelegate;
  }
  return self;
}


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
  [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end

#endif
