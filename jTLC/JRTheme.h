//
//  JRTheme.h
//  jTLC
//
//  Created by John Heaton on 9/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JRTheme : NSObject

+ (instancetype)themeWithColorsAndTypes:(NSDictionary *)colorsDictionary;

- (UIColor *)colorForType:(NSString *)type;
- (void)setColor:(UIColor *)color forType:(NSString *)type;

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@end

NSString *const JRThemeColorTypeBackground;
NSString *const JRThemeColorTypeForeground;
NSString *const JRThemeColorTypeAccentPrimary;
NSString *const JRThemeColorTypeAccentSecondary;
NSString *const JRThemeColorTypeTitle;
NSString *const JRThemeColorTypeSubtitle;
NSString *const JRThemeColorTypeBody;