//
//  JRAppDelegate.m
//  jTLC
//
//  Created by John Heaton on 7/9/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRAppDelegate.h"
#import "TLCKit.h"
#import "JRLoginTableViewController.h"
#import "JRScheduleViewController.h"

@implementation JRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window.backgroundColor = [UIColor clearColor];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:  [[JRLoginViewController alloc] initWithStyle:UITableViewStyleGrouped]];
//    nav.navigationBar.translucent = NO;
//    nav.navigationBar.barTintColor = [UIColor colorWithWhite:0.3 alpha:1];
////    nav.topViewController.title = @"TLC";
//    nav.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor] };
//    self.window.rootViewController = nav;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[JRLoginTableViewController alloc] initWithStyle:UITableViewStyleGrouped]];
    nav.navigationBar.translucent = NO;
    nav.navigationBar.tintColor = [UIColor orangeColor];
    nav.navigationBar.barTintColor = [UIColor colorWithWhite:0.3 alpha:1];
    nav.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor] };
    nav.topViewController.title = @"Log In";
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)pushScheduleViewForSession:(TKSession *)session {
    scheduleController = [[JRScheduleViewController alloc] init];
    scheduleController.session = session;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:scheduleController];
    nav.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor] };
    nav.navigationBar.tintColor = [UIColor redColor];
    nav.navigationBar.barTintColor = [UIColor colorWithWhite:0.14 alpha:1];
    
    [loginController presentViewController:nav animated:YES completion:nil];
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
