//
//  ZLLocationManager.m
//  TestProject
//
//  Created by LiZhaolei on 14-9-29.
//  Copyright (c) 2014年 com.zlli. All rights reserved.
//

#import "ZLLocationManager.h"
#import <CoreGraphics/CoreGraphics.h>
#import "JSONKit.h"
#import "FileUtil.h"


#define kLocationTraceFileName @"locationLister.txt"
#define kLocationReverseResult @"locationReverseResult.txt"

#define kBaiduMapGeoCodeAPI @"http://api.map.baidu.com/geocoder/v2/?ak=2847f568102766ea81d87ac206c5ec26&callback=renderReverse&location=%lf,%lf&output=json&pois=0"

static const NSUInteger kDistanceFilter = 5; // the minimum distance (meters) for which we want to receive location updates (see docs for CLLocationManager.distanceFilter)
static const NSUInteger kHeadingFilter = 30; // the minimum angular change (degrees) for which we want to receive heading updates (see docs for CLLocationManager.headingFilter)
static const NSUInteger kDistanceAndSpeedCalculationInterval = 3; // the interval (seconds) at which we calculate the user's distance and speed
static const NSUInteger kMinimumLocationUpdateInterval = 10; // the interval (seconds) at which we ping for a new location if we haven't received one yet
static const NSUInteger kNumLocationHistoriesToKeep = 5; // the number of locations to store in history so that we can look back at them and determine which is most accurate
static const NSUInteger kValidLocationHistoryDeltaInterval = 3; // the maximum valid age in seconds of a location stored in the location history
static const NSUInteger kNumSpeedHistoriesToAverage = 3; // the number of speeds to store in history so that we can average them to get the current speed
static const NSUInteger kPrioritizeFasterSpeeds = 1; // if > 0, the currentSpeed and complete speed history will automatically be set to to the new speed if the new speed is faster than the averaged speed
static const NSUInteger kMinLocationsNeededToUpdateDistanceAndSpeed = 3; // the number of locations needed in history before we will even update the current distance and speed
static const CGFloat kRequiredHorizontalAccuracy = 20.0; // the required accuracy in meters for a location.  if we receive anything above this number, the delegate will be informed that the signal is weak
static const CGFloat kMaximumAcceptableHorizontalAccuracy = 70.0; // the maximum acceptable accuracy in meters for a location.  anything above this number will be completely ignored
static const NSUInteger kGPSRefinementInterval = 15; // the number of seconds at which we will attempt to achieve kRequiredHorizontalAccuracy before giving up and accepting kMaximumAcceptableHorizontalAccuracy

static const CGFloat kSpeedNotSet = -1.0;

@interface ZLLocationManager ()

@property (nonatomic) ZLLocationManagerGPSSignalStrength signalStrength;
@property (nonatomic) CLLocationDistance totalDistance;
@property (nonatomic) NSTimeInterval totalSeconds;
@property (nonatomic) CLLocationSpeed currentSpeed;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSTimer *locationPingTimer;
@property (nonatomic, strong) CLLocation *lastRecordedLocation;
@property (nonatomic, strong) NSMutableArray *locationHistory;
@property (nonatomic, strong) NSDate *startTimestamp;
@property (nonatomic, strong) NSMutableArray *speedHistory;
@property (nonatomic) NSUInteger lastDistanceAndSpeedCalculation;
@property (nonatomic) BOOL forceDistanceAndSpeedCalculation;
@property (nonatomic) NSTimeInterval pauseDelta;
@property (nonatomic) NSTimeInterval pauseDeltaStart;
@property (nonatomic) BOOL readyToExposeDistanceAndSpeed;
@property (nonatomic) BOOL checkingSignalStrength;
@property (nonatomic) BOOL allowMaximumAcceptableAccuracy;
@property (nonatomic) CLLocation *oldLocation;
@property (nonatomic) CLLocation *reverseGeocodeLocation;
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic) dispatch_queue_t reverseLocationDispatch;

