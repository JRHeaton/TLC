//
//  JRProperImageCell.h
//  jTLC
//
//  Created by John Heaton on 9/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJB.h"

@interface JRProperImageCell : UITableViewCell

PROP_STRONG IBOutlet UIImageView *properImageView;
PROP_STRONG IBOutlet UILabel *properLabel, *properSubLabel;

@end
