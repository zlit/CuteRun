//
//  ZLAccelerometerManager.h
//  CuteRun
//
//  Created by LiZhaolei on 14-10-5.
//  Copyright (c) 2014年 com.zhaoleili.cuterun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZLAccelerometerManagerDelegate <NSObject>

@required
-(void)stepsCountChanged:(int) stepsCount;

@end

@interface ZLAccelerometerManager : NSObject

@property(nonatomic,weak) id<ZLAccelerometerManagerDelegate> delegate;

@property(nonatomic,assign) int stepsCount;

+ (ZLAccelerometerManager *)sharedAccelerometerManager;
-(void)addAccelerometer;
-(void)removeAccelerometer;
@end
