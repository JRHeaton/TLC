//
//  JRLightPlaceholderTextField.m
//  jTLC
//
//  Created by John Heaton on 9/15/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRLightPlaceholderTextField.h"
#import "JRMasterController.h"

@implementation JRLightPlaceholderTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
    if(!self.placeholderColor)
        self.placeholderColor = [JRMasterController sharedInstance].colorTheme.disabledColor;

    [self setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:placeholder attributes:@{ NSForegroundColorAttributeName : self.placeholderColor }]];
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
