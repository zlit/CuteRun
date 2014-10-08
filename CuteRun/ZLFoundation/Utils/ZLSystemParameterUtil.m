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
    float titleBarWidth = [UIApplication sharedApplication].statusBarFrame.size.width;
    float titleBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height + navigationBarHeight;
    return CGSizeMake(titleBarWidth, titleBarHeight);
}

@end
