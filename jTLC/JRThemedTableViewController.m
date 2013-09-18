//
//  JRThemedTableViewController.m
//  jTLC
//
//  Created by John Heaton on 9/18/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRThemedTableViewController.h"
#import "JRThemeManager.h"
#import "JRTheme.h"
#import "JRNavigationController.h"

@interface JRThemedTableViewController ()

@end

@implementation JRThemedTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_JRThemeChanged:) name:JRThemeManagerThemeChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_JRThemeStatusBarStyleChanged:) name:JRThemeManagerThemeStatusBarStyleChangedNotification object:nil];
    
    if([[JRThemeManager sharedInstance] currentTheme])
        [self themeChanged:[[JRThemeManager sharedInstance] currentTheme]];
}

- (void)_JRThemeChanged:(NSNotification *)notification {
    [self themeChanged:(JRTheme *)notification.object];
}

- (void)_JRThemeStatusBarStyleChanged:(NSNotification *)notification {
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    JRTheme *theme = [JRThemeManager sharedInstance].currentTheme;
    if(!theme)
        return UIStatusBarStyleDefault;
    
    return theme.statusBarStyle;
}

- (void)themeChanged:(JRTheme *)theme {
    
}

- (CGFloat)navigationBarProgress {
    if(![self.navigationController isKindOfClass:[JRNavigationController class]])
        return 0;
    
    return ((JRNavigationController *)self.navigationController).navigationBar.progressView.progress;
}

- (void)setNavigationBarProgress:(CGFloat)navigationBarProgress {
    if(![self.navigationController isKindOfClass:[JRNavigationController class]])
        return;
    
    UIProgressView *p = ((JRNavigationController *)self.navigationController).navigationBar.progressView;
    
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
