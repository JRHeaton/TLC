//
//  JRAppDelegate.h
//  jTLC
//
//  Created by John Heaton on 7/9/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRMasterController.h"

@interface JRAppDelegate : UIResponder <UIApplicationDelegate> {
    JRMasterController *master;
}

@property (strong, nonatomic) UIWindow *window;

@end
