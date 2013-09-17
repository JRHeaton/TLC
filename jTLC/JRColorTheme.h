//
//  JRColorTheme.h
//  jTLC
//
//  Created by John Heaton on 9/16/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJB.h"

@interface JRColorTheme : NSObject

+ (instancetype)darkColorThemeWithAccentColor:(UIColor *)accent;

PROP_STRONG UIColor *backgroundColor;
PROP_STRONG UIColor *foregroundColor;
PROP_STRONG UIColor *navigationBarColor;
PROP_STRONG UIColor *labelColor;
PROP_STRONG UIColor *tableSeparatorColor;
PROP_STRONG UIColor *accentColor;
PROP_STRONG UIColor *secondaryAccentColor;

PROP_STRONG UIColor *subtitleTextColor;

PROP_STRONG UIColor *disabledColor;

@end