- (void)checkSustainedSignalStrength;
- (void)requestNewLocation;

@end

@implementation ZLLocationManager

+ (ZLLocationManager *)sharedLocationManager {
    static dispatch_once_t pred;
    static ZLLocationManager *locationManagerSingleton = nil;
    
    dispatch_once(&pred, ^{
        locationManagerSingleton = [[self alloc] init];
    });
    return locationManagerSingleton;
}

- (id)init {
    if ((self = [super init])) {
        self.reverseLocationDispatch = dispatch_queue_create("com.ZLLocationManager.reverseLocation", NULL);
        if ([CLLocationManager locationServicesEnabled]) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.distanceFilter = kDistanceFilter;
            self.locationManager.headingFilter = kHeadingFilter;
            self.locationManager.activityType = CLActivityTypeFitness;
        }
        self.locationHistory = [NSMutableArray arrayWithCapacity:kNumLocationHistoriesToKeep];
        self.speedHistory = [NSMutableArray arrayWithCapacity:kNumSpeedHistoriesToAverage];
        [self resetLocationUpdates];
    }
    
    return self;
}

- (void)setSignalStrength:(ZLLocationManagerGPSSignalStrength)signalStrength {
    BOOL needToUpdateDelegate = NO;
    if (_signalStrength != signalStrength) {
        needToUpdateDelegate = YES;
    }
    
    _signalStrength = signalStrength;
    
    if (self.signalStrength == ZLLocationManagerGPSSignalStrengthStrong) {
        self.allowMaximumAcceptableAccuracy = NO;
    } else if (self.signalStrength == ZLLocationManagerGPSSignalStrengthWeak) {
        [self checkSustainedSignalStrength];
    }
    
    if (needToUpdateDelegate) {
        if ([self.delegate respondsToSelector:@selector(locationManager:signalStrengthChanged:)]) {
            [self.delegate locationManager:self signalStrengthChanged:self.signalStrength];
        }
    }
}

- (void)setTotalDistance:(CLLocationDistance)totalDistance {
    _totalDistance = totalDistance;
    
    if (self.currentSpeed != kSpeedNotSet) {
        if ([self.delegate respondsToSelector:@selector(locationManager:distanceUpdated:)]) {
            [self.delegate locationManager:self distanceUpdated:self.totalDistance];
        }
    }
}

- (NSTimeInterval)totalSeconds {
    return ([self.startTimestamp timeIntervalSinceNow] * -1) - self.pauseDelta;
}

- (void)checkSustainedSignalStrength {
    if (!self.checkingSignalStrength) {
        self.checkingSignalStrength = YES;
        
        double delayInSeconds = kGPSRefinementInterval;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.checkingSignalStrength = NO;
            if (self.signalStrength == ZLLocationManagerGPSSignalStrengthWeak) {
                self.allowMaximumAcceptableAccuracy = YES;
                if ([self.delegate respondsToSelector:@selector(locationManagerSignalConsistentlyWeak:)]) {
                    [self.delegate locationManagerSignalConsistentlyWeak:self];
                }
            } else if (self.signalStrength == ZLLocationManagerGPSSignalStrengthInvalid) {
                self.allowMaximumAcceptableAccuracy = YES;
                self.signalStrength = ZLLocationManagerGPSSignalStrengthWeak;
                if ([self.delegate respondsToSelector:@selector(locationManagerSignalConsistentlyWeak:)]) {
                    [self.delegate locationManagerSignalConsistentlyWeak:self];
                }
            }
        });
    }
}

- (void)requestNewLocation {
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startUpdatingLocation];
}

