//
//  JRDarkCell.m
//  jTLC
//
//  Created by John Heaton on 8/2/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRDarkCell.h"

@implementation JRDarkCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
