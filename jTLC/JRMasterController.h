//
//  JRMasterController.h
//  jTLC
//
//  Created by John Heaton on 9/15/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKSession.h"
#import "JRLoginTableViewController.h"
#import "GJB.h"
#import "JRColorTheme.h"
#import "JRScheduleViewController.h"

@interface JRMasterController : NSObject {
    JRLoginTableViewController  *logInViewController;
    JRScheduleViewController    *scheduleViewController;
}

+ (instancetype)sharedInstance;

- (void)save;
- (void)presentUI;

PROP_COPY   NSString *employeeID;
PROP_COPY   NSString *password;

PROP_STRONG TKSession *session;

PROP_STRONG UINavigationController *rootNavigationController;
PROP_STRONG UINavigationController *topNavigationController;

PROP_STRONG JRColorTheme *colorTheme;

@end
