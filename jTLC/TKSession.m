//
//  TKSession.m
//  tlcfetch
//
//  Created by John Heaton on 6/19/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "TFHpple.h"
#import "TLCKit.h"
#import "GJB.h"

@interface TKSession ()

@property (nonatomic, readwrite, getter=isLoggedIn) BOOL loggedIn;
@property (nonatomic, readwrite, strong) TKEmployee *employee;
@property (nonatomic, readwrite, copy) NSString *sessionIDCookie;

- (void)_sendSynchronousRequest:(NSMutableURLRequest *)request pageData:(NSData **)pageData response:(NSHTTPURLResponse **)response error:(NSError **)error;

@end

@interface TKEmployee ()
@property (nonatomic, readwrite, copy) NSString *employeeID;
@property (nonatomic, readwrite, copy) NSString *password;

@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *employmentStatus;

@property (nonatomic, readwrite, strong) TKDepartment *department;
@property (nonatomic, readwrite, strong) TKStore *store;
@end

@interface TKStore ()
@property (nonatomic, readwrite) NSInteger storeNumber;
@property (nonatomic, readwrite, copy) NSString *address;
@property (nonatomic, readwrite, strong) NSArray *openHoursTimePeriods;
@end


@implementation TKSession

+ (TKSession *)sessionForEmployee:(TKEmployee *)employee {
    return [[self alloc] initWithEmployee:employee];
}

- (id)initWithEmployee:(TKEmployee *)employee {
    if(employee && (self = [super init])) {
        _cachedShifts = [NSMutableArray arrayWithCapacity:0];
        self.loggedIn = NO;
        self.sessionIDCookie = nil;
        self.employee = employee;
        self.queue = [NSOperationQueue new];
    }
    
    return self;
}

- (void)logIn:(TKSessionLogInResultHandler)completionHandler {
    if(self.loggedIn) {
        completionHandler(YES, nil);
        return;
    }
    
    [self.queue addOperationWithBlock:^{
        TFHpple                 *pageDoc;
        NSData                  *pageData;
        NSString                *token;
        NSMutableURLRequest     *request;
        NSString                *httpBody;
        NSHTTPURLResponse       *response;
        NSError                 *error;
    
        @try {
            [self _sendSynchronousRequest:[NSMutableURLRequest requestWithURL:TKLoginURL] pageData:&pageData response:&response error:&error];
            if(error) {
                completionHandler(NO, @"Couldn't reach TLC");
                return;
            }
            pageDoc = [[TFHpple alloc] initWithHTMLData:pageData];
            
            TFHppleElement *e = [[pageDoc searchWithXPathQuery:@"//input[@name='url_login_token']"] objectAtIndex:0];
            token = [[e attributes] objectForKey:@"value"];
            if(![token length]) {
                completionHandler(NO, @"Problem with TLC");
                return;
            }
            
            NSString *cookieHeader = response.allHeaderFields[@"Set-Cookie"];
            NSArray *cookies = [cookieHeader componentsSeparatedByString:@";"];
            NSString *sessionID = nil;
            
            for(NSString *cookieAssignment in cookies) {
                if([cookieAssignment hasPrefix:@"JSESSIONID"]) {
                    sessionID = [cookieAssignment componentsSeparatedByString:@"="][1];
                }
            }
            
            if(!sessionID) {
                completionHandler(NO, @"Problem with TLC");
                return;
            }
            self.sessionIDCookie = sessionID;
            
            httpBody = [NSString stringWithFormat:@"pageAction=login&url_login_token=%@&login=%@&password=%@&client=DEFAULT&localeSelected=false&STATUS_MESSAGE_HIDDEN=&wbXpos=0&wbYpos=0", token, self.employee.employeeID, self.employee.password];
            
            request = [[NSMutableURLRequest alloc] initWithURL:TKLoginURL];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:[httpBody dataUsingEncoding:NSASCIIStringEncoding]];
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[httpBody length]] forHTTPHeaderField:@"Content-Length"];
            
            [request setHTTPShouldHandleCookies:NO];
            
            NSData *dd;
            [self _sendSynchronousRequest:request pageData:&dd response:NULL error:&error];
            
            if(error == nil && dd.length > 8000) {
                self.loggedIn = YES;
                
                completionHandler(YES, nil);
            } else {
                
                completionHandler(NO, @"Error logging in");
            }
        }
        @catch (NSException *e) {
            completionHandler(NO, @"Unknown error");
        }
    }];
}

