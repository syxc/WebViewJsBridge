//
//  TestBridge.m
//  WebViewJsBridge
//
//  Created by zhaoxy on 14-4-2.
//  Copyright (c) 2014年 tsinghua. All rights reserved.
//

#import "TestBridge.h"

@implementation TestBridge

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

@end
