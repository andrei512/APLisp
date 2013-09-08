//
//  APLispModule.m
//  DevAPLisp
//
//  Created by Andrei on 9/8/13.
//  Copyright (c) 2013 Andrei Puni. All rights reserved.
//

#import "APLispModule.h"
#import <objc/runtime.h>

gdefun(foo, ^{
    NSLog(@"foo");
})

@implementation APLispModule

+ (instancetype)module {
    return [self new];
}

- (void)setup {
    [self loadAllFunctions];    
}

- (void)loadAllFunctions {
    unsigned int count = 0;
    Method *methods = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; ++i) {
        SEL name = method_getName(methods[i]);
        NSString *methodName = NSStringFromSelector(name);
        if ([methodName hasPrefix:@"_loadFunction"]) {
            NSLog(@"%@", methodName);
        }
    }
}

- (void)loadFunctionsMatching:(NSString *)pattern {
    
}

- (Block)lazyLoadFunction:(NSString *)name {
    return Nothing;
}


@end
