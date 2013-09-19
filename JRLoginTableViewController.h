//
//  JRLoginViewController.h
//  jTLC
//
//  Created by John Heaton on 9/15/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJB.h"
#import "TLCKit.h"

@interface JRLoginTableViewController : UITableViewController <UITextFieldDelegate> {
    NSString *submitTitle;
}

@property (nonatomic, assign) BOOL showingActivity;

PROP_COPY void (^completionBlock)(TKSession *session);

@end
