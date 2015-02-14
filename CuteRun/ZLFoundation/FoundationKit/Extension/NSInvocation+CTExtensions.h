//
//  NSInvocation+CTExtensions.h
//  CTFoundation
//
//  Created by Haoran Chen on 2/8/14.
//  Copyright (c) 2014 Ctrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (CTExtensions)

/**
 *  创建NSInvocation
 *
 *  @param target   目标对象
 *  @param selector 目标Selector
 *
 *  @return 创建的NSInvocation
 */
+ (NSInvocation *)zl_invocationWithTarget:(id)target
							  selector:(SEL)selector;

@end
