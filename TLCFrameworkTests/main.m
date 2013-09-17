//
//  main.m
//  TLCFrameworkTests
//
//  Created by John Heaton on 9/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLCKit.h"

static TKSession *session = nil;

void runTests() {
    session = [TKSession sessionForEmployee:[TKEmployee employeeWithID:@"a942228" password:@"PikaP7#$"]];
    
    printf("running login test...");
    [session logIn:^(BOOL success, NSString *errorString) {
//        printf(" result: %d", success);
//        printf("\n");
    }];
}

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        runTests();
    }
    
    CFRunLoopRun();
    
    return 0;
}

