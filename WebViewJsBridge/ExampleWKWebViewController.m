//
//  ExampleWKWebViewController.m
//  WebViewJsBridge
//
//  Created by syxc on 7/5/16.
//  Copyright © 2016 tsinghua. All rights reserved.
//

#import "ExampleWKWebViewController.h"
#import "WKTestBridge.h"

static NSString *const kScriptMessageName = @"WKWebViewDemo";

@interface ExampleWKWebViewController () <WKScriptMessageHandler, TestBridgeDelegate>

@property (strong, nonatomic) WKWebView *webview;

@property WKTestBridge *bridge;

@end

@implementation ExampleWKWebViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = NSStringFromClass([self class]);
  
  _webview = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:({
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.userContentController addScriptMessageHandler:self name:kScriptMessageName];
    config;
  })];
  _webview.navigationDelegate = self;
  [self.view addSubview:_webview];
  
  // 设置oc和js的桥接
  _bridge = [WKTestBridge bridgeForWebView:_webview webViewDelegate:self];
  _bridge.delegate = self;
  // test only
  NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
  NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
  NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
  [_webview loadHTMLString:appHtml baseURL:baseURL];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  _webview = nil;
  _bridge.delegate = nil;
  _webview.navigationDelegate = nil;
}


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
  if ([message.name isEqualToString:kScriptMessageName]) {
    NSLog(@"message=%@", message.body);
  }
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
  [_bridge excuteJSWithFunction:@"sendMessage()"];
}

@end
