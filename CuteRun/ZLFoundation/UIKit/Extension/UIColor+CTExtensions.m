//
//  UIColor+CTExtensions.m
//  CTFoundation
//
//  Created by NickJackson on 14-1-27.
//  Copyright (c) 2014年 Ctrip. All rights reserved.
//

#import "UIColor+CTExtensions.h"

@implementation UIColor (CTExtensions)

+(UIColor *)zl_getColorWithRed:(float) red
                         green:(float) green
                          blue:(float) blue
                         alpha:(float) alpha
{
    UIColor *color = [UIColor colorWithRed:(red)/255.0f green:(green)/255.0f blue:(blue)/255.0f alpha:alpha];
    return color;
}


@end
