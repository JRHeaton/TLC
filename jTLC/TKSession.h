//
//  TKSession.h
//  tlcfetch
//
//  Created by John Heaton on 6/19/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TKEmployee;
typedef void (^TKSessionResultHandler)(BOOL success);

@interface TKSession : NSObject {
@private
    NSMutableArray  *_cachedShifts;
}

+ (TKSession *)sessionForEmployee:(TKEmployee *)employee;

@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic, readonly, strong) TKEmployee *employee;

@property (nonatomic, readonly, getter=isLoggedIn) BOOL loggedIn;
- (void)logIn:(TKSessionResultHandler)completionHandler;
- (void)logOut;
@property (nonatomic, readonly, copy) NSString *sessionIDCookie;

- (void)fetchEmployeeInfo:(TKSessionResultHandler)completionHandler;
- (void)fetchShifts:(TKSessionResultHandler)completionHandler;

- (void)fetchInfoForSessionEmployeeStore:(TKSessionResultHandler)completionHandler;
- (void)fetchInfoForStore:(TKStore *)store completion:(TKSessionResultHandler)completionHandler;

@property (nonatomic, readonly) NSArray *shifts;

@end