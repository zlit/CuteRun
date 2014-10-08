//
//  ZLUserInfoDataModel.h
//  CuteRun
//
//  Created by LiZhaolei on 14-10-7.
//  Copyright (c) 2014年 com.zhaoleili.cuterun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZLGenderType) {
    ZLGenderTypeNone = 0,
    ZLGenderTypeMale,
    ZLGenderTypeFemale
};

@interface ZLUserInfoDataModel : NSObject

@property(nonatomic,copy) NSString *gender;//性别
@property(nonatomic,assign) float height;//身高
@property(nonatomic,assign) float weight;//体重

+(ZLUserInfoDataModel *)getUserInfoDataModel;

@end
