//
//  JRTheme.m
//  jTLC
//
//  Created by John Heaton on 9/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRTheme.h"
#import "JRThemeManager.h"

#define STR(name) NSString *const name = @#name;
STR(JRThemeColorTypeBackground);
STR(JRThemeColorTypeForeground);
STR(JRThemeColorTypeAccentPrimary);
STR(JRThemeColorTypeAccentSecondary);
STR(JRThemeColorTypeTitle);
STR(JRThemeColorTypeSubtitle);
STR(JRThemeColorTypeBody);
STR(JRThemeColorTypeDisabledControl);
STR(JRThemeColorTypeTableSeparator);

STR(JRThemeColorChangedNotification);
#undef STR

@interface JRThemeManager (Private)

- (void)updateViewsForColorType:(NSString *)type;
- (void)notifyThemeStatusBarStyleChanged;

@end

@implementation JRTheme {
    NSMutableDictionary *_dictionary;
}

+ (instancetype)themeWithColorsAndTypes:(NSDictionary *)colorsDictionary {
    JRTheme *theme = [JRTheme new];
    
    [[theme _colorDictionary] addEntriesFromDictionary:colorsDictionary];
    
    return theme;
}

- (instancetype)init {
    if(self = [super init]) {
        _dictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    return self;
}

- (UIColor *)colorForType:(NSString *)type {
    UIColor *color = _dictionary[type];
    if(!color)
        color = [UIColor whiteColor];
    
    return color;
}

- (void)setColor:(UIColor *)color forType:(NSString *)type {
    _dictionary[type] = color;
    
    if([JRThemeManager sharedInstance].currentTheme == self) {
        [[JRThemeManager sharedInstance] updateViewsForColorType:type];
    }
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    
    [[JRThemeManager sharedInstance] notifyThemeStatusBarStyleChanged];
}

- (NSMutableDictionary *)_colorDictionary {
    return _dictionary;
}

@end
