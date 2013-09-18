//
//  JRColorTheme.m
//  jTLC
//
//  Created by John Heaton on 9/16/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRColorTheme.h"

@implementation JRColorTheme

+ (instancetype)darkColorThemeWithAccentColor:(UIColor *)accent {
    JRColorTheme *theme = [self new];
    
    theme.backgroundColor       = [UIColor colorWithWhite:0.2 alpha:1];
    theme.foregroundColor       = [UIColor colorWithWhite:0.3 alpha:1];
    theme.labelColor            = [UIColor whiteColor];
    theme.tableSeparatorColor   = [UIColor colorWithWhite:0.8 alpha:0.2];
    theme.disabledColor         = [UIColor colorWithWhite:0.6 alpha:1];
    theme.navigationBarColor    = theme.foregroundColor;
    theme.accentColor           = accent;
    
    theme.disabledTextColor     = [UIColor colorWithWhite:0.5 alpha:1];
    theme.subtitleTextColor     = [UIColor colorWithWhite:0.8 alpha:1];
    
    return theme;
}

@end
