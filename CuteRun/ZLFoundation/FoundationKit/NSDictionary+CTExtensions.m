//
//  NSDictionary+CTExtensions.m
//  CTUtility
//
//  Created by jimzhao on 13-12-11.
//  Copyright (c) 2013年 jimzhao. All rights reserved.
//  类文件说明

#import "NSDictionary+CTExtensions.h"
#import "NSString+CTExtensions.h"

@implementation NSMutableDictionary(Safe)

- (void)zl_setObject:(id)anObject forKey:(id)aKey {
    if ([aKey conformsToProtocol:@protocol(NSCopying)]) {
        if (anObject == NULL) {
            [self removeObjectForKey:aKey];
        }
        else {
            [self setObject:anObject forKey:aKey];
        }
    }
}

@end