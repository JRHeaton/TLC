//
//  JRThemeManager.m
//  jTLC
//
//  Created by John Heaton on 9/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRThemeManager.h"

NSString *const JRThemeManagerThemeChangedOrAlteredNotification = @"JRThemeManagerThemeChangedNotification";
NSString *const JRThemeManagerThemeStatusBarStyleChangedNotification = @"JRThemeManagerThemeStatusBarStyleChangedNotification";

@implementation JRThemeManager {
    NSMutableDictionary *_dictionary;
}

static JRThemeManager *sharedJRThemeManager = nil;

+ (instancetype)sharedInstance {
    if(!sharedJRThemeManager)
        (void)[[self alloc] init];
    
    return sharedJRThemeManager;
}

- (instancetype)init {
    if(sharedJRThemeManager)
        return sharedJRThemeManager;
    
    if(self = [super init]) {
        _dictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    return sharedJRThemeManager = self;
}

- (void)updateViewsForColorType:(NSString *)type {
    for(NSString *keyPath in _dictionary.allKeys) {
        for(UIView *view in _dictionary[keyPath][type]) {
            [self sendMessageToView:view toUpdateKeyPath:keyPath toColor:[self.currentTheme colorForType:type]];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JRThemeManagerThemeChangedOrAlteredNotification object:self.currentTheme];
}

- (void)notifyThemeStatusBarStyleChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:JRThemeManagerThemeStatusBarStyleChangedNotification object:self.currentTheme];
}

- (void)setCurrentTheme:(JRTheme *)currentTheme {
    _currentTheme = currentTheme;
    
    for(NSString *keyPath in _dictionary.allKeys) {
        for(NSString *colorType in [_dictionary[keyPath] allKeys]) {
            for(UIView *view in _dictionary[keyPath][colorType]) {
                [self sendMessageToView:view toUpdateKeyPath:keyPath toColor:[self.currentTheme colorForType:colorType]];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JRThemeManagerThemeChangedOrAlteredNotification object:self.currentTheme];
}

- (void)sendMessageToView:(UIView *)view toUpdateKeyPath:(NSString *)keyPath toColor:(UIColor *)color {
    [view setValue:color forKeyPath:keyPath];
}

- (void)registerView:(UIView *)view keyPath:(NSString *)keyPath colorType:(NSString *)type {
    NSMutableDictionary *dict = _dictionary[keyPath];
    if(!dict)
        dict = _dictionary[keyPath] = [NSMutableDictionary dictionaryWithCapacity:0];

    NSMutableOrderedSet *views = dict[type];
    if(!views)
        views = dict[type] = [NSMutableOrderedSet orderedSetWithCapacity:0];
    
    [views addObject:view];
    if(self.currentTheme) {
        [self sendMessageToView:view toUpdateKeyPath:keyPath toColor:[self.currentTheme colorForType:type]];
    }
}

@end
