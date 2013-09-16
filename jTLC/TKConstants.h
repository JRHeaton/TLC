//
//  TKConstants.h
//  TLCKit
//
//  Created by John Heaton on 6/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#define TKHomeURL               [NSURL URLWithString:@"https://mytlc.bestbuy.com/"]
#define TKLoginURL              [NSURL URLWithString:@"https://mytlc.bestbuy.com/etm/login.jsp"]
#define TKAvailabilityChangeURL [NSURL URLWithString:@"https://mytlc.bestbuy.com/etm/messaging/etmBOView.jsp?msg_id=null&busObjTyp_id=20051&folder_id=null&newOld=null&parentID=1000000442&selectedTocID=1000000303&parentID=1000000442"]
#define TKCalendarURL           [NSURL URLWithString:@"https://mytlc.bestbuy.com/etm/time/timesheet/etmTnsMonth.jsp"]
#define TKStoreDetailURL(num)   [NSURL URLWithString:[NSString stringWithFormat:@"http://stores.bestbuy.com/%li/details", (num)]]

typedef struct {
    NSInteger hour;
    NSInteger minute;
} TKTime;

#define TKTimeCreate(hour, minute) (TKTime){ (hour), (minute) }