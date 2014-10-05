//
//  UIView+CTExtensions.m
//  CTFoundation
//
//  Created by NickJackson on 14-1-21.
//  Copyright (c) 2014年 Ctrip. All rights reserved.
//

#import "UIView+CTExtensions.h"

@implementation UIView (CTExtensions)

#pragma mark - 视图属性接口
- (CGFloat)zl_originX
{
    return self.frame.origin.x;
}

- (void)zl_setOriginX:(CGFloat)originX
{
    CGRect originFrame = self.frame;
    originFrame.origin.x = originX;
    
    self.frame = originFrame;
}

- (CGFloat)zl_originY
{
    return self.frame.origin.y;
}

- (void)zl_setOriginY:(CGFloat)originY
{
    CGRect originFrame = self.frame;
    originFrame.origin.y = originY;
    
    self.frame = originFrame;
}

- (CGFloat)zl_bottomX
{
    CGRect frame = self.frame;
    return frame.origin.x + frame.size.width;
}

- (void)zl_setBottomX:(CGFloat)bottomX
{
    CGRect frame = self.frame;
    frame.origin.x = bottomX-frame.size.width;
    self.frame = frame;
}

- (CGFloat)zl_bottomY
{
    CGRect frame = self.frame;
    return frame.origin.y + frame.size.height;
}

- (void)zl_setBottomY:(CGFloat)bottomY
{
    CGRect frame = self.frame;
    frame.origin.y = bottomY-frame.size.height;
    self.frame = frame;
}

- (CGFloat)zl_width
{
    return self.frame.size.width;
}

- (void)zl_setWidth:(CGFloat)width
{
    CGRect originFrame = self.frame;
    originFrame.size.width = width;
    
    self.frame = originFrame;
}

- (CGFloat)zl_height
{
    return self.frame.size.height;
}

- (void)zl_setHeight:(CGFloat)height
{
    CGRect originFrame = self.frame;
    originFrame.size.height = height;
    
    self.frame = originFrame;
}
#pragma mark - 坐标点转换
- (CGPoint)zl_convertPointToWindow:(CGPoint)point
{
    return [self convertPoint:point toView:[[[UIApplication sharedApplication] delegate] window]];
}

- (CGPoint)zl_convertPointFromWindow:(CGPoint)point
{
    return [self convertPoint:point fromView:[[[UIApplication sharedApplication] delegate] window]];
}

#pragma mark - 创建视图
+ (UIView *)zl_createViewWithFrame:(CGRect)frame
{
    return [UIView zl_createViewWithFrame:frame backgroundColor:[UIColor clearColor]];
}

+ (UIView *)zl_createViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color
{
    UIView *result = [[UIView alloc] init];
    
    [result setFrame:frame];
    [result setBackgroundColor:color];
    
    return result;
}

+ (UIView *)zl_createViewWithXibName:(NSString *)xibName owner:(id)owner
{
    UIView *result = nil;
    
    if (xibName.length > 0) {
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:xibName owner:owner options:nil];
        if (viewArray.count > 0) {
            result = [viewArray objectAtIndex:0];
        }
    }
    return result;
}
#pragma mark - 删除视图
- (void)zl_removeAllSubviews
{
    NSArray *subViewArray = self.subviews;
    [subViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
#pragma mark - 移动动画
- (void)zl_moveToCenterPoint:(CGPoint)point duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion
{
    if (duration) {
        [UIView animateWithDuration:duration animations:^{
            [self setCenter:point];
        } completion:^(BOOL finished) {
            completion(finished);
        }];
    }
    else
    {
        [self setCenter:point];
        completion(YES);
    }
}
- (void)zl_moveToOriginPoint:(CGPoint)point duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion
{
    CGRect frame = self.frame;
    
    if (duration) {
        [UIView animateWithDuration:duration animations:^{
            [self setFrame:CGRectMake(point.x, point.y, frame.size.width, frame.size.height)];
        } completion:^(BOOL finished) {
            completion(finished);
        }];
    }
    else
    {
        [self setFrame:frame];
        completion(YES);
    }
}
- (void)zl_moveWithOffsetPoint:(CGPoint)offsetPoint duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion
{
    CGPoint centerPoint = self.center;
    
    if (duration) {
        [UIView animateWithDuration:duration animations:^{
            [self setCenter:CGPointMake(centerPoint.x+offsetPoint.x, centerPoint.y+offsetPoint.y)];
        } completion:^(BOOL finished) {
            completion(finished);
        }];
    }
    else
    {
        [self setCenter:CGPointMake(centerPoint.x+offsetPoint.x, centerPoint.y+offsetPoint.y)];
        completion(YES);
    }
}


@end
