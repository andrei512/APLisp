//
//  NSObject+APLisp.m
//  APFramework
//
//  Created by Andrei on 9/5/13.
//  Copyright (c) 2013 Andrei. All rights reserved.
//

#import "NSObject+APLisp.h"
#import <NSString+APUtils.h>

@implementation NSObject (APLisp)

+ (NSMutableArray *)stackForCurrentThread {
    NSThread *thread = [NSThread currentThread];
    NSMutableDictionary *dict = [thread threadDictionary];
    if (dict[@"thisStack"] == nil) {
        NSMutableDictionary *rootContextForThread = [NSMutableDictionary dictionary];
        dict[@"thisStack"] = [NSMutableArray arrayWithObject:rootContextForThread];
    }
    return dict[@"thisStack"];
}

+ (NSMutableDictionary *)_context {
    return [[NSObject stackForCurrentThread] lastObject];
}

- (void)pushContext {
    [[NSObject stackForCurrentThread] addObject:[NSMutableDictionary dictionary]];
}

- (void)pushContext:(NSMutableDictionary *)context {
    [[NSObject stackForCurrentThread] addObject:context];
}


- (void)popContext {
    [[NSObject stackForCurrentThread] removeLastObject];
}

- (void)performBlock:(id)block {
    [self performBlock:block with:nil];
}

- (void)performBlock:(id)block withParam:(id)_param {
    [self performBlock:block with:@[_param]];
}

- (void)performBlock:(id)block with:(NSArray *)_params {
    // push a empty context to the stack
    [self performBlock:block withParams:_params andContext:[NSMutableDictionary dictionary]];
}

- (void)performBlock:(id)block withParams:(NSArray *)_params andContext:(NSMutableDictionary *)context {
    @try {
        ThisBlock thisBlock = (ThisBlock)block;
        if (thisBlock != nil) {
            [self pushContext:context];
            
            this = self;
            params = _params ?: @[];
            param = (_params != nil && _params.count > 0) ? _params[0] : nsnull;
            [NSObject _ret:self];
            
            thisBlock();
            [self popContext];
        }

    }
    @catch (NSException *exception) {
        [[NSException exceptionWithName:@"Throw stack"
                                reason:@"block chrashed"
                              userInfo:@{}] raise];
    }
}


- (void)performBlockwithParams:(NSArray *)_params
                    andContext:(NSMutableDictionary *)context
                      andBlock:(id)block
                  onContextKey:(NSString *)key {
}

- (void)performBlockWithParams:(NSArray *)_params
                         block:(id)block {
    [self performBlock:block with:_params];
}

#pragma mark - Regex invoke

- (void)performBlockwithParams:(NSArray *)_params
                    andContext:(NSMutableDictionary *)context
                  onContextKey:(NSString *)key
                         block:(id)block {
    for (NSString *contextKey in [[context allKeys] copy]) {
        if ([contextKey matches:key]) {
            [context[contextKey] performBlock:block withParams:_params andContext:context];
        }
    }
}

- (void)performBlockwithParams:(NSArray *)_params
                  onContextKey:(NSString *)key
                         block:(id)block {
    // THIS ONE !!!
    [self performBlockwithParams:_params
                      andContext:self.bindings
                    onContextKey:key
                           block:block];
}



+ (void)_ret:(id)a_result {
    NSMutableArray *stack = [NSObject stackForCurrentThread];
    int level = stack.count;
    if (level > 1) {
        NSMutableDictionary *superContext = stack[level - 2];
        superContext[@"lastResult"] = a_result;
    }
}



@end
