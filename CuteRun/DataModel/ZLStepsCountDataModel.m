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
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%d$%d$%d$%f$%f$%@$%@$%lf",
            self.timeInterval,
            self.stepsCount,
            self.meterDistance,
            self.speedPerHour,
            self.kcal,
            self.provinceName,
            self.cityName,
            [self.date timeIntervalSinceReferenceDate]];
}

+(NSDateFormatter *)getStepsCountDataFileName
{
    NSString *format = @"yyyyMMdd";
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:format];
    return dateFormater;
}

+(ZLStepsCountDataModel *)getTodayStepsCountDataModel
{
    ZLStepsCountDataModel *todayStepsCountDataModel = [[ZLStepsCountDataModel alloc] init];
    NSString *fileName = [[self getStepsCountDataFileName] stringFromDate:[NSDate date]];
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
        todayStepsCountDataModel.timeInterval = [((NSString *)[splitArray objectAtIndex:0]) intValue];
        todayStepsCountDataModel.stepsCount = [((NSString *)[splitArray objectAtIndex:1]) intValue];
        todayStepsCountDataModel.meterDistance = [((NSString *)[splitArray objectAtIndex:2]) intValue];
        todayStepsCountDataModel.speedPerHour = [((NSString *)[splitArray objectAtIndex:3]) floatValue];
        todayStepsCountDataModel.kcal = [((NSString *)[splitArray objectAtIndex:4]) floatValue];
        todayStepsCountDataModel.provinceName = (NSString *)[splitArray objectAtIndex:5];
        todayStepsCountDataModel.cityName = (NSString *)[splitArray objectAtIndex:6];
        double dateTimeInterval = [((NSString *)[splitArray objectAtIndex:7]) doubleValue];;
        todayStepsCountDataModel.date = [NSDate dateWithTimeIntervalSinceReferenceDate:dateTimeInterval];
    }
    
    return todayStepsCountDataModel;
}

+(void)writeStepsCountDataModel:(ZLStepsCountDataModel *) stepsCountDataModel
{
    NSString *fileName = [[self getStepsCountDataFileName] stringFromDate:[NSDate date]];
    NSString *content = [stepsCountDataModel description];
    
    @synchronized(self)
    {
        [FileUtil writeContent:content filePath:[FileUtil dataFilePath:fileName]];
    }
}

@end
