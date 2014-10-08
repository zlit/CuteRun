//
//  ZLTestView.m
//  JXBarChartViewExample
//
//  Created by LiZhaolei on 14-10-6.
//  Copyright (c) 2014年 PS. All rights reserved.
//

#import "ZLNaviBackgroundView.h"

@implementation ZLNaviBackgroundView


- (void)drawRect:(CGRect)rect {
    CGFloat locations[] = {0.0, 0.5, 1.0};
    CGFloat colorComponents[] = {
        0.254, 0.599, 0.82, 1.0, //red, green, blue, alpha
        0.172, 0.505, 0.73, 1.0,
        0.126, 0.445, 0.716, 1.0
    };
    size_t count = 3;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colorComponents, locations, count);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClipToRect(context, rect);
    CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint endPoint = CGPointMake(rect.origin.x , rect.origin.y + rect.size.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
}

- (UIImage*)imageFromSelf{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, self.layer.contentsScale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
