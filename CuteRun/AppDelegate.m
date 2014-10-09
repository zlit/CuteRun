//
//  AppDelegate.m
//  CuteRun
//
//  Created by LiZhaolei on 14-10-2.
//  Copyright (c) 2014年 com.zhaoleili.cuterun. All rights reserved.
//

#import "AppDelegate.h"
#import "ZLLeftMenuViewController.h"
#import "RESideMenu.h"
#import "ZLStepCountingViewController.h"
#import "ZLUserRegistView.h"
#import "FileUtil.h"
#import "ZLUserInfoDataModel.h"
#import "UIColor+CTExtensions.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[ZLLocationManager sharedLocationManager] prepLocationUpdates];
    if([UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[ZLStepCountingViewController alloc] init]];
    ZLLeftMenuViewController *leftMenuViewController = [[ZLLeftMenuViewController alloc] init];
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                    leftMenuViewController:nil
                                                                   rightMenuViewController:leftMenuViewController];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"MenuBackground"];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    self.window.rootViewController = sideMenuViewController;
    self.window.backgroundColor = [UIColor zl_getColorWithRed:246.0
                                                        green:246.0
                                                         blue:246.0
                                                        alpha:1.0];
    [self.window makeKeyAndVisible];
    
    if([FileUtil isExistsFilePath:[FileUtil dataFilePath:kUserInfoPath]] == NO){
        ZLUserRegistView *userRegistView = [[ZLUserRegistView alloc] initWithFrame:CGRectMake(0, 0, zl_screenWidth, zl_screenHeight)];
        [self.window addSubview:userRegistView];
    }

    
    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
