//
//  ZLUserInfoDataModel.m
//  CuteRun
//
//  Created by LiZhaolei on 14-10-7.
//  Copyright (c) 2014年 com.zhaoleili.cuterun. All rights reserved.
//

#import "ZLUserInfoDataModel.h"



@implementation ZLUserInfoDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gender = ZLGenderTypeMale;
        self.height = 170.0;
        self.weight = 60.0;
    }
    return self;
}

-(NSString *)getBMIDescription
{
    float bmi = self.weight / (self.height/100 * self.height/100);
    float thinStandard = 18.5;//self.gender == ZLGenderTypeMale?20:18.5;
    NSString *BMIDescription = @"";
    if(bmi<thinStandard){
        //                偏瘦
        BMIDescription = @"轻体重";
    }else if(bmi >= thinStandard && bmi <= 23){
        //                正常
        BMIDescription = @"健康体重";
    }else if(bmi > 23 && bmi <= 28){
        //                偏胖
        BMIDescription = @"超重";
    }else if(bmi > 28){
        //                严重肥胖
        BMIDescription = @"肥胖";
    }
    return [NSString stringWithFormat:@"%.1lf    %@",bmi,BMIDescription];
}

-(NSString *)getHealthWeightDescription
{
    float thinStandard = 18.5;//self.gender == ZLGenderTypeMale?20:18.5;
    int healthWeightLow = (int)(thinStandard * (self.height/100 * self.height/100));
    int healthWeightHight = (int)(23 * (self.height/100 * self.height/100));
    return [NSString stringWithFormat:@"%d~%d KG(1KG=2斤)",healthWeightLow,healthWeightHight];
}

-(NSString *)getStandardWeightDescription
{
    float standardWeightBMI = 20.5;
    int standardWeight = (int)(standardWeightBMI * (self.height/100 * self.height/100));
    return [NSString stringWithFormat:@"%d KG(1KG=2斤)",standardWeight];
}


@end
