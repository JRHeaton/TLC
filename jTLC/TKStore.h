//
//  TKStore.h
//  tlcfetch
//
//  Created by John Heaton on 6/19/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKTimePeriod.h"

@interface TKStore : NSObject

+ (TKStore *)storeWithStoreNumber:(NSInteger)storeNumber;

@property (nonatomic, readonly) NSInteger storeNumber;
@property (nonatomic, readonly, copy) NSString *address;

@property (nonatomic, readonly, strong) NSArray *openHoursTimePeriods;
- (TKTimePeriod *)openHoursForDayOfWeek:(NSInteger)dayOfWeek;

@end
