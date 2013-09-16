//
//  JRLoginViewController.h
//  jTLC
//
//  Created by John Heaton on 9/15/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRLoginTableViewController : UITableViewController {
    NSString *submitTitle;
}

- (instancetype)initWithSubmitButtonTitle:(NSString *)title target:(id)target action:(SEL)action;

- (void)setShowingActivity:(BOOL)showing;

@end
