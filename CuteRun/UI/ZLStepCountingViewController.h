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

@class MDRadialProgressView;

@interface ZLStepCountingViewController : ZLViewController <ZLPlayPauseViewDelegate,ZLAccelerometerManagerDelegate> {
    MDRadialProgressView *radialView;
}
@property (strong, nonatomic) IBOutlet UILabel *labelStepsCount;
@property (strong, nonatomic) IBOutlet UILabel *labelHistoryStepsCount;
@property (strong, nonatomic) IBOutlet UILabel *labelTimeInterval;
@property (strong, nonatomic) IBOutlet UILabel *labelDistance;
@property (strong, nonatomic) IBOutlet UILabel *labelSpeed;
@property (strong, nonatomic) IBOutlet UILabel *labelCal;

@end
