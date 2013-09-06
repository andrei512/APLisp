//
//  NSObject+LSDirectCodeManipulation.m
//  kollector
//
//  Created by Andrei on 9/6/13.
//  Copyright (c) 2013 Andrei. All rights reserved.
//

#import "NSObject+LSDirectCodeManipulation.h"
#import <MARTNSObject.h>
#import <RTProperty.h>

@implementation NSObject (LSDirectCodeManipulation)

- (NSArray *)propertie5 {
    NSMutableArray *properties = [NSMutableArray array];
    
    Class class = self.rt_class;
    do {
        for (RTProperty *property in class.rt_properties) {
            if ([self respondsToSelector:NSSelectorFromString([property name])]) {
                [properties addObject:[property name]];
            }
        }
        class = [class superclass];
    } while ([class superclass]);
    
    properties = [properties filter:^BOOL(id object) {
        if ([self respondsToSelector:NSSelectorFromString(object)] == YES) {
            return YES;
        }
        return NO;
    }];
    
    return properties;
}

@end
