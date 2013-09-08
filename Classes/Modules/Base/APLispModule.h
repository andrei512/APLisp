//
//  APLispModule.h
//  DevAPLisp
//
//  Created by Andrei on 9/8/13.
//  Copyright (c) 2013 Andrei Puni. All rights reserved.
//

#import "NSObject+APLisp.h"

#define fun(name) extern Block name;

#define Module APLispModule

#define gdefun(name, block)                     \
Block name = ^{                                 \
    raiseUnloadedFuntionException(@ #name);     \
};                                              \
                                                \
Block _##name() {                               \
    name = function(@ #name, block);            \
    return name;                                \
}                                               \
                                                \
@implementation Module(Function##name)          \
                                                \
- (void)_loadFunction##name {                   \
    _##name();                                  \
}                                               \
                                                \
@end

fun(foo)

extern void raiseUnloadedFuntionException(NSString *functionName);

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
