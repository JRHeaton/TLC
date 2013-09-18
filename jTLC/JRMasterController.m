//
//  JRMasterController.m
//  jTLC
//
//  Created by John Heaton on 9/15/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRMasterController.h"
#import "TLCKit.h"
#import "GJB.h"
#import "JRNavigationBar.h"

#define DEBUG_LOGIN_UI 1

@interface JRMasterController ()

- (JRNavigationController *)newThemedNavController;
- (id)prefForKey:(NSString *)key;
- (void)verifyLogIn;

@end

@implementation JRMasterController {
    NSUserDefaults *defaults;
}

static JRMasterController *_sharedJRMasterController = nil;

+ (instancetype)sharedInstance {
    if(!_sharedJRMasterController) {
        (void)[[self alloc] init];
    }
    
    return _sharedJRMasterController;
}

- (id)init {
    if(_sharedJRMasterController)
        return _sharedJRMasterController;
    
    if(self = [super init]) {
        self.colorTheme = [JRColorTheme darkColorThemeWithAccentColor:[UIColor colorWithRed:0 green:.67 blue:.94 alpha:1]];
//        self.colorTheme.navigationBarColor = self.colorTheme.accentColor;
        self.colorTheme.secondaryAccentColor = [UIColor colorWithRed:1 green:0.8 blue:0 alpha:1];
        
        self.theme = [JRTheme themeWithColorsAndTypes:@{
                                                        JRThemeColorTypeBackground : self.colorTheme.backgroundColor,
                                                        JRThemeColorTypeForeground : self.colorTheme.foregroundColor,
                                                        JRThemeColorTypeAccentPrimary : self.colorTheme.accentColor }];
        [[JRThemeManager sharedInstance] setCurrentTheme:self.theme];
        
        self.rootNavigationController = [self newThemedNavController];
        logInViewController = [[JRLoginTableViewController alloc] init];
        logInViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        __unsafe_unretained JRMasterController *_self = self;
        logInViewController.completionBlock = ^(TKSession *session) {
            _self.session = session;
            
            [_self performSelectorOnMainThread:@selector(dismissLogIn) withObject:nil waitUntilDone:NO];
        };
        
//        scheduleViewController = [[JRScheduleViewController alloc] init];
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        // TODO: ENCRYPT THAT SHIT
#if DEBUG_LOGIN_UI
        self.employeeID = nil;
        self.password = nil;
#else
        self.employeeID = [self prefForKey:@"employeeID"];
        self.password = [self prefForKey:@"password"];
#endif
        
        scheduleController = [[JRScheduleTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        JRLog(@"employeeID: %@, pass: %@", self.employeeID, self.password);
        
        if(self.employeeID && self.password) {
            self.session = [TKSession sessionForEmployee:[TKEmployee employeeWithID:self.employeeID password:self.password]];
        } else {
            self.topNavigationController = [self newThemedNavController];
            [self.topNavigationController pushViewController:logInViewController animated:NO];
        }
    }
    
    return _sharedJRMasterController = self;
}

- (void)dismissLogIn {

    self.employeeID = self.session.employee.employeeID;
    self.password = self.session.employee.password;
    [self save];
    
    [self.rootNavigationController dismissViewControllerAnimated:YES completion:^{
        [self.rootNavigationController popToRootViewControllerAnimated:NO];
    }];
}

- (void)presentUI {
    // push to root view
    
    if(self.topNavigationController) {
        [self.rootNavigationController presentViewController:self.topNavigationController animated:NO completion:nil];
    }
    
    [self.rootNavigationController pushViewController:scheduleController animated:NO];
}

- (void)save {

    [defaults setObject:self.employeeID forKey:@"employeeID"];
    [defaults setObject:self.password forKey:@"password"];
//    [defaults synchronize];
}

#pragma mark - Private methods

- (JRNavigationController *)newThemedNavController {
    JRNavigationController *nav = [[JRNavigationController alloc] initWithNavigationBarClass:[JRNavigationBar class] toolbarClass:[UIToolbar class]];
    nav.navigationBar.barTintColor = self.colorTheme.navigationBarColor;
    nav.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor] };
    nav.navigationBar.tintColor = self.colorTheme.accentColor;
    nav.navigationBar.barTintColor = self.colorTheme.navigationBarColor;
    nav.navigationBar.translucent = NO;
    
    JRNavigationBar *navBar = (JRNavigationBar *)nav.navigationBar;
    navBar.progressView.progressTintColor = self.colorTheme.accentColor;
    
    return nav;
}

- (void)verifyLogIn {
    
}

- (id)prefForKey:(NSString *)key {
    return [defaults objectForKey:key];
}

@end
