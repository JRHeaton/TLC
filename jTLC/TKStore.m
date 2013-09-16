//
//  TKStore.m
//  tlcfetch
//
//  Created by John Heaton on 6/19/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "TKStore.h"

@interface TKStore ()
@property (nonatomic, readwrite) NSInteger storeNumber;
@property (nonatomic, readwrite, copy) NSString *address;
@property (nonatomic, readwrite, strong) NSArray *openHoursTimePeriods;
@end

@implementation TKStore

static NSMutableDictionary *_TKStoreCats = nil;

+ (void)load {
    _TKStoreCats = [NSMutableDictionary dictionaryWithCapacity:0];
}

+ (TKStore *)storeWithStoreNumber:(NSInteger)storeNumber {
    TKStore *s;
    NSString *storeNumStr = [NSString stringWithFormat:@"%ld", (long)storeNumber];
    
    if((s = _TKStoreCats[storeNumStr]) != nil)
        return s;
        
    s = [[self alloc] init];
    
    s.storeNumber = storeNumber;
    _TKStoreCats[storeNumStr] = s;
        
    return s;
}

- (id)init {
    if(self = [super init]) {
        self.storeNumber = -1;
        self.address = nil;
    }
    
    return self;
}

- (TKTimePeriod *)openHoursForDayOfWeek:(NSInteger)dayOfWeek {
    return self.openHoursTimePeriods[dayOfWeek];
}

@end
