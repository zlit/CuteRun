//
//  NSURL+CTExtensions.h
//  CTFoundation
//
//  Created by jimzhao on 14-1-23.
//  Copyright (c) 2014年 Ctrip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL(CTExtensions)

/**
 *  将URL字符串转化成key/value形式的dictionary
 *
 *  @param urlString 需要转换的url字符串
 *
 *  @return url转换成的map
 */

+ (NSDictionary *)zl_parameterDictionary:(NSString *)urlString;

@end