- (void)logOut {
    self.sessionIDCookie = nil;
    self.loggedIn = NO;
}

- (void)fetchEmployeeInfo:(TKSessionResultHandler)completionHandler {
    if(!self.loggedIn) {
        [self logIn:^(BOOL success, NSString *error) {
            if(!success)
                completionHandler(NO);
            else {
                [self fetchEmployeeInfo:completionHandler];
            }
        }];
        
        return;
    }
    
    [self.queue addOperationWithBlock:^{
        NSError *error;
        NSData *data;
        
        @try {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:TKAvailabilityChangeURL];
            [request setHTTPShouldHandleCookies:NO];
            [request setValue:[NSString stringWithFormat:@"JSESSIONID=%@", self.sessionIDCookie] forHTTPHeaderField:@"Cookie"];
            
            [self _sendSynchronousRequest:request pageData:&data response:NULL error:&error];
            
            if(!data || error) {
                completionHandler(NO);
                return;
            }
            
            TFHpple *pageDoc = [[TFHpple alloc] initWithHTMLData:data];
            
            /////////////////////
            /// first/last name
            /////////////////////
            NSArray *labelCandidates = [pageDoc searchWithXPathQuery:@"//div[@name='Label46_Text']"];
            if(labelCandidates.count == 0) {
                completionHandler(NO);
                return;
            }
            NSString *fullNameRaw = [[labelCandidates[0] firstChild] content];
            NSString *lastName = [fullNameRaw substringToIndex:[fullNameRaw rangeOfString:@", "].location];
            NSString *firstName = [fullNameRaw substringFromIndex:[fullNameRaw rangeOfString:@", "].location + 2];
            self.employee.name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            
            ///////////////////////
            /// emp status (part time)
            ////////////////////
            NSArray *empTypeCandidates = [pageDoc searchWithXPathQuery:@"//div[@name='Label21_Text']"];
            NSString *empType = [[[empTypeCandidates[0] firstChild] content] capitalizedString];
            self.employee.employmentStatus = empType;
            
            //////////////////////
            // dept
            ///////////////////
            NSArray *deptCandidates = [pageDoc searchWithXPathQuery:@"//div[@name='Label16_Text']"];
            NSString *dept = [[deptCandidates[0] firstChild] content];
            self.employee.department = [TKDepartment departmentForIdentifier:dept];
            self.employee.store = [TKStore storeWithStoreNumber:self.employee.department.storeNumber];
            
            //        NSArray *mailCandidates = [pageDoc searchWithXPathQuery:@"//font[@class='txtRed']"];
            //        employee.unreadMailCount = [[[mailCandidates[0] firstChild] content] integerValue];
            //        NSLog(@"%d", employee.unreadMailCount);
            
            completionHandler(YES);
        }
        @catch (NSException *e) {
            completionHandler(NO);
        }
    }];
}

- (void)fetchShifts:(TKSessionResultHandler)completionHandler {
    if(!self.loggedIn) {
        [self logIn:^(BOOL success, NSString *e) {
            if(!success)
                completionHandler(NO);
            else {
                [self fetchShifts:completionHandler];
            }
        }];
        
        return;
    }
    
    [self.queue addOperationWithBlock:^{
        NSData  *pageData;
        TFHpple *pageDoc;
        NSError *error;
        
        @try {
            [self _sendSynchronousRequest:[NSMutableURLRequest requestWithURL:TKCalendarURL] pageData:&pageData response:NULL error:&error];
            if(!pageData || error != nil) {
                completionHandler(NO);
                return;
            }
            
            pageDoc = [[TFHpple alloc] initWithHTMLData:pageData];
            
            NSArray         *pastShiftBoxes;
            NSArray         *futureShiftBoxes;
            TFHppleElement  *todayShiftBox;
            
            pastShiftBoxes = [pageDoc searchWithXPathQuery:@"//td[@class='calendarCellRegularPast']"];
            futureShiftBoxes = [pageDoc searchWithXPathQuery:@"//td[@class='calendarCellRegularFuture']"];
            todayShiftBox = [pageDoc searchWithXPathQuery:@"//td[@class='calendarCellRegularCurrent']"][0];
            
            [_cachedShifts removeAllObjects];
            for(NSArray *boxArray in @[pastShiftBoxes, @[todayShiftBox], futureShiftBoxes]) {
                for(TFHppleElement *boxElement in boxArray) {
                    [self _addShiftForDayBoxElement:boxElement];
                }
            }
            
            completionHandler(_cachedShifts.count > 0);
        }
        @catch (NSException *e) {
            completionHandler(NO);
        }
    }];
}

