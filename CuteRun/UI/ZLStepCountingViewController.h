//
//  ZLStepCountingViewController.h
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLViewController.h"
#import "ZLPlayPauseView.h"
#import "ZLAccelerometerManager.h"
#import "ZLNaviBackgroundView.h"
#import "ZLLocationManager.h"

@class MDRadialProgressView;

@interface ZLStepCountingViewController : ZLViewController <ZLPlayPauseViewDelegate,ZLAccelerometerManagerDelegate,ZLLocationManagerDelegate> {
    MDRadialProgressView *radialView;
    ZLPlayPauseView *playPauseView;
}

@property (strong, nonatomic) IBOutlet UILabel *labelStepsCount;
@property (strong, nonatomic) IBOutlet UILabel *labelHistoryStepsCount;
@property (strong, nonatomic) IBOutlet UILabel *labelTimeInterval;
@property (strong, nonatomic) IBOutlet UILabel *labelDistance;
@property (strong, nonatomic) IBOutlet UILabel *labelSpeed;
@property (strong, nonatomic) IBOutlet UILabel *labelCal;
@property (strong, nonatomic) IBOutlet UIView *viewStepsCount;
@property (strong, nonatomic) IBOutlet UILabel *labelLocationInfo;

@end
