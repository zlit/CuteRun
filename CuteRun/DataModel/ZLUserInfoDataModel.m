//
//  ZLUserInfoDataModel.m
//  CuteRun
//
//  Created by LiZhaolei on 14-10-7.
//  Copyright (c) 2014年 com.zhaoleili.cuterun. All rights reserved.
//

#import "ZLUserInfoDataModel.h"
#import "FileUtil.h"


@implementation ZLUserInfoDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gender = ZLGenderTypeMale;
        self.height = 170.0;
        self.weight = 60.0;
        self.stepsCountPurpose = 5000;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%d$%f$%f$%d",
            self.gender,
            self.height,
            self.weight,
            self.stepsCountPurpose];
}

+(ZLUserInfoDataModel *)getUserInfoDataModel
{
    ZLUserInfoDataModel *userInfoDataModel = [[ZLUserInfoDataModel alloc] init];
    NSString *filePath = [FileUtil dataFilePath:kUserInfoPath];
    if([FileUtil isExistsFilePath:filePath]){
        NSString *content = [FileUtil readWithContentsOfFile:filePath];
        userInfoDataModel = [self initUserInfoDataModelWithContent:content];
    }
    return userInfoDataModel;
}

+(ZLUserInfoDataModel *)initUserInfoDataModelWithContent:(NSString *) content
{
    ZLUserInfoDataModel *userInfoDataModel = [[ZLUserInfoDataModel alloc] init];
    NSArray *splitArray = [content componentsSeparatedByString:@"$"];
    if([splitArray count] > 0){
        userInfoDataModel.gender = [((NSString *)[splitArray zl_objectAtIndex:0]) intValue];
        userInfoDataModel.height = [NSDecimalNumber decimalNumberWithString:(NSString *)[splitArray zl_objectAtIndex:1]].floatValue;
        userInfoDataModel.weight = [NSDecimalNumber decimalNumberWithString:(NSString *)[splitArray zl_objectAtIndex:2]].floatValue;
        userInfoDataModel.stepsCountPurpose = [((NSString *)[splitArray zl_objectAtIndex:3]) floatValue];
    }
    
    return userInfoDataModel;
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

+(void)writeUserInfoDataModel:(ZLUserInfoDataModel *) userInfoDataModel
{
    NSString *content = [userInfoDataModel description];
    
    @synchronized(self)
    {
        [FileUtil writeContent:content filePath:[FileUtil dataFilePath:kUserInfoPath]];
    }
}

@end
