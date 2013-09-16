//
//  TKTimePeriod.h
//  tlcfetch
//
//  Created by John Heaton on 6/20/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKConstants.h"

@interface TKTimePeriod : NSObject

+ (TKTimePeriod *)timePeriodFromDate:(NSDate *)startDate
                              toDate:(NSDate *)endDate;

@property (nonatomic, readonly, copy) NSDate *startDate;
@property (nonatomic, readonly, copy) NSDate *endDate;

@property (nonatomic, readonly) NSInteger dayOfMonth;
@property (nonatomic, readonly) NSInteger dayOfWeek;

@property (nonatomic, readonly) TKTime startTime;
@property (nonatomic, readonly) TKTime endTime;
@property (nonatomic, readonly) TKTime duration;

@end