- (BOOL)prepLocationUpdates {
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationHistory removeAllObjects];
        [self.speedHistory removeAllObjects];
        self.lastDistanceAndSpeedCalculation = 0;
        self.currentSpeed = kSpeedNotSet;
        self.readyToExposeDistanceAndSpeed = NO;
        self.signalStrength = ZLLocationManagerGPSSignalStrengthInvalid;
        self.allowMaximumAcceptableAccuracy = NO;
        self.oldLocation = nil;
        self.forceDistanceAndSpeedCalculation = YES;
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
        
        [self checkSustainedSignalStrength];
        
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)startLocationUpdates {
    if ([CLLocationManager locationServicesEnabled]) {
        self.readyToExposeDistanceAndSpeed = YES;
        
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
        
        if (self.pauseDeltaStart > 0) {
            self.pauseDelta += ([NSDate timeIntervalSinceReferenceDate] - self.pauseDeltaStart);
            self.pauseDeltaStart = 0;
        }
        
        return YES;
    } else {
        return NO;
    }
}

- (void)stopLocationUpdates {
    [self.locationPingTimer invalidate];
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopUpdatingHeading];
    self.pauseDeltaStart = [NSDate timeIntervalSinceReferenceDate];
    self.lastRecordedLocation = nil;
    self.oldLocation = nil;
}

- (void)resetLocationUpdates {
    self.totalDistance = 0;
    self.startTimestamp = [NSDate dateWithTimeIntervalSinceNow:0];
    self.forceDistanceAndSpeedCalculation = NO;
    self.pauseDelta = 0;
    self.pauseDeltaStart = 0;
    self.oldLocation = nil;
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // since the oldLocation might be from some previous use of core location, we need to make sure we're getting data from this run
    if([locations count] <= 0){
        return;
    }
    
    CLLocation *newLocation = (CLLocation *)[locations objectAtIndex:0];
    dispatch_async(self.reverseLocationDispatch, ^{
        [self reverseGeocodeLocationWithLocation:newLocation];
    });
    
    [self calculateDistanceAndSpeedWithLocation:newLocation];
}

