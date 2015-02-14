//
//  ZLStepsCountDataModel.m
//  CuteRun
//
//  Created by LiZhaolei on 14-10-5.
//  Copyright (c) 2014年 com.zhaoleili.cuterun. All rights reserved.
//

#import "ZLStepsCountDataModel.h"
#import "FileUtil.h"

@implementation ZLStepsCountDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timeInterval = 0;
        self.stepsCount = 0;
        self.meterDistance = 0;
        self.speedPerHour = 0.0;
        self.kcal = 0.0;
        self.provinceName = @"";
        self.cityName = @"";
        self.date = [NSDate date];
        self.stepsCountPurpose = 0;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%d$%d$%d$%f$%f$%@$%@$%lf$%d",
            self.timeInterval,
            self.stepsCount,
            self.meterDistance,
            self.speedPerHour,
            self.kcal,
            self.provinceName,
            self.cityName,
            [self.date timeIntervalSinceReferenceDate],
            self.stepsCountPurpose];
}

+(NSDateFormatter *)getDateFormater
{
    NSString *format = @"yyyyMMdd";
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:format];
    return dateFormater;
}

+(ZLStepsCountDataModel *)getTodayStepsCountDataModel
{
    ZLStepsCountDataModel *todayStepsCountDataModel = [[ZLStepsCountDataModel alloc] init];
    NSString *fileName = [[self getDateFormater] stringFromDate:[NSDate date]];
    NSString *filePath = [FileUtil dataFilePath:fileName];
    if([FileUtil isExistsFilePath:filePath]){
        NSString *content = [FileUtil readWithContentsOfFile:filePath];
        todayStepsCountDataModel = [self initStepsCountDataModelWithContent:content];
    }
    return todayStepsCountDataModel;
}

+(ZLStepsCountDataModel *)initStepsCountDataModelWithContent:(NSString *) content
{
    ZLStepsCountDataModel *todayStepsCountDataModel = [[ZLStepsCountDataModel alloc] init];
    NSArray *splitArray = [content componentsSeparatedByString:@"$"];
    if([splitArray count] > 0){
        todayStepsCountDataModel.timeInterval = [((NSString *)[splitArray zl_objectAtIndex:0]) intValue];
        todayStepsCountDataModel.stepsCount = [((NSString *)[splitArray zl_objectAtIndex:1]) intValue];
        todayStepsCountDataModel.meterDistance = [((NSString *)[splitArray zl_objectAtIndex:2]) intValue];
        todayStepsCountDataModel.speedPerHour = [((NSString *)[splitArray zl_objectAtIndex:3]) floatValue];
        todayStepsCountDataModel.kcal = [((NSString *)[splitArray zl_objectAtIndex:4]) floatValue];
        todayStepsCountDataModel.provinceName = (NSString *)[splitArray zl_objectAtIndex:5];
        todayStepsCountDataModel.cityName = (NSString *)[splitArray zl_objectAtIndex:6];
        double dateTimeInterval = [((NSString *)[splitArray zl_objectAtIndex:7]) doubleValue];;
        todayStepsCountDataModel.date = [NSDate dateWithTimeIntervalSinceReferenceDate:dateTimeInterval];
        todayStepsCountDataModel.stepsCountPurpose = [((NSString *)[splitArray zl_objectAtIndex:8]) intValue];
    }
    
    return todayStepsCountDataModel;
}

+(void)writeStepsCountDataModel:(ZLStepsCountDataModel *) stepsCountDataModel
{
    NSString *fileName = [[self getDateFormater] stringFromDate:[NSDate date]];
    NSString *content = [stepsCountDataModel description];
    
    @synchronized(self)
    {
        [FileUtil writeContent:content filePath:[FileUtil dataFilePath:fileName]];
    }
}

@end
