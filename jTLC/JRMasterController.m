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

#define DEBUG_LOGIN_UI 0

@interface JRMasterController ()

- (UINavigationController *)themedNavigationController;
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
        self.colorTheme = [JRColorTheme darkColorThemeWithAccentColor:[UIColor colorWithRed:.14 green:.533 blue:0.934 alpha:1]];
        
        self.rootNavigationController = [self themedNavigationController];
        logInViewController = [[JRLoginTableViewController alloc] init];
        
        __unsafe_unretained JRMasterController *_self = self;
        logInViewController.completionBlock = ^(TKSession *session) {
            _self.session = session;
            
            [_self performSelectorOnMainThread:@selector(dismissLogIn) withObject:nil waitUntilDone:NO];
        };
        
        scheduleViewController = [[JRScheduleViewController alloc] init];
        
        defaults = [NSUserDefaults standardUserDefaults];
        
        // TODO: ENCRYPT THAT SHIT
#if DEBUG_LOGIN_UI
        self.employeeID = nil;
        self.password = nil;
#else
        self.employeeID = [self prefForKey:@"employeeID"];
        self.password = [self prefForKey:@"password"];
#endif
        
        JRLog(@"employeeID: %@, pass: %@", self.employeeID, self.password);
        
        if(self.employeeID && self.password) {
            self.session = [TKSession sessionForEmployee:[TKEmployee employeeWithID:self.employeeID password:self.password]];
        } else {
            self.topNavigationController = [self themedNavigationController];
            [self.topNavigationController pushViewController:logInViewController animated:NO];
        }
    }
    
    return _sharedJRMasterController = self;
}

- (void)dismissLogIn {
    NSLog(@"%@", self.session.employee.employeeID);
    self.employeeID = self.session.employee.employeeID;
    self.password = self.session.employee.password;
    [self save];
    
    [self.rootNavigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)presentUI {
    // push to root view
    
    if(self.topNavigationController) {
        [self.rootNavigationController presentViewController:self.topNavigationController animated:NO completion:nil];
    }
    
    [self.rootNavigationController pushViewController:scheduleViewController animated:NO];
}

- (void)save {
    NSLog(@"%@", defaults);
    [defaults setObject:self.employeeID forKey:@"employeeID"];
    [defaults setObject:self.password forKey:@"password"];
    [defaults synchronize];
}

#pragma mark - Private methods

- (UINavigationController *)themedNavigationController {
    UINavigationController *nav = [UINavigationController new];
    nav.navigationBar.barTintColor = self.colorTheme.navigationBarColor;
    nav.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor] };
    
    return nav;
}

- (void)verifyLogIn {
    
}

- (id)prefForKey:(NSString *)key {
    return [defaults objectForKey:key];
}

@end
