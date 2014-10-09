//
//  NSInvocation+CTExtensions.m
//  CTFoundation
//
//  Created by Haoran Chen on 2/8/14.
//  Copyright (c) 2014 Ctrip. All rights reserved.
//

#import "NSInvocation+CTExtensions.h"

@implementation NSInvocation (CTExtensions)

+ (NSInvocation *)zl_invocationWithTarget:(id)target
                                 selector:(SEL)selector
{
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:selector];
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
	[invocation setTarget:target];
	[invocation setSelector:selector];
	
	return invocation;
}

@end
