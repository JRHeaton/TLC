//
//  JRRoundedColorView.m
//  jTLC
//
//  Created by John Heaton on 9/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRRoundedColorView.h"
#import "JRMasterController.h"

@implementation JRRoundedColorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.tintColor = [JRMasterController sharedInstance].colorTheme.accentColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
//    UIBezierPath *p = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:15];
    UIBezierPath *p = [UIBezierPath bezierPathWithRect:rect];
    [self.tintColor setFill];
    [p fill];
}


@end
