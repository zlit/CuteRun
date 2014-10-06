//
//  ZLStepsCountDataModel.h
//  CuteRun
//
//  Created by LiZhaolei on 14-10-5.
//  Copyright (c) 2014年 com.zhaoleili.cuterun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLStepsCountDataModel : NSObject

@property(nonatomic,assign) int timeInterval;//时间
@property(nonatomic,assign) int stepsCount;//步数
@property(nonatomic,assign) int meterDistance;//距离,单位米
@property(nonatomic,assign) float speedPerHour;//时速
@property(nonatomic,assign) int kcal;//燃烧大卡

#warning 还缺少省市,日期

@end