- (void)fetchInfoForSessionEmployeeStore:(TKSessionResultHandler)completionHandler {
    if(!self.loggedIn) {
        [self logIn:^(BOOL success, NSString *e) {
            if(!success)
                completionHandler(NO);
        }];
    }
    
//    else {
//        if(self.employee.department) {
//            return;
//        }
//    }
    
    [self fetchEmployeeInfo:^(BOOL success) {
        if(!success)
            completionHandler(NO);
        else
            [self fetchInfoForStore:self.employee.store completion:completionHandler];
    }];
}

- (void)fetchInfoForStore:(TKStore *)store completion:(TKSessionResultHandler)completionHandler {
    if(store.storeNumber == -1) {
        completionHandler(NO);
        return;
    }
    
    NSLog(@"fetching bro");
    
    [self.queue addOperationWithBlock:^{
        NSData  *pageData;
        TFHpple *pageDoc;
        NSError *error;
        
        @try {
            [self _sendSynchronousRequest:[NSMutableURLRequest requestWithURL:TKStoreDetailURL(store.storeNumber)] pageData:&pageData response:NULL error:&error];
            if(!pageData || error != nil) {
                completionHandler(NO);
                return;
            }
            
            pageDoc = [[TFHpple alloc] initWithHTMLData:pageData];
            
            TFHppleElement *geoElement = [pageDoc searchWithXPathQuery:@"//p[@typeof='v:Address v:Work']"][0];
            NSArray *twoSections = [geoElement childrenWithTagName:@"strong"];
            
            NSMutableString *address = [NSMutableString string];
            NSString *firstPart = [[twoSections[0] firstChild] firstChild].content;
            [address appendString:firstPart];
            
            for(NSInteger i=0;i<3;++i) {
                [address appendFormat:@"%@%@", (i == 2 || i == 0 ? @" " : @""), [[twoSections[1] childrenWithTagName:@"span"][i] firstChild].content];
            }
            
            NSArray *hourBoxes = [pageDoc searchWithXPathQuery:@"//li[@typeof='gr:OpeningHoursSpecification']"];
            NSMutableArray *timePeriods = [NSMutableArray arrayWithCapacity:7];
            for(NSInteger i=0;i<7;++i) {
                NSArray *dayColumnComponents = [hourBoxes[i] childrenWithTagName:@"span"];
                
                TFHppleElement *openTimeSpan = dayColumnComponents[1];
                TFHppleElement *closeTimeSpan = dayColumnComponents[3];
                
                NSString *openTimeStr = openTimeSpan.firstChild.content;
                NSString *openAMPM = [openTimeSpan.children[1] firstChild].content;
                
                NSString *closeTimeStr = closeTimeSpan.firstChild.content;
                NSString *closeAMPM = [closeTimeSpan.children[1] firstChild].content;
                
                openAMPM = [[openAMPM uppercaseString] stringByAppendingString:@"M"];
                closeAMPM = [[closeAMPM uppercaseString] stringByAppendingString:@"M"];
                
                NSString *timeRangeStr = [NSString stringWithFormat:@"%@%@-%@%@", openTimeStr, openAMPM, closeTimeStr, closeAMPM];
                
                
                
                NSDate *startDate;
                NSDate *endDate;
                
                [self calculateStartDate:&startDate endDate:&endDate fromDayOfMonth:1 timeString:timeRangeStr];
                [timePeriods addObject:[TKTimePeriod timePeriodFromDate:startDate toDate:endDate]];
            }
            store.openHoursTimePeriods = [timePeriods copy];
            
            store.address = [address copy];
            completionHandler(YES);
        }
        @catch (NSException *e) {
            completionHandler(NO);
        }
    }];
}

- (NSArray *)shifts {
    return [_cachedShifts copy];
}

