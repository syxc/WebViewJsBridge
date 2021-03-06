//
//  AppDelegate.m
//  WebViewJsBridge
//
//  Created by zhaoxy on 14-4-2.
//  Copyright (c) 2014年 tsinghua. All rights reserved.
//

#import "AppDelegate.h"
#import "ExampleUIWebViewController.h"
#import "ExampleWKWebViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // 1. Create the UIWebView example
  UINavigationController *uiWebViewNav = [[UINavigationController alloc]
                                          initWithRootViewController:[ExampleUIWebViewController new]];
  uiWebViewNav.tabBarItem.title = @"UIWebView";
  
  // 2. Create the tab footer and add the UIWebView example
  UITabBarController *tabBarController = [[UITabBarController alloc] init];
  [tabBarController addChildViewController:uiWebViewNav];
  
  // 3. Create the WKWebView example for devices >= iOS 8
  if([WKWebView class]) {
    UINavigationController *wkWebViewNav = [[UINavigationController alloc]
                                            initWithRootViewController:[ExampleWKWebViewController new]];
    wkWebViewNav.tabBarItem.title = @"WKWebView";
    [tabBarController addChildViewController:wkWebViewNav];
  }
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = tabBarController;
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