-(void)calculateDistanceAndSpeedWithLocation:(CLLocation *) newLocation
{
    if(self.oldLocation == nil){
        self.oldLocation = newLocation;
        return;
    }
    
    //    [FileUtil writeLogWithContent:[newLocation description]
    //                         fileName:kLocationTraceFileName];
    
    BOOL isStaleLocation = ([self.oldLocation.timestamp compare:self.startTimestamp] == NSOrderedAscending);
    
    [self.locationPingTimer invalidate];
    
    if (newLocation.horizontalAccuracy <= kRequiredHorizontalAccuracy) {
        self.signalStrength = ZLLocationManagerGPSSignalStrengthStrong;
    } else {
        self.signalStrength = ZLLocationManagerGPSSignalStrengthWeak;
    }
    
    double horizontalAccuracy;
    if (self.allowMaximumAcceptableAccuracy) {
        horizontalAccuracy = kMaximumAcceptableHorizontalAccuracy;
    } else {
        horizontalAccuracy = kRequiredHorizontalAccuracy;
    }
    
    if (!isStaleLocation && newLocation.horizontalAccuracy >= 0 && newLocation.horizontalAccuracy <= horizontalAccuracy) {
        
        [self.locationHistory addObject:newLocation];
        if ([self.locationHistory count] > kNumLocationHistoriesToKeep) {
            [self.locationHistory removeObjectAtIndex:0];
        }
        
        BOOL canUpdateDistanceAndSpeed = NO;
        if ([self.locationHistory count] >= kMinLocationsNeededToUpdateDistanceAndSpeed) {
            canUpdateDistanceAndSpeed = YES && self.readyToExposeDistanceAndSpeed;
        }
        
        if (self.forceDistanceAndSpeedCalculation || [NSDate timeIntervalSinceReferenceDate] - self.lastDistanceAndSpeedCalculation > kDistanceAndSpeedCalculationInterval) {
            self.forceDistanceAndSpeedCalculation = NO;
            self.lastDistanceAndSpeedCalculation = [NSDate timeIntervalSinceReferenceDate];
            
            CLLocation *lastLocation = (self.lastRecordedLocation != nil) ? self.lastRecordedLocation : self.oldLocation;
            
            CLLocation *bestLocation = nil;
            CGFloat bestAccuracy = kRequiredHorizontalAccuracy;
            for (CLLocation *location in self.locationHistory) {
                if ([NSDate timeIntervalSinceReferenceDate] - [location.timestamp timeIntervalSinceReferenceDate] <= kValidLocationHistoryDeltaInterval) {
                    if (location.horizontalAccuracy <= bestAccuracy && location != lastLocation) {
                        bestAccuracy = location.horizontalAccuracy;
                        bestLocation = location;
                    }
                }
            }
            if (bestLocation == nil) bestLocation = newLocation;
            
            CLLocationDistance distance = [bestLocation distanceFromLocation:lastLocation];
            if (canUpdateDistanceAndSpeed){
                self.totalDistance += distance;
                //                [FileUtil writeLogWithContent:[NSString stringWithFormat:@"totalDistance = %.0lf",self.totalDistance]
                //                                     fileName:kLocationTraceFileName];kLocationReverseResult
            }
            self.lastRecordedLocation = bestLocation;
            
            NSTimeInterval timeSinceLastLocation = [bestLocation.timestamp timeIntervalSinceDate:lastLocation.timestamp];
            if (timeSinceLastLocation > 0) {
                CGFloat speed = distance / timeSinceLastLocation;
                if (speed <= 0 && [self.speedHistory count] == 0) {
                    // don't add a speed of 0 as the first item, since it just means we're not moving yet
                } else {
                    [self.speedHistory addObject:[NSNumber numberWithDouble:speed]];
                }
                if ([self.speedHistory count] > kNumSpeedHistoriesToAverage) {
                    [self.speedHistory removeObjectAtIndex:0];
                }
                if ([self.speedHistory count] > 1) {
                    double totalSpeed = 0;
                    for (NSNumber *speedNumber in self.speedHistory) {
                        totalSpeed += [speedNumber doubleValue];
                    }
                    if (canUpdateDistanceAndSpeed) {
                        double newSpeed = totalSpeed / (double)[self.speedHistory count];
                        if (kPrioritizeFasterSpeeds > 0 && speed > newSpeed) {
                            newSpeed = speed;
                            [self.speedHistory removeAllObjects];
                            for (int i=0; i<kNumSpeedHistoriesToAverage; i++) {
                                [self.speedHistory addObject:[NSNumber numberWithDouble:newSpeed]];
                            }
                        }
                        self.currentSpeed = newSpeed;
                        //                        [FileUtil writeLogWithContent:[NSString stringWithFormat:@"currentSpeed = %.2lf",self.currentSpeed]
                        //                                             fileName:kLocationTraceFileName];
                    }
                }
            }
            
            if ([self.delegate respondsToSelector:@selector(locationManager:waypoint:calculatedSpeed:)])
            {
                [self.delegate locationManager:self waypoint:self.lastRecordedLocation calculatedSpeed:self.currentSpeed];
            }
        }
    }
    
    // this will be invalidated above if a new location is received before it fires
    self.locationPingTimer = [NSTimer timerWithTimeInterval:kMinimumLocationUpdateInterval target:self selector:@selector(requestNewLocation) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.locationPingTimer forMode:NSRunLoopCommonModes];
    self.oldLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    // we don't really care about the new heading.  all we care about is calculating the current distance from the previous distance early if the user changed directions
    self.forceDistanceAndSpeedCalculation = YES;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        if ([self.delegate respondsToSelector:@selector(locationManager:error:)]) {
            [self.delegate locationManager:self error:error];
        }
        [self stopLocationUpdates];
    }
}

#pragma mark reverseGeocodeLocation

