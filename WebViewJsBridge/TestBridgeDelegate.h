//
//  TestBridgeDelegate.h
//  WebViewJsBridge
//
//  Created by syxc on 7/4/16.
//  Copyright © 2016 tsinghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestBridgeDelegate <NSObject>

- (void)test1:(NSString *)message;

- (void)test2;

- (void)test3;

@end
