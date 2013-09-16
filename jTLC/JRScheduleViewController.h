//
//  JRScheduleViewController.h
//  jTLC
//
//  Created by John Heaton on 9/16/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLCKit.h"
#import "GJB.h"

@interface JRScheduleViewController : UICollectionViewController

PROP_STRONG TKSession *session;
PROP_STRONG UICollectionViewFlowLayout *layout;

@end
