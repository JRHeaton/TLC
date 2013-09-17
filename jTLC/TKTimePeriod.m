//
//  TKTimePeriod.m
//  tlcfetch
//
//  Created by John Heaton on 6/20/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "TKTimePeriod.h"

@interface TKTimePeriod ()
@property (nonatomic, readwrite, copy) NSDate *startDate;
@property (nonatomic, readwrite, copy) NSDate *endDate;

@property (nonatomic, readwrite) NSInteger dayOfMonth;
@property (nonatomic, readwrite) NSInteger dayOfWeek;

@property (nonatomic, readwrite) TKTime startTime;
@property (nonatomic, readwrite) TKTime endTime;
@property (nonatomic, readwrite) TKTime duration;
@end

@implementation TKTimePeriod

+ (TKTimePeriod *)timePeriodFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    TKTimePeriod *period = [[self alloc] init];
    
    period.startDate = startDate;
    period.endDate = endDate;
    [period _calculateProperties];
    
    return period;
}


- (void)_calculateProperties {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    NSDateComponents *startComps = [calendar components:NSCalendarUnitHour | NSCalendarUnitWeekday | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth fromDate:self.startDate];
    NSDateComponents *endComps = [calendar components:NSCalendarUnitHour | NSCalendarUnitWeekday | NSCalendarUnitMinute | NSCalendarUnitDay fromDate:self.endDate];
    NSDateComponents *deltaComps = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self.startDate toDate:self.endDate options:0];
#elif TARGET_OS_MAC
    NSDateComponents *startComps = [calendar components:NSHourCalendarUnit | NSWeekdayCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit fromDate:self.startDate];
    NSDateComponents *endComps = [calendar components:NSHourCalendarUnit | NSWeekdayCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit fromDate:self.endDate];
    NSDateComponents *deltaComps = [calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:self.startDate toDate:self.endDate options:0];
#endif
    
    self.startTime = TKTimeCreate(startComps.hour, startComps.minute);
    self.endTime = TKTimeCreate(endComps.hour, endComps.minute);
    self.duration = TKTimeCreate(deltaComps.hour, deltaComps.minute);
    
    self.dayOfMonth = startComps.day;
    self.dayOfWeek = startComps.weekday - 1;
}

@end
