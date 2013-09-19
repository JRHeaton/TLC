//
//  JRColorRoundedRectView.m
//  jTLC
//
//  Created by John Heaton on 9/18/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRColorRoundedRectView.h"
#import "JRInterfaceTheme.h"

@implementation JRColorRoundedRectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cornerRadius = 10;
        self.tintColor = [[JRInterfaceTheme currentTheme] colorForType:JRInterfaceColorTypeAccentPrimary];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *p = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.cornerRadius];
    [self.tintColor setFill];
    [p fill];
}


@end
