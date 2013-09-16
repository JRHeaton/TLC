//
//  TKEmployee.h
//  tlcfetch
//
//  Created by John Heaton on 6/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TKDepartment;
@class TKStore;

@interface TKEmployee : NSObject

+ (TKEmployee *)employeeWithID:(NSString *)employeeID password:(NSString *)password;

@property (nonatomic, readonly, copy) NSString *employeeID;
@property (nonatomic, readonly, copy) NSString *password;

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *employmentStatus;

@property (nonatomic, readonly, strong) TKDepartment *department;
@property (nonatomic, readonly, strong) TKStore *store;

@property (nonatomic, copy) NSString *displayName;

@end