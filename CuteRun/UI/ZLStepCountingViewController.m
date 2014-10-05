//
//  ZLStepCountingViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "ZLStepCountingViewController.h"
#import "MDRadialProgressView.h"

@interface ZLStepCountingViewController ()

@property(nonatomic,strong) NSTimer *timeIntervalTimer;

@end

@implementation ZLStepCountingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpNavigation];
    [self addRadialView];
    [self setUpAccelerometerManager];

    [self.view setBackgroundColor:[UIColor whiteColor]];
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
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        [self.navigationController.navigationBar setBarTintColor:[UIColor zl_getColorWithRed:213.0
                                                                                       green:37.0
                                                                                        blue:38.0
                                                                                       alpha:1]];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                                      forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBackgroundColor:[UIColor zl_getColorWithRed:213.0
                                                                                          green:37.0
                                                                                           blue:38.0
                                                                                          alpha:1]];
    }
}

-(void)addRadialView
{
    CGRect frame = CGRectMake(60, 190, 200, 200);
    radialView = [[MDRadialProgressView alloc] initWithFrame:frame];
    radialView.center = CGPointMake(self.view.center.x, radialView.center.y);
    
    radialView.progressTotal = 100;
    radialView.progressCounter = 0;
    radialView.startingSlice = 1;
    radialView.theme.sliceDividerHidden = NO;
    radialView.theme.sliceDividerThickness = 1;
    radialView.label.textColor = [UIColor blueColor];
    radialView.label.shadowColor = [UIColor clearColor];
    
    [self.view addSubview:radialView];
    
    ZLPlayPauseView *pView = [[ZLPlayPauseView alloc] initWithFrame:CGRectMake(270, 150, 20, 20)
                                                              color:[UIColor zl_getColorWithRed:213.0
                                                                                          green:37.0
                                                                                           blue:38.0
                                                                                          alpha:1]];
    pView.delegate = self;
    [self.view addSubview:pView];
}

-(void)setUpAccelerometerManager
{
    [ZLAccelerometerManager sharedAccelerometerManager].stepsCount = 0;
    [ZLAccelerometerManager sharedAccelerometerManager].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"ZLStepCountingViewController will appear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"ZLStepCountingViewController will disappear");
}

-(void)startTimer
{
    if (self.timeIntervalTimer) {
         [self.timeIntervalTimer invalidate];
         self.timeIntervalTimer = nil;
    }
    self.timeIntervalTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshTimeInterval) userInfo:nil repeats:YES];
}

-(void)refreshTimeInterval
{
    
}

-(void)stopTimer
{

}

#pragma mark ---------- ZLPlayPauseViewDelegate ----------
-(void)playStateChanged:(BOOL) isPlay
{
    if (isPlay) {
        [[ZLAccelerometerManager sharedAccelerometerManager] addAccelerometer];
        [self performSelectorInBackground:@selector(startTimer) withObject:nil];
    }else{
        [[ZLAccelerometerManager sharedAccelerometerManager] removeAccelerometer];
        [self stopTimer];
    }
}

#pragma mark ---------- ZLAccelerometerManagerDelegate ----------
-(void)stepsCountChanged:(int) stepsCount
{
    self.labelStepsCount.text = [NSString stringWithFormat:@"%d",stepsCount];
}

@end
