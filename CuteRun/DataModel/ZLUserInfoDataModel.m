//
//  ZLUserInfoDataModel.m
//  CuteRun
//
//  Created by LiZhaolei on 14-10-7.
//  Copyright (c) 2014年 com.zhaoleili.cuterun. All rights reserved.
//

#import "ZLUserInfoDataModel.h"

@implementation ZLUserInfoDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gender = ZLGenderTypeNone;
        self.height = 0.0;
        self.weight = 0.0;
    }
    return self;
}

@end
