//
//  JREmployeeDetailViewController.h
//  jTLC
//
//  Created by John Heaton on 9/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJB.h"
#import "TLCKit.h"

@interface JREmployeeDetailViewController : UITableViewController

PROP_STRONG TKEmployee *employee;
PROP_COPY void (^completionBlock)();

@end
