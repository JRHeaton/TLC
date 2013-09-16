//
//  TKDepartment.m
//  tlcfetch
//
//  Created by John Heaton on 6/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "TKDepartment.h"

@interface TKDepartment ()
@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *identifier;
@property (nonatomic, readwrite) NSInteger storeNumber;
@end

@implementation TKDepartment

static NSDictionary *_TKDepartmentMap;
static NSMutableDictionary *_TKDepartmentCache;

+ (void)load {
#define D(code, name) [NSString stringWithFormat:@"%d", (code)] : name
    _TKDepartmentMap = 
    @{
        D(61405, @"Front of Precinct"),
        D(61100, @"Home & Mobile Entertainment"),
        D(50800, @"Back of Precinct"),
        D(51600, @"GSI"),
        D(51700, @"Double Agent"),
        D(60020, @"Management"),
        D(60025, @"Sales Support Leaders"),
        D(60030, @"Admin"),
        D(60040, @"Gaming"),
        D(60050, @"Merch"),
        D(60060, @"Sales Support"),
        D(60080, @"Asset Protection"),
        D(61101, @"Lifestyles"),
        D(61410, @"Multi-Channel"),
        D(61420, @"Appliances"),
        D(61430, @"Computers"),
        D(61435, @"Home Leaders"),
        D(61450, @"Mobile Electronics"),
        D(61460, @"Mobile"),
        D(61470, @"Home Theater"),
        D(61480, @"Portable Electronics"),
        D(61530, @"Tablets"),
        D(61540, @"Connectivity Leaders")
    };
#undef D
    _TKDepartmentCache = [NSMutableDictionary dictionaryWithCapacity:0];
}

+ (TKDepartment *)departmentForIdentifier:(NSString *)identifier {
    TKDepartment *d;
    
    identifier = [identifier stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n\r"]];
    
    if(!(d = _TKDepartmentCache[identifier])) {
        d = [[self alloc] init];
        
    // sample identifier input: L-000286-DEPT50700
        NSArray *identifierComponents = [identifier componentsSeparatedByString:@"-"];
        
        d.storeNumber = [identifierComponents[1] integerValue];
        d.identifier = identifier;
        
        NSString *deptCodeString = [identifierComponents[2] substringFromIndex:[identifierComponents[2] rangeOfString:@"DEPT"].length];

        d.name = _TKDepartmentMap[deptCodeString];

        if(!d.name)
            d.name = @"Unknown";
        
        _TKDepartmentCache[identifier] = d;
    }
    
    return d;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ name=\"%@\", storeNumber=%li identifier=\"%@\"", [super description], self.name, ((long)self.storeNumber), self.identifier];
}

@end