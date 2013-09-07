//
//  NSObject+APAutoBlocking.m
//  APFramework
//
//  Created by Andrei on 9/6/13.
//  Copyright (c) 2013 Andrei. All rights reserved.
//

#import "NSObject+APAutoBlocking.h"
#import "NSObject+LSDirectCodeManipulation.h"
#import <NSArray+APUtils.h>

@implementation NSObject (APAutoBlocking)

- (NSMutableDictionary *)bindings {
    NSMutableDictionary *bindings = 
        [NSMutableDictionary dictionaryWithObjects:
            [self.propertie5 map:^id(id key) {
                return @{
                         @"key" : key,
                         @"value" :
                             [self performSelector:NSSelectorFromString(key)]
                         ?: [NSNull null]
                };
            }]
                                           forKeys:self.propertie5];
    return bindings;
}

@end
