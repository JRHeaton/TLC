//
//  JRNavigationController.h
//  jTLC
//
//  Created by John Heaton on 9/18/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRNavigationBar.h"

@interface JRNavigationController : UINavigationController

@property (nonatomic, readonly) JRNavigationBar *navigationBar;

@end
