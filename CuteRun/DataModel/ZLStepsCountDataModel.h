//
//  ZLStepsCountDataModel.h
//  CuteRun
//
//  Created by LiZhaolei on 14-10-5.
//  Copyright (c) 2014年 com.zhaoleili.cuterun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ZLBaseModel.h"

@interface ZLStepsCountDataModel : ZLBaseModel

@property(nonatomic,assign) int timeInterval;//时间
@property(nonatomic,assign) int stepsCount;//步数
@property(nonatomic,assign) int meterDistance;//距离,单位米
@property(nonatomic,assign) float speedPerHour;//时速
@property(nonatomic,assign) float kcal;//燃烧大卡
@property(nonatomic,copy) NSString *provinceName;//省
@property(nonatomic,copy) NSString *cityName;//市
@property(nonatomic,strong) NSDate *date;//日期
@property(nonatomic,assign) int stepsCountPurpose;//当日目标

+(ZLStepsCountDataModel *)getTodayStepsCountDataModel;
+(void)writeStepsCountDataModel:(ZLStepsCountDataModel *) stepsCountDataModel;

@end
