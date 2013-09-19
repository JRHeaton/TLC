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

- (void)setNavigationBarProgress:(CGFloat)navigationBarProgress {
    UIProgressView *p = self.navigationBar.progressView;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(navigationBarProgress != 0) {
            p.alpha = 1;
            [p setProgress:navigationBarProgress animated:YES];
            if(navigationBarProgress == 1) {
                double delayInSeconds = 0.3;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [UIView animateWithDuration:0.3 animations:^{
                        p.alpha = 0;
                    } completion:^(BOOL finished) {
                        p.progress = 0;
                    }];
                });
            }
        }
    });
}

@end
