//
//  JRLineView.m
//  jTLC
//
//  Created by John Heaton on 7/10/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRLineView.h"

@implementation JRLineView

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
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    [self.color setStroke];
    CGContextSetLineWidth(c, 0.5);
    CGContextMoveToPoint(c, 0, 0);
    CGContextAddLineToPoint(c, self.bounds.size.width, 0);
    CGContextStrokePath(c);
}


@end
