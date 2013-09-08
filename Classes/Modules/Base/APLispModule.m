//
//  APLispModule.m
//  DevAPLisp
//
//  Created by Andrei on 9/8/13.
//  Copyright (c) 2013 Andrei Puni. All rights reserved.
//

#import "APLispModule.h"
#import <objc/runtime.h>

void raiseUnloadedFuntionException(NSString *functionName) {
    [[NSException exceptionWithName:@"Use of uninitialized function"
                             reason:[NSString stringWithFormat:@"Function %@ not loaded",
                                     functionName]
                           userInfo:nil] raise];
}

gdefun(foo, ^{
    NSLog(@"context = %@", conteXt);
})

@implementation APLispModule

+ (NSMutableDictionary *)modules {
    static NSMutableDictionary *modules = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        modules = [NSMutableDictionary dictionary];
    });
    return modules;
}

+ (instancetype)module {
    NSString *className = NSStringFromClass([self class]);
    NSMutableDictionary *modules = [self modules];
    if (modules[className] == nil) {
        modules[className] = [self new];
    }
    return modules[className];
}

- (id)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
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
            [self performSelector:name];
        }
    }
}

- (void)loadFunctionsMatching:(NSString *)pattern {
    
}

- (Block)lazyLoadFunction:(NSString *)name {
    return Nothing;
}


@end

