//
//  APLispCore.m
//  DevAPLisp
//
//  Created by Andrei on 9/8/13.
//  Copyright (c) 2013 Andrei Puni. All rights reserved.
//

#import "APLispCore.h"

gdefun(range, ^{
    if (params.count < 2) {
        ret(@[])
    } else {
        NSMutableArray *result = [NSMutableArray array];
        
        int begin = argAs(0, NSNumber).intValue;
        int end = argAs(1, NSNumber).intValue;
        int step = 1;
        if (params.count > 2) {
            namedArgAs(object, 2, NSObject)
            if ([object isKindOfClass:[NSNumber class]]) {
                step = argAs(2, NSNumber).intValue;
            }
        }
        
        for (int i = begin; i < end; i += step) {
            [result addObject:@(i)];
        }
        
        ret(result)
    }
})

@implementation APLispCore

@end
