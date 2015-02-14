//
//  ZLUserRegistView.h
//  CuteRun
//
//  Created by LiZhaolei on 14-10-8.
//  Copyright (c) 2014年 com.zhaoleili.cuterun. All rights reserved.
//

#import "ZLView.h"
typedef void (^EditUserInfoCompleteCallback)(void);

@interface ZLUserRegistView : ZLView <UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic, copy) EditUserInfoCompleteCallback editCompleteCallback;

@end
