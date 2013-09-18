//
//  JRNavigationBar.m
//  jTLC
//
//  Created by John Heaton on 9/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRNavigationBar.h"

@implementation JRNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        [self.progressView sizeToFit];
        [self addSubview:self.progressView];
        
        self.progressView.progress = 0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.progressView.frame = CGRectMake(0, self.frame.size.height - self.progressView.frame.size.height, self.frame.size.width, self.progressView.frame.size.height);
}

@end
