//
//  ZLDevice.h
//  CTRIP_WIRELESS
//
//  Created by NickJackson on 12-9-25.
//  Copyright (c) 2012年 携程. All rights reserved.
//  设备扩展类

#import <Foundation/Foundation.h>

#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height
#pragma mark - NSString(MD5Addition)

@interface NSString(MD5Addition)

- (NSString *)stringFromMD5;

@end

#ifndef CtripWireless_Business_ZLDevice_h
#define CtripWireless_Business_ZLDevice_h

#pragma mark - BOOL isIphone5();

BOOL isIphone5();
BOOL isRetina();
BOOL isIOS7();

//@class ZLDevice;

#pragma mark - ZLDevice

@interface ZLDevice : NSObject

//@property (nonatomic, readonly) NSString *uniqueIdentifier;

//+ (ZLDevice *)currentDevice;

/** 带冒号的mac地址 */
+ (NSString *)macaddress;
/** 不带冒号的mac地址 */
+ (NSString *)macaddressWithoutColon;

+ (NSString *)uniqueIdentifier;
+ (NSString *)uniqueIdentifierWithMacAndBundleId;
+ (NSString *)uniqueIdentifierWithMac;
/*
 判断是否是iPhone5
 */
+ (BOOL)isDeviceIPhone5;
/*
 判断是否是Retina设备
 */
+ (BOOL)isDeviceRetina;
/*
 获取版本型号
 */
+ (NSString*)deviceString;
/*
 判断当前运行环境是否模拟器
 */
+ (BOOL)isSimulator;

@end

#endif