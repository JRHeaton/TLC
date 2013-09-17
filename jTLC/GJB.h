//
//  GJB.h
//  jTLC
//
//  Created by John Heaton on 9/15/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#ifndef GJB_H
#define GJB_H

// Flags
#ifdef GJB_DEBUG
#define GJB_DEBUG_PRINT 1
#else
#define GJB_DEBUG_PRINT 0
#endif

#ifdef __OBJC__

#if GJB_DEBUG_PRINT
#define JRLog(args...) NSLog(args)
#else
#define JRLog(args...)
#endif

#define PROP_COPY           @property (nonatomic, copy)
#define PROP_STRONG         @property (nonatomic, strong)
#define PROP_RDONLY         @property (nonatomic, readonly)
#define PROP_RDONLY_COPY    @property (nonatomic, readonly, copy)
#define PROP_ASSIGN         @property (nonatomic, assign)

#define MA()            { return [NSMutableArray array];            }
#define MD()            { return [NSMutableDictionary dictionary];  }
#define MS()            { return [NSMutableString string];          }
#define FSTR(args...)   { return [NSString stringWithFormat:args];  }

#define UINav(controller) { \
    return [[UINavigationController alloc] initWithRootViewController:(controller)]; \
}
#define UIApp [UIApplication sharedApplication]
#define defaults() { return [NSUserDefaults standardUserDefaults]; }

#endif


#endif /* GJB_H */
