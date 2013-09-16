//
//  TKShift.m
//  tlcfetch
//
//  Created by John Heaton on 6/18/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "TKShift.h"
#import "TKStore.h"
#import "TKDepartment.h"

@interface TKShift ()

@property (nonatomic, readwrite, strong) TKDepartment *department;
@property (nonatomic, readwrite, strong) TKStore *store;

- (void)_calculateProperties;

@end

@implementation TKShift

#define TKTimeLog(time) NSLog(@"TKShift(%s): hour=%02li, minute=%02li", #time, time.hour, time.minute)

+ (TKShift *)shiftFromDate:(NSDate *)startDate toDate:(NSDate *)endDate inDepartment:(TKDepartment *)department {
    TKShift *shift = (TKShift *)[super timePeriodFromDate:startDate toDate:endDate];
    
    shift.department = department;
    shift.store = [TKStore storeWithStoreNumber:shift.department.storeNumber];
    
    return shift;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%@ dayOfMonth=%li, startTime=%02li:%02li, endTime=%02li:%02li, duration=%02li:%02li", [super description], self.dayOfMonth, self.startTime.hour, self.startTime.minute, self.endTime.hour, self.endTime.minute, self.duration.hour, self.duration.minute];
}

- (BOOL)eligibleForLunch {
    BOOL eligible = NO;
    
    if(self.duration.hour == 7)
        eligible = self.duration.minute >= 30;
    else if(self.duration.hour > 7)
        eligible = YES;
    
    return eligible;
}

- (TKShiftType)type {
    if(!self.store.address)
        return TKShiftTypeUnknown;
    
    TKTimePeriod *storeHours = [self.store openHoursForDayOfWeek:self.dayOfWeek];

    if(self.endTime.hour > storeHours.endTime.hour)
        return TKShiftTypeClose;
    else if(storeHours.startTime.hour - self.startTime.hour == 1 && storeHours.startTime.minute - self.startTime.minute <= 30)
        return TKShiftTypeOpen;
    else if(storeHours.startTime.hour == self.startTime.hour)
        return TKShiftTypeOpen;
    else if(self.startTime.hour > storeHours.startTime.hour && self.endTime.hour < storeHours.endTime.hour)
        return TKShiftTypeMid;
    else if(self.startTime.hour > storeHours.startTime.hour && self.endTime.hour <= storeHours.endTime.hour && self.endTime.minute == storeHours.endTime.minute)
        return TKShiftTypeMid;
    else if(self.startTime.hour <= 8 && self.duration.hour > 2)
        return TKShiftTypeAdSet;
    else if(self.endTime.hour == storeHours.endTime.hour && self.endTime.minute > storeHours.endTime.minute)
        return TKShiftTypeClose;
    
    return TKShiftTypeUnknown;
}

@end
