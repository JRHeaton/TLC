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

#define DEBUG_LOGIN_UI 0

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
        self.theme = [JRInterfaceTheme themeNamed:@"JRDarkTheme"];
        
//        [self.theme addColorsForTypesFromDictionary:@{
//                                                      JRInterfaceColorTypeBackground : [UIColor colorWithWhite:0.2 alpha:1],
//                                                      JRInterfaceColorTypeForeground : [UIColor colorWithWhite:0.3 alpha:1],
//                                                      JRInterfaceColorTypeAccentPrimary : [UIColor colorWithRed:0 green:.67 blue:.94 alpha:1],
//                                                      JRInterfaceColorTypeTitleText : [UIColor whiteColor],
//                                                      JRInterfaceColorTypeSubtitleText : [UIColor colorWithWhite:0.6 alpha:1],
//                                                      JRInterfaceColorTypeDisabledText : [UIColor colorWithWhite:0.5 alpha:1],
//                                                      JRInterfaceColorTypeTableSeparator : [UIColor colorWithWhite:0.8 alpha:0.2],
//                                                      JRInterfaceColorTypeSwitchThumbTint : [UIColor colorWithWhite:0.2 alpha:1]
//
//                                                      }];
//        self.theme.keyboardAppearance = UIKeyboardAppearanceDark;
//        self.theme.statusBarStyle = UIStatusBarStyleLightContent;
        
        self.lightTheme = [JRInterfaceTheme new];
        [self.lightTheme addColorsForTypesFromDictionary:@{
                                                      JRInterfaceColorTypeBackground : [UIColor colorWithWhite:0.9 alpha:1],
                                                      JRInterfaceColorTypeForeground : [UIColor colorWithWhite:1 alpha:1],
                                                      JRInterfaceColorTypeAccentPrimary : [UIColor redColor],
                                                      JRInterfaceColorTypeTitleText : [UIColor blackColor],
                                                      JRInterfaceColorTypeSubtitleText : [UIColor colorWithWhite:0.6 alpha:1],
                                                      JRInterfaceColorTypeDisabledText : [UIColor colorWithWhite:0.5 alpha:1],
                                                      JRInterfaceColorTypeTableSeparator : [UIColor colorWithWhite:0.4 alpha:0.4],
                                                      JRInterfaceColorTypeSwitchThumbTint : [UIColor colorWithWhite:.9 alpha:1]
                                                      }];
        self.lightTheme.keyboardAppearance = UIKeyboardAppearanceLight;
        self.lightTheme.statusBarStyle = UIStatusBarStyleDefault;
#define LIGHT_UI 0
#if LIGHT_UI == 1
        [JRInterfaceTheme setCurrentTheme:self.lightTheme];
#else
        [JRInterfaceTheme setCurrentTheme:self.theme];

#endif
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeUpdated:) name:JRInterfaceThemeChangedNotification object:nil];
        
        
        scheduleViewController = [[JRScheduleViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
        self.rootNavigationController = [self newThemedNavController];
        logInViewController = [[JRLoginViewController alloc] init];
        logInViewController.automaticallyShowKeyboard = YES;
        logInViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        __unsafe_unretained JRMasterController *_self = self;
//        logInViewController.completionBlock = ^(TKSession *session) {
//            _self.session = session;
//            
//            [_self performSelectorOnMainThread:@selector(dismissLogIn) withObject:nil waitUntilDone:NO];
//        };
        
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

- (void)themeUpdated:(NSNotification *)notification {
    self.theme = [JRInterfaceTheme currentTheme];
    
    [self applyThemeToNavController:self.topNavigationController];
    [self applyThemeToNavController:self.rootNavigationController];
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
    
    [self.rootNavigationController pushViewController:scheduleViewController animated:NO];
}

- (void)save {

    [defaults setObject:self.employeeID forKey:@"employeeID"];
    [defaults setObject:self.password forKey:@"password"];
//    [defaults synchronize];
}

- (void)applyThemeToNavController:(UINavigationController *)nav {
    JRInterfaceTheme *theme = [JRInterfaceTheme currentTheme];
    
    nav.navigationBar.barTintColor = [theme colorForType:JRInterfaceColorTypeForeground];
    nav.navigationBar.tintColor = [theme colorForType:JRInterfaceColorTypeAccentPrimary];
    
    nav.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [theme colorForType:JRInterfaceColorTypeTitleText] };
}

#pragma mark - Private methods

- (JRNavigationController *)newThemedNavController {
    JRNavigationController *nav = [[JRNavigationController alloc] initWithNavigationBarClass:[JRNavigationBar class] toolbarClass:[UIToolbar class]];
    
    nav.navigationBar.translucent = nav.toolbar.translucent = NO;
    
    [self applyThemeToNavController:nav];
    
    return nav;
}

- (void)verifyLogIn {
    
}

- (id)prefForKey:(NSString *)key {
    return [defaults objectForKey:key];
}

@end
