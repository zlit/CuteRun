//
//  NSNotificationCenter+CTExtensions.m
//  CTFoundation
//
//  Created by Haoran Chen on 2/8/14.
//  Copyright (c) 2014 Ctrip. All rights reserved.
//

#import "NSNotificationCenter+CTExtensions.h"

@implementation NSNotificationCenter (CTExtensions)

- (void)zl_postNotificationOnMainThread:(NSNotification *)aNote
{
	[self performSelectorOnMainThread:@selector(postNotification:) withObject:aNote waitUntilDone:YES];
}

- (void)zl_postNotificationOnMainThreadWithName:(NSString *)aName object:(id)anObject
{
	NSNotification *note = [NSNotification notificationWithName:aName object:anObject];
	[self zl_postNotificationOnMainThread:note];
}

- (void)zl_postNotificationOnMainThreadWithName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo
{
	NSNotification *note = [NSNotification notificationWithName:aName object:anObject userInfo:aUserInfo];
	[self zl_postNotificationOnMainThread:note];
}


@end
