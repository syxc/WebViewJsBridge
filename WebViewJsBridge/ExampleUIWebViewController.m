//
//  ExampleUIWebViewController.m
//  WebViewJsBridge
//
//  Created by syxc on 7/5/16.
//  Copyright © 2016 tsinghua. All rights reserved.
//

#import "ExampleUIWebViewController.h"
#import "TestBridge.h"

@interface ExampleUIWebViewController () <TestBridgeDelegate>

@property (strong, nonatomic) UIWebView *webView;

@property TestBridge *bridge;

@end

@implementation ExampleUIWebViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = NSStringFromClass([self class]);
  
  _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:_webView];
  
  // 设置oc和js的桥接
  _bridge = [TestBridge bridgeForWebView:_webView webViewDelegate:self];
  _bridge.delegate = self;
  // test only
  NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
  NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
  NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
  [_webView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)dealloc {
  if (_webView) {
    _webView.delegate = nil;
    _webView = nil;
  }
  _bridge.delegate = nil;
}


#pragma mark - TestBridgeDelegate

- (void)test1:(NSString *)message {
  NSLog(@"test1, message=%@", message);
}

- (void)test2 {
  NSLog(@"test2");
  [_bridge excuteJSWithFunction:@"sayHello('James')"];
}

- (void)test3 {
  NSLog(@"test3");
}

@end
