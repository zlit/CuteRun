//
//  NSNotificationCenter+CTExtensions.h
//  CTFoundation
//
//  Created by Haoran Chen on 2/8/14.
//  Copyright (c) 2014 Ctrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (CTExtensions)

/**
 *  在主线程发送通知对象
 *
 *  @param aNote 通知对象
 */
- (void)zl_postNotificationOnMainThread:(NSNotification *)aNote;

/**
 *  在主线程发送通知（带通知名称和对象）
 *
 *  @param aName    通知名称
 *  @param anObject 通知对象
 */
- (void)zl_postNotificationOnMainThreadWithName:(NSString *)aName object:(id)anObject;

/**
 *  在主线程发送通知（带通知名称、对象和额外信息）
 *
 *  @param aName     通知名称
 *  @param anObject  通知对象
 *  @param aUserInfo 通知额外信息
 */
- (void)zl_postNotificationOnMainThreadWithName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;


@end
