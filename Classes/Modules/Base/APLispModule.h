//
//  APLispModule.h
//  DevAPLisp
//
//  Created by Andrei on 9/8/13.
//  Copyright (c) 2013 Andrei Puni. All rights reserved.
//

#import "NSObject+APLisp.h"

#define fun(name) extern Block MODULE_PREFIX##name;

#define gdefun(name, block)                     \
static Block name = nil;                        \
Block _##name() {                               \
    if (name == nil) {                          \
        name = function(@"name", block);        \
    }                                           \
    return name;                                \
}                                               \
@implementation APLispModule(name)              \
- (void)_loadFunction##name {                   \
    _##name();                                  \
}                                               \
@end


@interface APLispModule : NSObject

// creates the module and initialize
+ (instancetype)module;

// setup for the module
// you can use defun to add funtions to the global context when importing a module
- (void)setup;

// loads all functions
- (void)loadAllFunctions;

// loads 
- (void)loadFunctionsMatching:(NSString *)pattern;

// lazy loads a funtion
- (Block)lazyLoadFunction:(NSString *)name;


@end
