//
//  TKEmployee.m
//  tlcfetch
//
//  Created by John Heaton on 6/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "TKEmployee.h"

@interface TKEmployee ()
@property (nonatomic, readwrite, copy) NSString *employeeID;
@property (nonatomic, readwrite, copy) NSString *password;

@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *employmentStatus;

@property (nonatomic, readwrite, strong) TKDepartment *department;
@property (nonatomic, readwrite, strong) TKStore *store;
@end

@implementation TKEmployee

+ (TKEmployee *)employeeWithID:(NSString *)employeeID password:(NSString *)password {
    TKEmployee *e = [[self alloc] init];
    
    e.employeeID = employeeID;
    e.password = password;
    
    return e;
}

- (id)init {
    if(self = [super init]) {
        self.employeeID = nil;
        self.password = nil;
        self.name = @"Unknown";
        self.employmentStatus = @"Unknown";
        self.department = nil;
        self.store = nil;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [NSException raise:@"TKEmployeeEncodingException" format:@"-encodeWithCoder is not implemented yet."];
}

- (id)initWithCoder:(NSCoder *)decoder {
    [NSException raise:@"TKEmployeeEncodingException" format:@"-initWithCoder: is not implemented yet."];
    
    return nil;
}

- (NSString *)displayName {
    if(!_displayName)
        return self.name;
    
    return _displayName;
}

@end
