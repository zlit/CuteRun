//
//  ZLStepCountingViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "ZLStepCountingViewController.h"
#import "MDRadialProgressView.h"
#import "ZLUserInfoDataModel.h"
#import "ZLStepsCountDataModel.h"
#import "FileUtil.h"
#import "ZLUserRegistView.h"
#import "ZLSystemParameterUtil.h"

@interface ZLStepCountingViewController ()

@property(nonatomic,strong) NSTimer *timeIntervalTimer;
@property(nonatomic,strong) NSTimer *writeStepsCountDataTimer;
@property(nonatomic,strong) ZLUserInfoDataModel *userInfoDataModel;
@property(nonatomic,strong) ZLStepsCountDataModel *stepsCountDataModel;

@end

@implementation ZLStepCountingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBaseData];
    [self setUpNavigation];
    [self addRadialView];
    [self addPlayPauseView];
    [self setLocationManager];
    [self setUpAccelerometerManager];
    [self moveDownSubViews:[self.view subviews]];//因为navigationBar加了背景,所有背景的view的起始高度移到了nav之下
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSMutableArray *array = [NSMutableArray array];
    for (UIView *subView in [self.view subviews]) {
        if(subView != radialView && subView != playPauseView){
            [array addObject:subView];
        }
    }
    
    [self moveDownSubViews:array];
}

-(void)initBaseData
{
    if([FileUtil isExistsFilePath:[FileUtil dataFilePath:kUserInfoPath]]){
        self.userInfoDataModel = [ZLUserInfoDataModel getUserInfoDataModel];
    }
    self.stepsCountDataModel = [ZLStepsCountDataModel getTodayStepsCountDataModel];
    [self updateLabelStepsCount:self.stepsCountDataModel.stepsCount];
    [self updateLabelDistance:self.stepsCountDataModel.meterDistance];
    [self updateLabelTimeInterval:self.stepsCountDataModel.timeInterval];
    [self updateLabelSpeedWithDisance:self.stepsCountDataModel.meterDistance
                         timeInterval:self.stepsCountDataModel.timeInterval];
    [self updateLabelLocationInfoWithProvinceName:self.stepsCountDataModel.provinceName
                                         cityName:self.stepsCountDataModel.cityName];
}

-(void)setUpNavigation
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"TopNavigationMenuicon"]
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(presentLeftMenuViewController:)];
    
    UIImage* myImage = [UIImage imageNamed:@"TitleImage"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:myImage];
    [self.navigationController.navigationBar.topItem setTitleView:imgView];
    CGSize titleBarSize = [ZLSystemParameterUtil getTitleBarSizeWith:self.navigationController.navigationBar];
    ZLNaviBackgroundView *view = [[ZLNaviBackgroundView alloc] initWithFrame:CGRectMake(0, 0, titleBarSize.width, titleBarSize.height)];
    UIImage *image = [view imageFromSelf];
    [self.navigationController.navigationBar setBackgroundImage:image forBarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//    {
//        [self.navigationController.navigationBar setBarTintColor:[UIColor zl_getColorWithRed:37
//                                                                                       green:156
//                                                                                        blue:208
//                                                                                       alpha:1]];
//    }else{
//        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
//                                                      forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setBackgroundColor:[UIColor zl_getColorWithRed:37
//                                                                                          green:156
//                                                                                           blue:208
//                                                                                          alpha:1]];
//    }
    
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    float navigationBarWidth = [UIApplication sharedApplication].statusBarFrame.size.width;
//    float navigationBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
//    gradient.frame = CGRectMake(0, 0, navigationBarWidth, navigationBarHeight);
//    gradient.colors = [NSArray arrayWithObjects:
//                       (id)[UIColor colorWithRed:0.254 green:0.599 blue:0.82 alpha:1.0].CGColor,
//                       (id)[UIColor colorWithRed:0.192 green:0.525 blue:0.75 alpha:1.0].CGColor,
//                       (id)[UIColor colorWithRed:0.096 green:0.415 blue:0.686 alpha:1.0].CGColor,
//                       nil];
//    gradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:1.0],nil];
//    gradient.startPoint = gradient.frame.origin;
//    gradient.endPoint = CGPointMake(gradient.frame.origin.x, gradient.frame.origin.y+gradient.frame.size.height);
//    [self.navigationController.navigationBar.layer insertSublayer:gradient atIndex:0];
//    [[[self.navigationController.navigationBar.layer sublayers] objectAtIndex:0] insertSublayer:gradient atIndex:0];
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, 100)];
//    [view.layer insertSublayer:gradient atIndex:0];
//    [self.view addSubview:view];
}

