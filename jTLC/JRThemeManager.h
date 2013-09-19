//
//  JRThemeManager.h
//  jTLC
//
//  Created by John Heaton on 9/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRTheme.h"

@interface JRThemeManager : NSObject

+ (instancetype)sharedInstance;

- (void)registerView:(UIView *)view keyPath:(NSString *)keyPath colorType:(NSString *)type;

@property (nonatomic, strong) JRTheme *currentTheme;

@end

static NSString *const JRThemeManagerKeyPathBackgroundColor     = @"backgroundColor";
static NSString *const JRThemeManagerKeyPathTintColor           = @"tintColor";
static NSString *const JRThemeManagerKeyPathBarTintColor        = @"barTintColor";
static NSString *const JRThemeManagerKeyPathColor               = @"color";
static NSString *const JRThemeManagerKeyPathThumbTintColor      = @"thumbTintColor";
static NSString *const JRThemeManagerKeyPathOnTintColor         = @"onTintColor";
static NSString *const JRThemeManagerKeyPathSeparatorColor      = @"separatorColor";
static NSString *const JRThemeManagerKeyPathProgressTintColor   = @"progressTintColor";


NSString *const JRThemeManagerThemeChangedOrAlteredNotification;
NSString *const JRThemeManagerThemeStatusBarStyleChangedNotification;