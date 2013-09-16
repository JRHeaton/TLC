//
//  JRScheduleViewController.h
//  jTLC
//
//  Created by John Heaton on 8/2/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLCKit.h"

@interface JRScheduleViewController : UITableViewController <UIActionSheetDelegate> {
    NSArray *shifts;
    BOOL hasToday, hasTomorrow;
}

@property (nonatomic, strong) TKSession *session;

- (void)parseTableData;
- (void)penis;

@end
