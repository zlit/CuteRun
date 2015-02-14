//
//  ZLUserInfoDataModel.h
//  CuteRun
//
//  Created by LiZhaolei on 14-10-7.
//  Copyright (c) 2014年 com.zhaoleili.cuterun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLBaseModel.h"

#define kUserInfoPath @"userInfo.txt"

typedef NS_ENUM(NSInteger, ZLGenderType) {
    ZLGenderTypeNone = 0,
    ZLGenderTypeMale,
    ZLGenderTypeFemale
};

@interface ZLUserInfoDataModel : ZLBaseModel

@property(nonatomic,assign) ZLGenderType gender;//性别
@property(nonatomic,assign) float height;//身高
@property(nonatomic,assign) float weight;//体重
@property(nonatomic,assign) int stepsCountPurpose;//当日目标

+(ZLUserInfoDataModel *)getUserInfoDataModel;
+(void)writeUserInfoDataModel:(ZLUserInfoDataModel *) userInfoDataModel;
-(NSString *)getBMIDescription;
-(NSString *)getHealthWeightDescription;
-(NSString *)getStandardWeightDescription;

@end
