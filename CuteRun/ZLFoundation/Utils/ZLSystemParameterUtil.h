//
//  ZLSystemParameterUtil.h
//  CuteRun
//
//  Created by LiZhaolei on 14-10-8.
//  Copyright (c) 2014年 com.zhaoleili.cuterun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



#define zl_statusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define zl_statusBarWidth [UIApplication sharedApplication].statusBarFrame.size.width

#define zl_screenHeight [[UIScreen mainScreen] bounds].size.height
#define zl_screenWidth [[UIScreen mainScreen] bounds].size.width

#define zl_fontSysteSize(value)      [UIFont systemFontOfSize:value]     //系统字体
#define zl_fontBoldSysteSize(value)  [UIFont boldSystemFontOfSize:value] //系统字体，粗体

@interface ZLSystemParameterUtil : NSObject

+(CGSize)getTitleBarSizeWith:(UINavigationBar *) navigationBar;

+(CGPoint)getMiddlePositionWithViewSize:(CGSize) viewSize
                             targetSize:(CGSize) targetSize;


@end
