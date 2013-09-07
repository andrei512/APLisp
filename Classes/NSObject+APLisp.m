//
//  NSObject+APLisp.m
//  APFramework
//
//  Created by Andrei on 9/5/13.
//  Copyright (c) 2013 Andrei. All rights reserved.
//

#import "NSObject+APLisp.h"
#import <NSString+APUtils.h>

void addFunctionToContext(Block function, NSString *name, NSMutableDictionary *context) {
    context[name] = function;
}

Block function(NSString *name, Block block) {
    return ^{
        block_name = name;
        
        block();
    };
}

NSString * prettyClass(Class class) {
    static NSDictionary *prettyMap = nil;
    if (prettyMap == nil) {
        defun(__sample, ^{})
        
        prettyMap = @{
            NSStringFromClass([@"Const" class]) : @"String",
            NSStringFromClass([NSString class]) : @"String",
            NSStringFromClass([^{} class]) : @"Block",
            NSStringFromClass([__sample class]) : @"Block",
            NSStringFromClass([NSObject class]) : @"Object",
            NSStringFromClass([@[] class]) : @"List",
            NSStringFromClass([NSArray class]) : @"List",
            NSStringFromClass([NSDictionary class]) : @"Hash",
            NSStringFromClass([NSMutableArray class]) : @"mList",
            NSStringFromClass([NSMutableDictionary class]) : @"mHash",
        };
    }
    
    NSString *className = NSStringFromClass(class);
    
    for (NSString *key in prettyMap) {
        if ([key isEqualToString:className]) {
            return prettyMap[key];
        }
    }
    
    return NSStringFromClass(class);
}

BOOL isBlock(id object) {
    return [prettyClass([object class]) isEqualToString:@"Block"];
}

NSObject * _do(NSArray *args) {
    // if the first arg is a block then implicitly set this to root
    if (args.count < 1 ||
        isBlock(args[0]) == YES) {
        return _do([@[Root] arrayByAddingObjectsFromArray:args]);
    } else {
        NSObject *_this = args[0];
        
        Block _action = Nothing;
        if (args.count >= 2 &&
            isBlock(args[1]) == YES) {
            _action = args[1];
        }
        
        NSArray *_params = @[];
        
        if (args.count > 2) {
            NSRange range = {2, args.count - 2};
            _params = [args subarrayWithRange:range];
        }

        [_this performBlockWithParams:_params
                                block:_action];
        
        return resu1t;
    }
}

NSObject * _yield(NSArray *args) {
    return _do([@[Root, callback] arrayByAddingObjectsFromArray:args]);
}

Block _Nothing() {
    static Block _nothing = nil;
    if (_nothing == nil) {
        _nothing = function(@"Nothing", ^{});
    }
    return _nothing;
}

////////////////////////////////////////////////////////////////////////////////

@implementation NSObject (APLisp)

+ (NSObject *)root {
    static NSObject *root = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        root = [NSObject new];
    });
    return root;
}

+ (NSMutableArray *)stackForCurrentThread {
    NSThread *thread = [NSThread currentThread];
    NSMutableDictionary *dict = [thread threadDictionary];
    if (dict[@"thisStack"] == nil) {
        // create the root context
        NSMutableDictionary *rootContextForThread = [NSMutableDictionary dictionary];
        rootContextForThread[@"name"] = @"Global Context";
        rootContextForThread[@"thread"] = thread;
        
        dict[@"thisStack"] = [NSMutableArray arrayWithObject:rootContextForThread];
    }
    return dict[@"thisStack"];
}

+ (NSMutableDictionary *)_context {
    return [[NSObject stackForCurrentThread] lastObject];
}

- (NSMutableDictionary *)createContext {
    NSMutableDictionary *context = [NSMutableDictionary dictionary];
//    context[@"globalContext"] = @"";
    return context;
}

- (void)pushContext {
    [[NSObject stackForCurrentThread] addObject:[self createContext]];
}

- (void)pushContext:(NSMutableDictionary *)context {
    [[NSObject stackForCurrentThread] addObject:context];
}


- (void)popContext {
    [[NSObject stackForCurrentThread] removeLastObject];
}

- (void)performBlock:(Block)block {
    [self performBlock:block with:nil];
}

- (void)performBlock:(Block)block
           inContext:(NSMutableDictionary *)context {
    [self performBlock:block withParams:@[] andContext:[NSMutableDictionary dictionary]];
}


- (void)performBlock:(Block)block withParam:(id)_param {
    [self performBlock:block with:@[_param]];
}

- (void)performBlock:(Block)block with:(NSArray *)_params {
    // push a empty context to the stack
    [self performBlock:block withParams:_params andContext:[NSMutableDictionary dictionary]];
}

- (void)performBlockwithParams:(NSArray *)_params
                    andContext:(NSMutableDictionary *)context
                      andBlock:(Block)block
                  onContextKey:(NSString *)key {
}

- (void)performBlockWithParams:(NSArray *)_params
                         block:(Block)block {
    [self performBlock:block with:_params];
}

#pragma mark - Block calling main !

- (void)performBlock:(Block)block withParams:(NSArray *)_params andContext:(NSMutableDictionary *)context {
    @try {
        if (block != nil) {
            [self pushContext:context];

            this = self;
            
            // Extract the callback from params
            if (_params.count > 0 &&
                isBlock([_params lastObject]) == YES) {
                callback = [_params lastObject];
                
                NSRange range = {0, _params.count - 1};
                _Params = [_params subarrayWithRange:range];
            } else {
                callback = Nothing;
            }

            // params is @[this] implicitly
            // param is this implicitly
            
            _Params = _params ?: @[this];
            param = (_params != nil && _params.count > 0) ? _params[0] : nsnull;
            
            // implicitly return this
            [NSObject _ret:this];
            
            block();
            
            [self popContext];
        }

    }
    @catch (NSException *exception) {
        [[NSException exceptionWithName:@"Throw stack"
                                reason:@"block chrashed"
                               userInfo:@{@"exception" : exception}] raise];
    }
}

#pragma mark - Magic

- (VaradicBlock)_do {
    return ^(NSArray *args) {
        return _do([@[self] arrayByAddingObjectsFromArray:args]);
    };
}

- (VaradicBlock)_yield {
    return ^(NSArray *args) {
        return _do([@[self, callback] arrayByAddingObjectsFromArray:args]);
    };
}

#pragma mark - Regex invoke

- (void)performBlockwithParams:(NSArray *)_params
                    andContext:(NSMutableDictionary *)context
                  onContextKey:(NSString *)key
                         block:(Block)block {
    for (NSString *contextKey in [[context allKeys] copy]) {
        if ([contextKey matches:key]) {
            [context[contextKey] performBlock:block withParams:_params andContext:context];
        }
    }
}

- (void)performBlockwithParams:(NSArray *)_params
                  onContextKey:(NSString *)key
                         block:(Block)block {
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










