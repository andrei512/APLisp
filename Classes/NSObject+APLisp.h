//
//  NSObject+APLisp.h
//  APFramework
//
//  Created by Andrei on 9/5/13.
//  Copyright (c) 2013 Andrei. All rights reserved.
//

#import <Foundation/Foundation.h>

// Modules

// AutoBlocking - binding and magik
#import "NSObject+LSDirectCodeManipulation.h"
#import "NSObject+APAutoBlocking.h"

// Core

#define conteXt [NSObject _context]

#define this conteXt[@"this"]
    #define as(Class) Class *object = (Class *)this;

#define params conteXt[@"params"]
#define param conteXt[@"param"]

#define do(block) [self performBlock:block];

#define resu1t conteXt[@"lastResult"]

#define ret(a_result) [NSObject _ret:a_result]; return;

#define y13ld(block) 

// Constants

#define nsnull [NSNull null]

// Helpers

#define r3 @"

#define g3x "

#define l00p()

// Debuging

#define nam3 conteXt[@"name"]

// Array

#define kollect(array, block) \
[array map:^id(id _object) { PO(conteXt) [_object performBlock:block]; PO(resu1t) return resu1t; }]



// Hash

typedef void(^ThisBlock)(void);

@interface NSObject (APLisp)

+ (NSMutableArray *)stackForCurrentThread;

+ (NSMutableDictionary *)_context;

+ (void)_ret:(id)a_result;
+ (void)_yield:(id)block;

- (void)performBlock:(id)block;

- (void)performBlock:(id)block
           inContext:(NSMutableDictionary *)context;

- (void)performBlock:(id)block
           withParam:(id)_param;

- (void)performBlock:(id)block
                with:(NSArray *)_params;

- (void)performBlockwithParams:(NSArray *)_params
                    andContext:(NSMutableDictionary *)context
                  onContextKey:(NSString *)key
                     block:(id)block;

- (void)performBlockwithParams:(NSArray *)_params
                  onContextKey:(NSString *)key
                         block:(id)block;


- (void)performBlockWithParams:(NSArray *)_params
                         block:(id)block;


@end
