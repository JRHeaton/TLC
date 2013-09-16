//
//  TKShift.h
//  tlcfetch
//
//  Created by John Heaton on 6/18/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKTimePeriod.h"

@class TKDepartment;
@class TKStore;

typedef NS_ENUM(NSInteger, TKShiftType) {
    TKShiftTypeOpen,
    TKShiftTypeMid,
    TKShiftTypeClose,
    TKShiftTypeAdSet,
    TKShiftTypeUnknown
};

@interface TKShift : TKTimePeriod

+ (TKShift *)shiftFromDate:(NSDate *)startDate
                    toDate:(NSDate *)endDate
              inDepartment:(TKDepartment *)department;

@property (nonatomic, readonly) BOOL eligibleForLunch;

@property (nonatomic, readonly, strong) TKDepartment    *department;
@property (nonatomic, readonly, strong) TKStore         *store;

@property (nonatomic, readonly) TKShiftType type;

@end

static inline NSString *TKShiftTypeName(TKShiftType type) {
    if(type == TKShiftTypeOpen) return @"Open";
    else if(type == TKShiftTypeMid) return @"Mid";
    else if(type == TKShiftTypeClose) return @"Close";
    else if(type == TKShiftTypeAdSet) return @"AdSet";
    else if(type == TKShiftTypeUnknown) return @"Unknown";

    return nil;
}
