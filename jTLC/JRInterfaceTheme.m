//
//  JRInterfaceTheme.m
//  jTLC
//
//  Created by John Heaton on 9/18/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRInterfaceTheme.h"

@implementation JRInterfaceTheme {
    NSMutableDictionary *_fonts, *_colors;
}

NSString *const JRInterfaceThemeChangedNotification = @"JRInterfaceThemeChangedNotification";
static JRInterfaceTheme *_sharedJRInterfaceTheme = nil;

+ (instancetype)currentTheme {
    return _sharedJRInterfaceTheme;
}

+ (instancetype)themeNamed:(NSString *)file {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:file ofType:@"tlctheme"]];
}

+ (void)setCurrentTheme:(JRInterfaceTheme *)theme {
    if(theme != _sharedJRInterfaceTheme) {
        _sharedJRInterfaceTheme = theme;
        [self notifyThemeChanged];
    }
}

+ (void)notifyThemeChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:JRInterfaceThemeChangedNotification object:_sharedJRInterfaceTheme];
}

- (instancetype)initWithCoder:(NSCoder *)d {
    self = [super init];
    if(self) {
        self.statusBarStyle = [d decodeIntegerForKey:@"statusBarStyle"];
        self.keyboardAppearance = [d decodeIntegerForKey:@"keyboardAppearance"];
        _fonts = [d decodeObjectForKey:@"_fonts"];
        _colors = [d decodeObjectForKey:@"_colors"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)c {
    [c encodeInteger:self.statusBarStyle forKey:@"statusBarStyle"];
    [c encodeInteger:self.keyboardAppearance forKey:@"keyboardAppearance"];
    [c encodeObject:_fonts forKey:@"_fonts"];
    [c encodeObject:_colors forKey:@"_colors"];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _fonts = [NSMutableDictionary dictionaryWithCapacity:0];
        _colors = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    return self;
}

- (void)setColor:(UIColor *)color forColorType:(JRInterfaceColorType)type {
    if(color && type) {
        _colors[type] = color;
    }
    
    if(self == _sharedJRInterfaceTheme)
        [[self class] notifyThemeChanged];
}

- (void)addColorsForTypesFromDictionary:(NSDictionary *)dictionary {
    [_colors addEntriesFromDictionary:dictionary];
    
    if(self == _sharedJRInterfaceTheme)
        [[self class] notifyThemeChanged];
}

- (void)setFont:(UIFont *)font forFontType:(JRInterfaceFontType)type {
    if(font && type) {
        _fonts[type] = font;
    }
    
    if(self == _sharedJRInterfaceTheme)
        [[self class] notifyThemeChanged];
}

- (void)addFontsForTypesFromDictionary:(NSDictionary *)dictionary {
    [_fonts addEntriesFromDictionary:dictionary];
    
    if(self == _sharedJRInterfaceTheme)
        [[self class] notifyThemeChanged];
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    
    if(self == _sharedJRInterfaceTheme)
        [[self class] notifyThemeChanged];
}

- (void)setKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance {
    _keyboardAppearance = keyboardAppearance;
    
    if(self == _sharedJRInterfaceTheme)
        [[self class] notifyThemeChanged];
}

- (UIColor *)colorForType:(JRInterfaceColorType)type {
    return _colors[type];
}

- (UIFont *)fontForType:(JRInterfaceFontType)type {
    return _fonts[type];
}

- (BOOL)writeToFile:(NSString *)file {
    return [NSKeyedArchiver archiveRootObject:self toFile:file];
}

@end
