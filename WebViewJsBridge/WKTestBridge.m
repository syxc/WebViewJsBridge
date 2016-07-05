//
//  WKTestBridge.m
//  WebViewJsBridge
//
//  Created by syxc on 7/5/16.
//  Copyright © 2016 tsinghua. All rights reserved.
//

#import "WKTestBridge.h"

@implementation WKTestBridge

- (void)test1:(NSArray *)data {
  if (_delegate && [_delegate respondsToSelector:@selector(test1:)]) {
    NSString *msg = [data firstObject];
    [_delegate test1:msg];
  }
}

- (void)test2 {
  if (_delegate && [_delegate respondsToSelector:@selector(test2)]) {
    [_delegate test2];
  }
}

- (void)test3 {
  if (_delegate && [_delegate respondsToSelector:@selector(test3)]) {
    [_delegate test3];
  }
}

@end
