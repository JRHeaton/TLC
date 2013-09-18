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
#import "JRScheduleTableViewController.h"
#import "JRThemeManager.h"
#import "JRColorTheme.h"
#import "JRNavigationController.h"

@interface JRMasterController : NSObject {
    JRLoginTableViewController  *logInViewController;
    JRScheduleTableViewController *scheduleController;
}

+ (instancetype)sharedInstance;

- (void)save;
- (void)presentUI;

- (JRNavigationController *)newThemedNavController;

PROP_COPY   NSString *employeeID;
PROP_COPY   NSString *password;

PROP_STRONG TKSession *session;

PROP_STRONG JRNavigationController *rootNavigationController;
PROP_STRONG JRNavigationController *topNavigationController;

PROP_STRONG JRColorTheme *colorTheme;
PROP_STRONG JRTheme *theme;

@end
