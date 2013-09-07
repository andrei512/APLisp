//
//  APLispModule.h
//  DevAPLisp
//
//  Created by Andrei on 9/8/13.
//  Copyright (c) 2013 Andrei Puni. All rights reserved.
//

#import "NSObject+APLisp.h"

#define module_function(module, function_name) [module lazyLoadFunction:@#function_name]

#define MODULE_PREFIX Core

#define funi(name) extern Block MODULE_PREFIX##name;
#define gdefun(name, block)                             \
static Block MODULE_PREFIX##name = nil;                 \
Block _##MODULE_PREFIX##name() {                        \
    if (MODULE_PREFIX##name == nil) {                   \
        MODULE_PREFIX##name = function(@"name", block); \
    }                                                   \
    return MODULE_PREFIX##name;                         \
}

//funi(foo)

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