- (void)calculateStartDate:(NSDate **)startDate
                   endDate:(NSDate **)endDate
            fromDayOfMonth:(NSInteger)dayOM
                timeString:(NSString *)timeString {
    //    NSLog(@"timeString=%@ dayOM=%d", timeString, dayOM);
    NSArray *startAndEndStrings = [timeString componentsSeparatedByString:@"-"];
    
    NSArray *startComponents = [startAndEndStrings[0] componentsSeparatedByString:@":"];
    //    NSLog(@"startComponents=%@", startComponents);
    NSInteger startHour = [startComponents[0] integerValue];
    NSInteger startMinutes = [[startComponents[1] substringToIndex:2] integerValue];
    
    NSArray *endComponents = [startAndEndStrings[1] componentsSeparatedByString:@":"];
    //    NSLog(@"endComponents=%@", endComponents);
    NSInteger endHour = [endComponents[0] integerValue];
    NSInteger endMinutes = [[endComponents[1] substringToIndex:2] integerValue];
    
    // 24 hour
    if([startAndEndStrings[0] rangeOfString:@"PM"].length > 0 && startHour < 12)
        startHour += 12;
    if([startAndEndStrings[1] rangeOfString:@"PM"].length > 0 && endHour < 12)
        endHour += 12;
    
    //    NSLog(@"day %d from={%02d:%02d}, to={%02d:%02d}", dayOM, startHour, startMinutes, endHour, endMinutes);
    
    NSDate *_startDate = [self _dateFromThisMonthDay:dayOM hour:startHour minutes:startMinutes];
    NSDate *_endDate = [self _dateFromThisMonthDay:dayOM hour:endHour minutes:endMinutes];
    
    *startDate = _startDate;
    *endDate = _endDate;
}

- (void)_addShiftForDayBoxElement:(TFHppleElement *)box {
    ////////////////////////////////
    // get day box elements first
    ////////////////////////////////
    @try {
        TFHppleElement *textSpan = [[[[box childrenWithTagName:@"table"][0] childrenWithTagName:@"tr"][0] childrenWithTagName:@"td"][1] childrenWithTagName:@"span"][0];
        NSArray *kids = [textSpan childrenWithTagName:@"span"];
        if(kids.count > 0) {
            textSpan = kids[0];
        }
        NSMutableArray *shiftAndDept = [NSMutableArray arrayWithCapacity:0];
        NSArray *textElements = [textSpan children];
        for(TFHppleElement *element in textElements) {
            NSString *content = [[[[element content] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            BOOL isImportant = [content rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].length > 0;
            if(content != nil && [content length] > 0 && isImportant)
                [shiftAndDept addObject:[content copy]];
        }
        
#define INDEX_SHIFT         0
#define INDEX_DEPARTMENT    1
        
        if([shiftAndDept[INDEX_SHIFT] isEqualToString:@"OFF"])
            return;
        
        NSDate *startDate;
        NSDate *endDate;
        
        NSString *dayOfMonth = [[[[[[box childrenWithTagName:@"table"][0] childrenWithTagName:@"tr"][0] childrenWithTagName:@"td"][0] childrenWithTagName:@"span"][0] firstChild] content];
        NSInteger dayOM = [dayOfMonth integerValue];
        
        [self calculateStartDate:&startDate endDate:&endDate fromDayOfMonth:dayOM timeString:shiftAndDept[INDEX_SHIFT]];
        
        [_cachedShifts addObject:[TKShift shiftFromDate:startDate toDate:endDate inDepartment:[TKDepartment departmentForIdentifier:shiftAndDept[INDEX_DEPARTMENT]]]];
    }
    @catch (NSException *e) {
        return;
    }
}

- (void)_sendSynchronousRequest:(NSMutableURLRequest *)request pageData:(NSData **)pageData response:(NSHTTPURLResponse **)response error:(NSError **)error {
    [request setHTTPShouldHandleCookies:NO];
    if(self.sessionIDCookie)
        [request setValue:[NSString stringWithFormat:@"JSESSIONID=%@", self.sessionIDCookie] forHTTPHeaderField:@"Cookie"];

    *pageData = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
}

- (NSDate *)_dateFromThisMonthDay:(NSInteger)day hour:(NSInteger)hour minutes:(NSInteger)min {
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComp = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:date];
    
    [todayComp setDay:day];
    [todayComp setHour:hour];
    [todayComp setMinute:min];
    
    NSDate *d = [gregorian dateFromComponents:todayComp];
    
    return d;
}

@end
