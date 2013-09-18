//
//  JRNavigationController.m
//  jTLC
//
//  Created by John Heaton on 9/18/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRNavigationController.h"

@interface JRNavigationController ()

@end

@implementation JRNavigationController

- (id)init {
    if(self = [super initWithNavigationBarClass:[JRNavigationBar class] toolbarClass:[UIToolbar class]]) {
        
    }
    
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    if(self = [super initWithNavigationBarClass:[JRNavigationBar class] toolbarClass:[UIToolbar class]]) {
        [self pushViewController:rootViewController animated:NO];
    }
    
    return self;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

@end
