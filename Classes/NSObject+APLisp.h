//
//  NSObject+APLisp.h
//  APFramework
//
//  Created by Andrei on 9/5/13.
//  Copyright (c) 2013 Andrei. All rights reserved.
//

#import <Foundation/Foundation.h>

// Types

typedef void(^Block)(void);
typedef NSObject *(^VaradicBlock)(NSArray *);
typedef BOOL (^ClassBlock)(Class);

// Modules

// AutoBlocking - binding and magik
#import "NSObject+LSDirectCodeManipulation.h"
#import "NSObject+APAutoBlocking.h"

// Core

#define conteXt [NSObject _context]

#define Root [NSObject root]

#define this ((NSObject *)conteXt[@"this"])
#define _This conteXt[@"this"]
#define params ((NSArray *)conteXt[@"params"]) // this is not assignable
#define _Params conteXt[@"params"]
#define param ((NSObject *)conteXt[@"param"]) // this is not assignable
#define _Param conteXt[@"param"]

#define resu1t conteXt[@"lastResult"]

#define callback conteXt[@"callback"]

#define ret(a_result) [NSObject _ret:a_result]; return;

// !!!!!!!!!!!!!!! first object is this
// DO(this, action, params, callback) -> result

#define do(...) _do(@[ __VA_ARGS__ ])
#define yield(...) _yield(@[ __VA_ARGS__ ])

#define defun(name, block)                        \
Block name = function(@#name, block);             \
addFunctionToContext(name, @#name, conteXt);

extern NSObject * _do(NSArray *args);
extern NSObject * _yield(NSArray *args);

extern void addFunctionToContext(Block function, NSString *name, NSMutableDictionary *context);
extern Block function(NSString *name, Block block);

extern NSString * contextString(NSString *format);

extern NSString * prettyClass(Class class);

extern BOOL isBlock(id object);
extern Block _Nothing();

// Constants

#define Nothing _Nothing()

#define nsnull [NSNull null]

// Helpers

#define is_a(Class) _is_a([Class class])

// Strong Types
#define as(Class) asWithName(Class, object)
#define asWithName(Class, name) Class *name = (Class *)param;

#define argAs(index, Class) ((Class *)(params[index]))
#define namedArgAs(name, index, Class) Class *name = ((Class *)(params[index]));


// Common
#define asIndex int i = ((NSNumber *)param).intValue;

#define asNumber asWithName(NSString, i)
#define asString asWithName(NSString, string)
#define asList asWithName(NSArray, list)
#define asHash asWithName(NSDictionary, hash)

#define asView asWithName(UIView, view)
#define asViewController asWithName(UIViewController, viewController)

// Debuging

#define function_name conteXt[@"name"]

// Array

#define kollect(array, block) [array map:^id(id _object) { [_object performBlock:block]; return resu1t; }]



// Hash





@interface NSObject (APLisp)

@property (nonatomic, readonly) VaradicBlock _do;
@property (nonatomic, readonly) ClassBlock _is_a;

// this is used for calling block without and explicit object
+ (NSObject *)root;

+ (NSMutableArray *)stackForCurrentThread;

+ (NSMutableDictionary *)_context;

+ (void)_ret:(id)a_result;

- (void)performBlock:(Block)block;

- (void)performBlock:(Block)block
           inContext:(NSMutableDictionary *)context;

- (void)performBlock:(Block)block
           withParam:(id)_param;

- (void)performBlock:(Block)block
                with:(NSArray *)_params;

- (void)performBlockwithParams:(NSArray *)_params
                    andContext:(NSMutableDictionary *)context
                  onContextKey:(NSString *)key
                     block:(Block)block;

- (void)performBlockwithParams:(NSArray *)_params
                  onContextKey:(NSString *)key
                         block:(Block)block;


- (void)performBlockWithParams:(NSArray *)_params
                         block:(Block)block;


@end
