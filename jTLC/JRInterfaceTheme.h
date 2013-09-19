//
//  JRInterfaceTheme.h
//  jTLC
//
//  Created by John Heaton on 9/18/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *JRInterfaceColorType;
typedef NSString *JRInterfaceFontType;

@interface JRInterfaceTheme : NSObject <NSCoding>

+ (instancetype)currentTheme;
+ (instancetype)themeNamed:(NSString *)file;
+ (void)setCurrentTheme:(JRInterfaceTheme *)theme;

- (void)setColor:(UIColor *)color forColorType:(JRInterfaceColorType)type;
- (void)addColorsForTypesFromDictionary:(NSDictionary *)dictionary;

- (void)setFont:(UIFont *)font forFontType:(JRInterfaceFontType)type;
- (void)addFontsForTypesFromDictionary:(NSDictionary *)dictionary;

- (UIColor *)colorForType:(JRInterfaceColorType)type;
- (UIFont *)fontForType:(JRInterfaceFontType)type;

@property (nonatomic, readonly, strong) NSMutableDictionary *colors;
@property (nonatomic, readonly, strong) NSMutableDictionary *fonts;

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) UIKeyboardAppearance keyboardAppearance;

- (BOOL)writeToFile:(NSString *)file;

@end

NSString *const JRInterfaceThemeChangedNotification;

#define JRInterfaceConstant(type, name) static type const name = @#name;

// Generic
JRInterfaceConstant(JRInterfaceColorType, JRInterfaceColorTypeBackground);
JRInterfaceConstant(JRInterfaceColorType, JRInterfaceColorTypeForeground);
JRInterfaceConstant(JRInterfaceColorType, JRInterfaceColorTypeAccentPrimary);
JRInterfaceConstant(JRInterfaceColorType, JRInterfaceColorTypeAccentSecondary);
JRInterfaceConstant(JRInterfaceColorType, JRInterfaceColorTypeTitleText);
JRInterfaceConstant(JRInterfaceColorType, JRInterfaceColorTypeSubtitleText);
JRInterfaceConstant(JRInterfaceColorType, JRInterfaceColorTypeBodyText);
JRInterfaceConstant(JRInterfaceColorType, JRInterfaceColorTypeDisabledText);

JRInterfaceFontType const JRInterfaceFontTypeTitleText;
JRInterfaceFontType const JRInterfaceFontTypeSubtitleText;
JRInterfaceFontType const JRInterfaceFontTypeBodyText;

// UIKit
JRInterfaceConstant(JRInterfaceColorType, JRInterfaceColorTypeBarTint);
JRInterfaceConstant(JRInterfaceColorType, JRInterfaceColorTypeBarItemTint);
JRInterfaceConstant(JRInterfaceColorType, JRInterfaceColorTypeSwitchThumbTint);
JRInterfaceConstant(JRInterfaceColorType, JRInterfaceColorTypeSwitchOnTint);
JRInterfaceConstant(JRInterfaceColorType, JRInterfaceColorTypeSwitchTint);
JRInterfaceConstant(JRInterfaceColorType, JRInterfaceColorTypeTableSeparator);