-(void)reverseGeocodeLocationWithLocation:(CLLocation *) location
{
    if([self isNeedReverseGeocodeLocationWithLocation:location] == NO){
        return;
    }
    
    BOOL reverseResult = NO;
    if (NSClassFromString(@"CLGeocoder") != nil){
        reverseResult = [self reverseLocationTypeWithCoordinateByApple:location];
        if(reverseResult == NO){
            reverseResult = [self reverseLocationTypeWithCoordinateByBaidu:location];
        }
    }else
    {
        reverseResult = [self reverseLocationTypeWithCoordinateByBaidu:location];
    }
    
    if (reverseResult == YES) {
        self.reverseGeocodeLocation = location;
    }
    
    if (reverseResult == YES
        && self.provinceName.length > 0
        && self.cityName.length > 0
        && [self.delegate respondsToSelector:@selector(locationManager:provinceName:cityName:)])
    {
        dispatch_async(dispatch_get_main_queue(),^{
            [self.delegate locationManager:self
                              provinceName:self.provinceName
                                  cityName:self.cityName];
        });
    }
    
    NSString *content = [NSString stringWithFormat:@"reverseResult = %@,current province = %@, city = %@",reverseResult?@"success":@"failed",self.provinceName,self.cityName];
    [FileUtil writeLogWithContent:content
                         fileName:kLocationReverseResult
                      isOverWrite:NO];
}

-(BOOL)isNeedReverseGeocodeLocationWithLocation:(CLLocation *) location
{
    BOOL isNeed = NO;
    if(self.provinceName.length <= 0
       || self.cityName.length <= 0
       || self.reverseGeocodeLocation == nil){
        isNeed = YES;
    }
    
    NSTimeInterval timeInterval = [location.timestamp timeIntervalSinceReferenceDate] - [self.reverseGeocodeLocation.timestamp timeIntervalSinceReferenceDate];
    
    if(timeInterval > 3600){
        isNeed = YES;
    }
    return isNeed;
}

- (BOOL)reverseLocationTypeWithCoordinateByApple:(CLLocation *) location
{
    __block BOOL reverseLocationResult = NO;
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
            reverseLocationResult = YES;
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            //             self.location.text = placemark.name;
            //获取城市
            self.provinceName = placemark.administrativeArea;
            self.cityName = placemark.locality;
            
            if (self.cityName == nil) {
             //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市
                self.cityName = placemark.subLocality;
            }
         }else{
             if (error == nil && [array count] == 0){
                 NSLog(@"No results were returned.");
             }else if (error != nil){
                 NSLog(@"An error occurred = %@", error);
             }
         }
     }];
    return reverseLocationResult;
}

- (BOOL)reverseLocationTypeWithCoordinateByBaidu:(CLLocation *) location
{
    BOOL reverseLocationResult = NO;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kBaiduMapGeoCodeAPI, location.coordinate.latitude,location.coordinate.longitude]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url
                                                               cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                           timeoutInterval:60];
    NSURLResponse *response = nil;
    NSError *geoError;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&geoError];
    
    if (geoError == nil)
    {
        NSString* responseString = [[NSString alloc] initWithData:data
                                                         encoding:NSUTF8StringEncoding];
        responseString = [responseString substringWithRange:NSMakeRange(29, responseString.length - 30)];
        NSDictionary* dict = [responseString objectFromJSONString];
        NSDictionary* resultDic = [dict objectForKey:@"result"];
        NSDictionary* addressDic = [resultDic objectForKey:@"addressComponent"];
        if(addressDic != nil){
            NSString *provinceName = [addressDic objectForKey:@"province"];
            NSString *cityName = [addressDic objectForKey:@"city"];
            if([provinceName isEqual:cityName]){//直辖市
                cityName = [addressDic objectForKey:@"district"];
            }
            self.provinceName = [provinceName substringToIndex:provinceName.length-1];
            self.cityName = [cityName substringToIndex:cityName.length-1];
            reverseLocationResult = YES;
        }
    }else{
        NSLog(@"An error occurred = %@", geoError);
    }
    return reverseLocationResult;
}
@end