- (UIImage *)getGradientImageWithRect:(CGRect) rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    CGFloat locations[] = {0.0, 0.5, 1.0};
    CGFloat colorComponents[] = {
        0.254, 0.599, 0.82, 1.0, //red, green, blue, alpha
        0.192, 0.525, 0.75, 1.0,
        0.096, 0.415, 0.686, 1.0
    };
    size_t count = 3;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colorComponents, locations, count);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClipToRect(context, rect);
    CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint endPoint = CGPointMake(rect.origin.x , rect.origin.y + rect.size.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
     // Grab it as an autoreleased image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    // Clean up
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    UIGraphicsEndImageContext();
    return image;
}

-(void)addRadialView
{
    CGRect frame = CGRectMake(60, 190, 200, 200);
    radialView = [[MDRadialProgressView alloc] initWithFrame:frame];
    radialView.center = CGPointMake(self.view.center.x, radialView.center.y);
    
    radialView.progressTotal = 100;
    radialView.progressCounter = [self getProgressCounterWithSteps:self.stepsCountDataModel.stepsCount];
    radialView.startingSlice = 1;
    radialView.theme.sliceDividerHidden = NO;
    radialView.theme.sliceDividerThickness = 1;
    radialView.label.textColor = [UIColor blueColor];
    radialView.label.shadowColor = [UIColor clearColor];
    
    [self.view addSubview:radialView];
}

-(void)addPlayPauseView
{
    playPauseView = [[ZLPlayPauseView alloc] initWithFrame:CGRectMake(270, 150, 40, 40)
                                                     color:[UIColor zl_getColorWithRed:37
                                                                                 green:156
                                                                                  blue:208
                                                                                 alpha:0.9]];
    playPauseView.delegate = self;
    [self.view addSubview:playPauseView];
}

-(int)getProgressCounterWithSteps:(int) steps
{
    int progressCounter = (int)(steps/6000*100);
    if(progressCounter > 100){
        progressCounter = 100;
    }
    return progressCounter;
}

-(void)setLocationManager
{
    [ZLLocationManager sharedLocationManager].delegate = self;
}

-(void)setUpAccelerometerManager
{
    [ZLAccelerometerManager sharedAccelerometerManager].stepsCount = 0;
    [ZLAccelerometerManager sharedAccelerometerManager].delegate = self;
}

-(void)startTimer
{
    [self stopTimer];
    self.timeIntervalTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshTimeInterval) userInfo:nil repeats:YES];
    self.writeStepsCountDataTimer = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(writeStepsCountData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];
}

-(void)refreshTimeInterval
{
    self.stepsCountDataModel.timeInterval += 1;
    dispatch_async(dispatch_get_main_queue(),^{
        [self updateLabelTimeInterval:self.stepsCountDataModel.timeInterval];
    });
}

-(void)writeStepsCountData
{
    [ZLStepsCountDataModel writeStepsCountDataModel:self.stepsCountDataModel];
}

-(NSString *)getTimeStr:(int) timeInt
{
    NSString* timeStr = @"";
    if(timeInt < 10){
        timeStr = [NSString stringWithFormat:@"0%d",timeInt];
    }else{
        timeStr = [NSString stringWithFormat:@"%d",timeInt];
    }
    return timeStr;
}

-(void)stopTimer
{
    if (self.timeIntervalTimer) {
        [self.timeIntervalTimer invalidate];
        self.timeIntervalTimer = nil;
    }
    
    if(self.writeStepsCountDataTimer){
        [self.writeStepsCountDataTimer invalidate];
        self.writeStepsCountDataTimer = nil;
    }
}

#pragma mark ---------- Update Labels ----------
-(void)updateLabelDistance:(CLLocationDistance)distance
{
    self.stepsCountDataModel.meterDistance = distance;
    NSString *totalDistanceStr = [NSString stringWithFormat:@"%.2lf",distance/1000];
    self.labelDistance.text = totalDistanceStr;
}

