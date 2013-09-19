//
//  UINavigationController+StatusBar.m
//  jTLC
//
//  Created by John Heaton on 9/15/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//


@implementation UINavigationController (StatusBar)

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

@end
