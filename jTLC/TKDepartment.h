//
//  TKDepartment.h
//  tlcfetch
//
//  Created by John Heaton on 6/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKDepartment : NSObject

+ (TKDepartment *)departmentForIdentifier:(NSString *)identifier;

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly) NSInteger storeNumber;

@property (nonatomic, readonly, copy) NSString *identifier;

@end
