//
//  ZLPlayPauseView.h
//  CuteRun
//
//  Created by LiZhaolei on 14-10-4.
//  Copyright (c) 2014年 com.zhaoleili.cuterun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZLPlayPauseViewDelegate <NSObject>

@required
-(void)playStateChanged:(BOOL) isPlay;

@end

@interface ZLPlayPauseView : UIView <UIGestureRecognizerDelegate>

@property(nonatomic, assign) BOOL isPlay;
@property(nonatomic, strong) UIColor *bgColor;
@property(nonatomic, weak) id<ZLPlayPauseViewDelegate> delegate;

- (ZLPlayPauseView *)initWithFrame:(CGRect)frame
                             color:(UIColor *)color;

@end
