//
//  JRDarkCell.h
//  jTLC
//
//  Created by John Heaton on 8/2/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRDarkCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *fromTime, *toTime;
@property (nonatomic, strong) IBOutlet UILabel *dayLabel, *dateLabel, *deptLabel;

@end
