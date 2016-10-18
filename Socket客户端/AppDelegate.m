//
//  AppDelegate.m
//  Socket客户端
//
//  Created by MingYanWoo on 2016/10/8.
//  Copyright © 2016年 MingYan. All rights reserved.
//

#import "AppDelegate.h"
#import "MYMainViewController.h"
#import "GCDAsyncSocket.h"
#import <UserNotifications/UserNotifications.h>

#define MYHostAddress @"119.29.175.89"
#define MYHostPort 12345

@interface AppDelegate () <GCDAsyncSocketDelegate,UNUserNotificationCenterDelegate>

@property (nonatomic, strong) GCDAsyncSocket *socket;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  
    MYMainViewController *vc = [[MYMainViewController alloc] init];
    
    GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:vc delegateQueue:dispatch_get_global_queue(0, 0)];
    _socket = socket;
    
    NSError *error = nil;
    [socket connectToHost:MYHostAddress onPort:MYHostPort error:&error];
   
    vc.socket = socket;
    self.window.rootViewController = vc;
    
    [self.window makeKeyAndVisible];
    
    
    if (error) {
        NSLog(@"error:%@",error);
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{
        //todo send keep live
    
//    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    [[UIApplication sharedApplication] clearKeepAliveTimeout];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MYBadgeReset" object:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"reconnect");
    [self.socket connectToHost:MYHostAddress onPort:MYHostPort error:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
