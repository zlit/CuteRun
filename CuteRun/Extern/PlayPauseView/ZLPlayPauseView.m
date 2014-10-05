//
//  ZLPlayPauseView.m
//  CuteRun
//
//  Created by LiZhaolei on 14-10-4.
//  Copyright (c) 2014年 com.zhaoleili.cuterun. All rights reserved.
//

#import "ZLPlayPauseView.h"
#import "UIColor+CTExtensions.h"
#import <math.h>

@implementation ZLPlayPauseView

- (ZLPlayPauseView *)initWithFrame:(CGRect)frame
                             color:(UIColor *)color
{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.bgColor = color;
        self.isPlay = YES;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
        tapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //设置背景颜色
    [[UIColor whiteColor] set];
    UIRectFill([self bounds]);
    //拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);//标记
    // Drawing code
    if(self.isPlay){
        CGPoint sPoints[3];//坐标点
        sPoints[0] =CGPointMake(0, 0);//坐标1
        sPoints[1] =CGPointMake(0, rect.size.height);//坐标2
        sPoints[2] =CGPointMake([self getThirdPointWithLength:rect.size.height], rect.size.height/2.0);//坐标3
        CGContextAddLines(context, sPoints, 3);//添加线
        CGContextClosePath(context);//封起来
        [self.bgColor setFill]; //设置填充色
        [self.bgColor setStroke]; //设置边框颜色
        CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    }else{
        [self drawRectWithContext:context
                       totalWidth:rect.size.width
                 beginCoefficient:1
                   endCoefficient:2];
        
        [self drawRectWithContext:context
                       totalWidth:rect.size.width
                 beginCoefficient:3
                   endCoefficient:4];
    }
}

//获得播放按钮的右顶点
-(float)getThirdPointWithLength:(float) length
{
    float thirdPoint = sqrt(length*length - (length/2.0)*(length/2.0));
    return thirdPoint;
}

-(void)drawRectWithContext:(CGContextRef) context
                totalWidth:(float) totalWidth
          beginCoefficient:(int) beginCoefficient
            endCoefficient:(int) endCoefficient
{
    CGPoint sPoints[4];//坐标点
    int width = (int)(totalWidth/6.0);//暂停按钮其中一个矩形的宽度
    sPoints[0] =CGPointMake(width * beginCoefficient , 1);//坐标1
    sPoints[1] =CGPointMake(width * beginCoefficient , totalWidth-1);//坐标2
    sPoints[2] =CGPointMake(width * endCoefficient, totalWidth-1);//坐标3
    sPoints[3] =CGPointMake(width * endCoefficient, 1);//坐标4
    CGContextAddLines(context, sPoints, 4);//添加线
    CGContextClosePath(context);//封起来
    [self.bgColor setFill]; //设置填充色
    [self.bgColor setStroke]; //设置边框颜色
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
}

#pragma mark -
#pragma mark Pan gesture recognizer (Private)
- (void)tapGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded){
        self.isPlay = !self.isPlay;
        [self setNeedsDisplay];
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(playStateChanged:)]){
            [self.delegate playStateChanged:self.isPlay];
        }
    }
}

@end
