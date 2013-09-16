//
//  JRTextInputTableViewCell.m
//  jTLC
//
//  Created by John Heaton on 7/10/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRTextInputTableViewCell.h"

@implementation JRTextInputTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textField = [[UITextField alloc] init];
        self.textField.font = [UIFont fontWithDescriptor:[UIFontDescriptor fontDescriptorWithName:@"Helvetica Neue UltraLight" size:22] size:22];
        [self.textField sizeToFit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect f = self.contentView.frame;
    CGRect lf = self.textLabel.frame;
    CGRect tf = self.textField.frame;
    
    tf.size.width = f.size.width - lf.size.width - 60;
    tf.origin.x = f.size.width - tf.size.width - 20;
    tf.origin.y = floor((f.size.height / 2) - (tf.size.height / 2));
    
    self.textField.frame = f;
    
    if(!self.textField.superview)
        [self.contentView addSubview:self.textField];
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
