//
//  JRLoginViewController.h
//  jTLC
//
//  Created by John Heaton on 9/18/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRLoginViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, copy) NSString *employeeID, *password;
@property (nonatomic, assign) BOOL showingActivity;
@property (nonatomic, assign) BOOL automaticallyShowKeyboard;

- (void)reset;

@end
