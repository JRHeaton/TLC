//
//  JRShiftTableCell.h
//  jTLC
//
//  Created by John Heaton on 9/18/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRColorRoundedRectView.h"

@interface JRShiftTableCell : UITableViewCell

@property (nonatomic, strong) IBOutlet JRColorRoundedRectView *roundedRectView;
@property (nonatomic, strong) IBOutlet UILabel *dayOfMonthLabel;
@property (nonatomic, strong) IBOutlet UILabel *hourLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@end