-(void)updateLabelSpeedWithDisance:(CLLocationDistance)distance
                      timeInterval:(NSTimeInterval) timeInterval
{
    float speed = distance / timeInterval * 3.6;
    self.stepsCountDataModel.speedPerHour = speed;
    NSString *speedStr = [NSString stringWithFormat:@"%.2lf",speed];
    if([speedStr isEqual:self.labelSpeed] == NO){
        self.labelSpeed.text = speedStr;
    }
}

-(void)updateLabelTimeInterval:(int) timeInterval
{
    self.stepsCountDataModel.timeInterval = timeInterval;
    int hour = timeInterval/3600;
    int minute = (timeInterval%3600)/60;
    int second = timeInterval%60;
    self.labelTimeInterval.text = [NSString stringWithFormat:@"%@:%@:%@",[self getTimeStr:hour],[self getTimeStr:minute],[self getTimeStr:second]];
}

-(void)updateLabelLocationInfoWithProvinceName:(NSString *) provinceName
                                      cityName:(NSString *) cityName
{
    if(provinceName.length > 0 && cityName.length > 0){
        self.labelLocationInfo.text = [NSString stringWithFormat:@"%@ . %@",provinceName,cityName];
    }
}

-(void)updateLabelStepsCount:(int) stepsCount
{
    self.labelStepsCount.text = [NSString stringWithFormat:@"%d",stepsCount];
}

#pragma mark ---------- ZLPlayPauseViewDelegate ----------
-(void)playStateChanged:(BOOL) isPlay
{
    if (isPlay) {
        [[ZLAccelerometerManager sharedAccelerometerManager] addAccelerometer];
        [[ZLLocationManager sharedLocationManager] startLocationUpdates];
        [self performSelectorInBackground:@selector(startTimer) withObject:nil];
    }else{
        [[ZLAccelerometerManager sharedAccelerometerManager] removeAccelerometer];
        [[ZLLocationManager sharedLocationManager] stopLocationUpdates];
        [self stopTimer];
        [self writeStepsCountData];
    }
}

#pragma mark ---------- ZLAccelerometerManagerDelegate ----------
-(void)stepsCountChanged:(int) stepsCount
{
    self.stepsCountDataModel.stepsCount = stepsCount;
    [self updateLabelStepsCount:stepsCount];
    radialView.progressCounter = [self getProgressCounterWithSteps:self.stepsCountDataModel.stepsCount];
}

#pragma mark ---------- PSLocationManagerDelegate ----------

- (void)locationManager:(ZLLocationManager *)locationManager signalStrengthChanged:(ZLLocationManagerGPSSignalStrength)signalStrength {
//    NSString *strengthText;
//    if (signalStrength == ZLLocationManagerGPSSignalStrengthWeak) {
//        strengthText = NSLocalizedString(@"Weak", @"");
//    } else if (signalStrength == ZLLocationManagerGPSSignalStrengthStrong) {
//        strengthText = NSLocalizedString(@"Strong", @"");
//    } else {
//        strengthText = NSLocalizedString(@"...", @"");
//    }
//    
//    self.strengthLabel.text = strengthText;
}

- (void)locationManagerSignalConsistentlyWeak:(ZLLocationManager *)locationManager {
//    self.strengthLabel.text = NSLocalizedString(@"Consistently Weak", @"");
}

- (void)locationManager:(ZLLocationManager *)locationManager
               waypoint:(CLLocation *)waypoint calculatedSpeed:(CLLocationSpeed)calculatedSpeed
{

}

- (void)locationManager:(ZLLocationManager *)locationManager
        distanceUpdated:(CLLocationDistance)distance {
    [self updateLabelDistance:distance];
    [self updateLabelSpeedWithDisance:distance
                         timeInterval:self.stepsCountDataModel.timeInterval];
}

- (void)locationManager:(ZLLocationManager *)locationManager error:(NSError *)error {

}

//省份,城市回调
- (void)locationManager:(ZLLocationManager *)locationManager
           provinceName:(NSString *) provinceName
               cityName:(NSString *) cityName
{
    self.stepsCountDataModel.provinceName = provinceName;
    self.stepsCountDataModel.cityName = cityName;
    [self updateLabelLocationInfoWithProvinceName:provinceName cityName:cityName];
}

@end
