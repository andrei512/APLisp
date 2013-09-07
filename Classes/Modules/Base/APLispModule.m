//
//  APLispModule.m
//  DevAPLisp
//
//  Created by Andrei on 9/8/13.
//  Copyright (c) 2013 Andrei Puni. All rights reserved.
//

#import "APLispModule.h"

gdefun(foo, ^{
    NSLog(@"foo");
})

@implementation APLispModule

- (void)setup {
//    do(foo);
}

@end
