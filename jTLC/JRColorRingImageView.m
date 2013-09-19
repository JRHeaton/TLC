//
//  JRColorRingImageView.m
//  jTLC
//
//  Created by John Heaton on 9/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRColorRingImageView.h"
#import "JRMasterController.h"

@implementation JRColorRingImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [[JRMasterController sharedInstance].colorTheme.accentColor setFill];
    [path fill];
    
//    [super drawRect:rect];
}

@end
