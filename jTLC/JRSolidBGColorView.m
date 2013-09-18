//
//  JRSolidBGColorView.m
//  jTLC
//
//  Created by John Heaton on 9/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRSolidBGColorView.h"

@implementation JRSolidBGColorView

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
    [[UIColor whiteColor] setFill];
}


@end
