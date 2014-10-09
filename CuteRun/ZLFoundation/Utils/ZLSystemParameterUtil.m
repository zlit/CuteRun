//
//  ZLSystemParameterUtil.m
//  CuteRun
//
//  Created by LiZhaolei on 14-10-8.
//  Copyright (c) 2014年 com.zhaoleili.cuterun. All rights reserved.
//

#import "ZLSystemParameterUtil.h"

@implementation ZLSystemParameterUtil

+(CGSize)getTitleBarSizeWith:(UINavigationBar *) navigationBar
{
    float navigationBarHeight = 44;
    if(navigationBar != nil){
        navigationBarHeight = navigationBar.frame.size.height;
    }
    float titleBarWidth = zl_statusBarWidth;
    float titleBarHeight = zl_statusBarHeight + navigationBarHeight;
    return CGSizeMake(titleBarWidth, titleBarHeight);
}

+(CGPoint)getMiddlePositionWithViewSize:(CGSize) viewSize
                             targetSize:(CGSize) targetSize
{
    float orginX = (targetSize.width - viewSize.width)/2.0;
    float orginY = (targetSize.height - viewSize.height)/2.0;
    return CGPointMake(ceilf(orginX) , ceilf(orginY));
}

@end
