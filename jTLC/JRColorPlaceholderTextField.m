//
//  JRColorPlaceholderTextField.m
//  jTLC
//
//  Created by John Heaton on 8/1/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRColorPlaceholderTextField.h"

@implementation JRColorPlaceholderTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    
    [self.placeholder drawInRect:rect withAttributes:@{ NSForegroundColorAttributeName : self.placeholderColor, NSFontAttributeName : self.font, NSParagraphStyleAttributeName : style }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
