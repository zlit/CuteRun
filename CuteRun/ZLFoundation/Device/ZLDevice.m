//
//  ZLDevice.m
//  CTRIP_WIRELESS
//
//  Created by NickJackson on 12-9-25.
//  Copyright (c) 2012年 携程. All rights reserved.
//  设备扩展类

#import "ZLDevice.h"
#import <UIKit/UIKit.h>

#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
//#import "config.h"

//ZLDevice *sharedInstance = nil;

BOOL isIphone5()
{
    return [ZLDevice isDeviceIPhone5];
}

BOOL isRetina()
{
    return [ZLDevice isDeviceRetina];
}

BOOL isIOS7() {
    return [[UIDevice currentDevice].systemVersion floatValue] >= 7.0;
}

#pragma mark - ZLDevice

@implementation ZLDevice

//@synthesize uniqueIdentifier;

//+ (ZLDevice *)currentDevice
//{
//    if (!sharedInstance) {
//        sharedInstance = [[ZLDevice alloc] init];
//    }
//    return sharedInstance;
//}

#pragma mark - --------------------私有函数--------------------
#pragma mark - --------------------接口函数--------------------

#pragma mark 带冒号的mac地址

+ (NSString *)macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;

    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;

    if ((mib[5] = if_nametoindex("en0")) == 0)
    {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }

    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
    {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }

    if ((buf = (char *)malloc(len)) == NULL)
    {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }

    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
    {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }

    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);

    return [outstring uppercaseString];
}

#pragma mark 不带冒号的mac地址

+ (NSString *)macaddressWithoutColon
{
    return [[ZLDevice macaddress] stringByReplacingOccurrencesOfString:@":" withString:@""];
}

#pragma mark 判断是否iphone5

+ (BOOL)isDeviceIPhone5
{
    if ([UIScreen mainScreen].bounds.size.height == 568)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark 判断是否是Retina设备

+ (BOOL)isDeviceRetina
{
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        CGFloat scale = [[UIScreen mainScreen] scale];
        if (scale > 1.0) {
            return YES;
        }
    }
    return NO;
}

#pragma mark 判断是否模拟器

+ (BOOL)isSimulator
{
    return ([[ZLDevice deviceString] isEqualToString:@"i386"] || [[ZLDevice deviceString] isEqualToString:@"x86_64"]);
}

#pragma mark 获取版本型号

+ (NSString*)deviceString
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
/*
    UIWindow* window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    CGRect winBounds = window.bounds;

    if (winBounds.size.height >= 500)
    {
        return @"iPhone 5";
    }
 */
//    if (([UIScreen instancesRespondToSelector:@selector(currentMode)]) ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//    {
//        return @"iPhone 5";
//    }
//
//    if ([deviceString isEqualToString:@"iPhone1,1"])    {   return @"iPhone 1G";        }
//    if ([deviceString isEqualToString:@"iPhone1,2"])    {   return @"iPhone 3G";        }
//    if ([deviceString isEqualToString:@"iPhone2,1"])    {   return @"iPhone 3GS";       }
//    if ([deviceString isEqualToString:@"iPhone3,1"])    {   return @"iPhone 4";         }
//    if ([deviceString isEqualToString:@"iPhone4,1"])    {   return @"iPhone 4S";        }
//    if ([deviceString isEqualToString:@"iPhone3,2"])    {   return @"Verizon iPhone 4"; }
//    if ([deviceString isEqualToString:@"iPod1,1"])      {   return @"iPod Touch 1G";    }
//    if ([deviceString isEqualToString:@"iPod2,1"])      {   return @"iPod Touch 2G";    }
//    if ([deviceString isEqualToString:@"iPod3,1"])      {   return @"iPod Touch 3G";    }
//    if ([deviceString isEqualToString:@"iPod4,1"])      {   return @"iPod Touch 4G";    }
//    if ([deviceString isEqualToString:@"iPad1,1"])      {   return @"iPad";             }
//    if ([deviceString isEqualToString:@"iPad2,1"])      {   return @"iPad 2 (WiFi)";    }
//    if ([deviceString isEqualToString:@"iPad2,2"])      {   return @"iPad 2 (GSM)";     }
//    if ([deviceString isEqualToString:@"iPad2,3"])      {   return @"iPad 2 (CDMA)";    }
//    if ([deviceString isEqualToString:@"iPad3,1"])      {   return @"iPad 3 (WiFi)";    }
//    if ([deviceString isEqualToString:@"iPad3,2"])      {   return @"iPad 3 (GSM)";     }
//    if ([deviceString isEqualToString:@"iPad3,3"])      {   return @"iPad 3 (CDMA)";    }
//    if ([deviceString isEqualToString:@"i386"])         {   return @"Simulator";        }
//    if ([deviceString isEqualToString:@"x86_64"])       {   return @"Simulator";        }
//    TLog(@"NOTE: Unknown device type: %@", deviceString);
//
//    return deviceString;
}

#pragma mark - 自己生成UDID

+ (NSString *)uniqueIdentifier
{
    return [ZLDevice uniqueIdentifierWithMacAndBundleId];
}

#pragma mark 根据Mac地址和程序id加密取唯一串

+ (NSString *)uniqueIdentifierWithMacAndBundleId
{
    NSString* macaddress = [ZLDevice macaddress];
    NSString* bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];

    NSString* stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
    NSString* uniqueIdentifier = [stringToHash stringFromMD5];

    return uniqueIdentifier;
}

#pragma mark 根据Mac地址加密取唯一串

+ (NSString *)uniqueIdentifierWithMac
{
    NSString *macaddress = [ZLDevice macaddress];
    NSString *uniqueIdentifier = [macaddress stringFromMD5];

    return uniqueIdentifier;
}

@end

#pragma mark - NSString(MD5Addition)

@implementation NSString(MD5Addition)

- (NSString *) stringFromMD5
{
    if(self == nil || [self length] == 0)   {   return nil; }

    const char *value = [self UTF8String];

    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);

    NSMutableString* outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(unsigned int count = 0; count < CC_MD5_DIGEST_LENGTH; count++)
    {
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }

    return outputString;
}

@end
