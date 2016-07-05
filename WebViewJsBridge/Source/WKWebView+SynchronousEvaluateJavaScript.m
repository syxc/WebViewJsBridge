//
//  WKWebView+SynchronousEvaluateJavaScript.m
//  WebViewJsBridge
//
//  Created by syxc on 7/5/16.
//  Copyright © 2016 tsinghua. All rights reserved.
//

#import "WKWebView+SynchronousEvaluateJavaScript.h"

@implementation WKWebView (SynchronousEvaluateJavaScript)

- (NSString * _Nullable)stringByEvaluatingJavaScriptFromString:(NSString * _Nullable)script {
  __block NSString *resultString = nil;
  __block BOOL finished = NO;
  
  [self evaluateJavaScript:script completionHandler:^(id result, NSError *error) {
    if (error == nil) {
      if (result != nil) {
        resultString = [NSString stringWithFormat:@"%@", result];
      }
    } else {
      NSLog(@"evaluateJavaScript error: %@", error.localizedDescription);
    }
    finished = YES;
  }];
  
  @autoreleasepool {
    while (!finished) {
      [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
  }
  
  return resultString;
}

@end
