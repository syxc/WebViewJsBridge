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

@property (strong, nonatomic) WKWebView *webView;

@property WKTestBridge *bridge;

@end

@implementation ExampleWKWebViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = NSStringFromClass([self class]);
  
  _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:({
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [self addAllScriptMessageHandle:config];
    config;
  })];
  _webView.navigationDelegate = self;
  [self.view addSubview:_webView];
  
  // 设置oc和js的桥接
  _bridge = [WKTestBridge bridgeForWebView:_webView webViewDelegate:self];
  _bridge.delegate = self;
  // test only
  NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
  NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
  NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
  [_webView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  if (_webView) {
    [self removeAllScriptMessageHandle:_webView.configuration];
    _webView.navigationDelegate = nil;
    _webView = nil;
  }
  _bridge.delegate = nil;
}


#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
  if ([message.name isEqualToString:kScriptMessageName]) {
    NSLog(@"message=%@", message.body);
  }
}

- (void)addAllScriptMessageHandle:(WKWebViewConfiguration *)configuration {
  WKUserContentController *controller = configuration.userContentController;
  [controller addScriptMessageHandler:self name:kScriptMessageName];
}

- (void)removeAllScriptMessageHandle:(WKWebViewConfiguration *)configuration {
  WKUserContentController *controller = configuration.userContentController;
  [controller removeScriptMessageHandlerForName:kScriptMessageName];
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