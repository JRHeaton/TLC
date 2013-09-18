//
//  JRThemedTableViewController.h
//  jTLC
//
//  Created by John Heaton on 9/18/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRTheme.h"

@interface JRThemedTableViewController : UITableViewController

- (void)themeChanged:(JRTheme *)theme;

@property (nonatomic, assign) CGFloat navigationBarProgress;


@end
