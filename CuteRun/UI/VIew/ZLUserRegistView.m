//
//  ZLUserRegistView.m
//  CuteRun
//
//  Created by LiZhaolei on 14-10-8.
//  Copyright (c) 2014年 com.zhaoleili.cuterun. All rights reserved.
//

#import "ZLUserRegistView.h"
#import "ZLNaviBackgroundView.h"
#import "ZLSystemParameterUtil.h"

@implementation ZLUserRegistView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initData];
    [self initView];
}

-(void)initData
{

}

-(void)initView
{
    CGSize titleBarSize = [ZLSystemParameterUtil getTitleBarSizeWith:nil];
    ZLNaviBackgroundView *naviBackgroundView = [[ZLNaviBackgroundView alloc] initWithFrame:CGRectMake(0, 0, titleBarSize.width, titleBarSize.height)];
    [self addSubview:naviBackgroundView];
}

@end
