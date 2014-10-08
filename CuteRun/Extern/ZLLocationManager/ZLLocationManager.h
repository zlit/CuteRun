//
//  ZLLocationManager.h
//  TestProject
//
//  Created by LiZhaolei on 14-9-29.
//  Copyright (c) 2014年 com.zlli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum {
    ZLLocationManagerGPSSignalStrengthInvalid = 0
    , ZLLocationManagerGPSSignalStrengthWeak
    , ZLLocationManagerGPSSignalStrengthStrong
} ZLLocationManagerGPSSignalStrength;

@class ZLLocationManager;

@protocol ZLLocationManagerDelegate <NSObject>

- (void)locationManager:(ZLLocationManager *)locationManager signalStrengthChanged:(ZLLocationManagerGPSSignalStrength)signalStrength;
- (void)locationManagerSignalConsistentlyWeak:(ZLLocationManager *)locationManager;
- (void)locationManager:(ZLLocationManager *)locationManager distanceUpdated:(CLLocationDistance)distance;
- (void)locationManager:(ZLLocationManager *)locationManager waypoint:(CLLocation *)waypoint calculatedSpeed:(CLLocationSpeed)calculatedSpeed;
- (void)locationManager:(ZLLocationManager *)locationManager error:(NSError *)error;
- (void)locationManager:(ZLLocationManager *)locationManager debugText:(NSString *)text;

//省份,城市回调
- (void)locationManager:(ZLLocationManager *)locationManager
           provinceName:(NSString *) provinceName
               cityName:(NSString *) cityName;
@end

@interface ZLLocationManager : NSObject <CLLocationManagerDelegate>

+ (ZLLocationManager *)sharedLocationManager;

@property (nonatomic, weak) id<ZLLocationManagerDelegate> delegate;
@property (nonatomic, readonly) ZLLocationManagerGPSSignalStrength signalStrength;
@property (nonatomic, readonly) CLLocationDistance totalDistance;
@property (nonatomic, readonly) NSTimeInterval totalSeconds;
@property (nonatomic, readonly) CLLocationSpeed currentSpeed;

- (BOOL)startLocationUpdates;
- (void)stopLocationUpdates;
- (BOOL)prepLocationUpdates;
- (void)resetLocationUpdates;
@end