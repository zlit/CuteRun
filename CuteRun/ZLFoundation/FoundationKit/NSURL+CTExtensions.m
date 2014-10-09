//
//  NSURL+CTExtensions.m
//  CTFoundation
//
//  Created by jimzhao on 14-1-23.
//  Copyright (c) 2014年 Ctrip. All rights reserved.
//

#import "NSURL+CTExtensions.h"
#import "NSString+CTExtensions.h"

@implementation NSURL(CTExtensions)

#pragma  mark - ----

+ (NSDictionary *)zl_parameterDictionary:(NSString *)urlString {
    if (urlString.length == 0) {
        return nil;
    }
    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionary];
    
    NSRange range = [urlString rangeOfString:@"?"];
    if (range.length > 0)
    {
//        NSString *hostString = [urlString substringToIndex:range.location];
//        [resultDictionary setValue:hostString forKey:@"host"];
        
        NSString *firstLevelInfo = [urlString substringFromIndex:range.location+1];
        if (firstLevelInfo.length > 0)
        {
            NSArray *secondLevelArray = [firstLevelInfo componentsSeparatedByString:@"&"];
            for (int j = 0; j < secondLevelArray.count; j++)
            {
                NSString *secondLevelInfo = [secondLevelArray objectAtIndex:j];
                NSRange secondRange = [secondLevelInfo rangeOfString:@"="];
                if (secondRange.location != NSNotFound)
                {
                    NSString *key = [secondLevelInfo substringToIndex:secondRange.location];
                    key = [key zl_URLDecode];
                    key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString *value = [secondLevelInfo substringFromIndex:secondRange.location + 1];
                    value = [value zl_URLDecode];
                    [resultDictionary setValue:value forKey:key];
                }
            }
        }
    }
    
    return resultDictionary;
}

@end
