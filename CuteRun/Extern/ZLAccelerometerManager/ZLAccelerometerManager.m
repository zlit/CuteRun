//
//  ZLAccelerometerManager.m
//  CuteRun
//
//  Created by LiZhaolei on 14-10-5.
//  Copyright (c) 2014年 com.zhaoleili.cuterun. All rights reserved.
//

#import "ZLAccelerometerManager.h"
#import <CoreMotion/CoreMotion.h>
#import "AppDelegate.h"

#define kLengthHight 1.048
#define kLengthLow 0.948
#define kPreStepsCountMax 8

@interface ZLAccelerometerManager(){
    int stepsArray[3];
}

@property(nonatomic,strong) CMMotionManager *accelerometerManager;
@property(nonatomic,assign) double timeStamp;
@property(nonatomic,assign) int preStepsCount;

@end

@implementation ZLAccelerometerManager

+ (ZLAccelerometerManager *)sharedAccelerometerManager {
    static dispatch_once_t pred;
    static ZLAccelerometerManager *accelerometerManager = nil;
    
    dispatch_once(&pred, ^{
        accelerometerManager = [[self alloc] init];
    });
    return accelerometerManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.accelerometerManager = [[CMMotionManager alloc] init];
        self.timeStamp = 0.0;
        self.preStepsCount = 0;
        self.stepsCount = 0;
        [self resetStepsArray];
    }
    return self;
}

-(void)addAccelerometer
{
    [self.accelerometerManager setAccelerometerUpdateInterval:0.1];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    __weak ZLAccelerometerManager *weakSelf = self;
    [self.accelerometerManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *data, NSError *error)
     {
         double x = data.acceleration.x;
         double y = data.acceleration.y;
         double z = data.acceleration.z;
         double length = sqrt(pow(x,2) + pow(y,2) + pow(z,2));
         
         if((length > kLengthHight || length < kLengthLow)){
             while ([weakSelf isStepBeginWithLenght:length]
                    && [weakSelf isStepContinueWithLenght:length]) {
                 //doNothing
                 break;
             }
             
             if (stepsArray[0] == 1 && stepsArray[1] == 1
                 && [weakSelf isSetpValid]) {
                 self.timeStamp = [weakSelf getTimeIntervalSince1970];
                 if(self.preStepsCount < kPreStepsCountMax){
                     self.preStepsCount++;
                     if(self.preStepsCount == kPreStepsCountMax){
                         self.stepsCount += self.preStepsCount;
                     }
                     return;
                 }else{
                     self.stepsCount++;
                     dispatch_async(dispatch_get_main_queue(),^{
                         if(self.delegate != nil && [self.delegate respondsToSelector:@selector(stepsCountChanged:)]){
                             [self.delegate stepsCountChanged:self.stepsCount];
                         }
                     });
                 }
             }
         }
     }];
}

-(BOOL)isStepBeginWithLenght:(double) length
{
    BOOL isStepBegin = NO;
    if(stepsArray[0] == 1){
        isStepBegin = YES;
    }else if(length < kLengthLow){
        stepsArray[0] = 1;
    }
    return isStepBegin;
}

-(BOOL)isStepContinueWithLenght:(double) length
{
    BOOL isStepContinue = NO;
    if(stepsArray[1] == 1){
        isStepContinue = YES;
    }else if(length > kLengthHight){
        stepsArray[1] = 1;
    }
    return isStepContinue;
}

-(void)resetStepsArray
{
    stepsArray[0] = 0;
    stepsArray[1] = 0;
    stepsArray[2] = 0;
}

-(BOOL)isSetpValid
{
    [self resetStepsArray];
    BOOL isSetpValid = YES;
    
    double currentTimeInterval = [self getTimeIntervalSince1970];
    if(self.timeStamp == 0){
        isSetpValid = YES;
    }
    else if(currentTimeInterval - self.timeStamp < 300){//两次计步在200毫秒以内,不计数
        isSetpValid = NO;
    }
    else if(currentTimeInterval - self.timeStamp > 2000){//两次计步在2秒之外,判断计歩停止
        isSetpValid = NO;
        self.preStepsCount = 0;//预计歩归0
        self.timeStamp = 0;//时间戳归0
    }
    
    return isSetpValid;
}

-(double)getTimeIntervalSince1970
{
    return [NSDate timeIntervalSinceReferenceDate]*1000;
}

-(void)removeAccelerometer
{
    [self.accelerometerManager stopAccelerometerUpdates];
}

@end
