//
//  JRAppDelegate.h
//  jTLC
//
//  Created by John Heaton on 7/9/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRLoginTableViewController;
@class JRScheduleViewController;

@interface JRAppDelegate : UIResponder <UIApplicationDelegate> {
    NSString *employeeID, *pass;
    JRScheduleViewController *scheduleController;
    JRLoginTableViewController *loginController;
}

@property (strong, nonatomic) UIWindow *window;

@end
