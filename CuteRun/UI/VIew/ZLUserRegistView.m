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
#import "ZLUserInfoDataModel.h"

#define kCellHeight 40
#define kPickerViewHeight 150


@interface ZLUserRegistView()

@property(nonatomic, strong) ZLNaviBackgroundView *naviBackgroundView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *bmiLabel;
@property(nonatomic, strong) UIPickerView *mPickerView;
@property(nonatomic, strong) UIButton *doneButton;
@property(nonatomic, strong) UIView *pickerAndDoneView;


@property(nonatomic, strong) NSMutableArray *pickerDataArray;
@property(nonatomic, strong) NSMutableArray *genderArray;
@property(nonatomic, strong) NSMutableArray *heightArray;
@property(nonatomic, strong) NSMutableArray *weightArray;
@property(nonatomic, strong) NSArray *tableCellTitleArray;
@property(nonatomic, strong) ZLUserInfoDataModel *userInfoDataModel;

@end

@implementation ZLUserRegistView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initView];
    }
    return self;
}

-(void)initData
{
    self.pickerDataArray = nil;
    self.userInfoDataModel = [[ZLUserInfoDataModel alloc] init];
    [self initGenderArray];
    [self initHeightArray];
    [self initWeightArray];
    [self initTableCellTitleArray];
}

-(void)initView
{
    self.backgroundColor = [UIColor zl_getColorWithRed:246.0
                                                 green:246.0
                                                  blue:246.0
                                                 alpha:1.0];
    float ogrinY = 0;
    CGSize titleBarSize = [ZLSystemParameterUtil getTitleBarSizeWith:nil];
    self.naviBackgroundView = [[ZLNaviBackgroundView alloc] initWithFrame:CGRectMake(0, 0, titleBarSize.width, titleBarSize.height)];
    [self addSubview:self.naviBackgroundView];
    ogrinY += titleBarSize.height;
    
    self.titleLabel = [self getUILabelWithContentStr:@"设置个人信息"
                                                    font:zl_fontBoldSysteSize(16)
                                            titleBarSize:titleBarSize];
    [self addSubview:self.titleLabel];
    
    UIImage* myImage = [UIImage imageNamed:@"runner"];
    self.imageView = [[UIImageView alloc] initWithImage:myImage];
    self.imageView.frame = CGRectMake(0, ogrinY, [self.imageView zl_width], [self.imageView zl_height]);
    [self addSubview:self.imageView];
    ogrinY += [self.imageView zl_height]-40;
    
    float tableHeigth = kCellHeight * [self.tableCellTitleArray count];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ogrinY, zl_screenWidth, tableHeigth)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    
    self.bmiLabel = [[UILabel alloc] init];
    self.bmiLabel.backgroundColor = [UIColor clearColor];
    self.bmiLabel.numberOfLines = 0;
    self.bmiLabel.font = zl_fontSysteSize(13);
    self.bmiLabel.alpha = 0.4;
    self.bmiLabel.textColor = [UIColor blackColor];
    CGSize size = CGSizeMake(290, CGFLOAT_MAX);
    self.bmiLabel.text = @"BMI : 身体质量指数，是衡量是否肥胖和标准体重的重要指标。健康BMI为18.5≤BMI<23。注意:儿童、发育中的青少年、孕妇、乳母、老人及身型健硕的运动员不适用此标准。";
    CGSize labelSize = [self.bmiLabel.text boundingRectWithSize:size
                                            withTextFont:self.bmiLabel.font
                                         withLineSpacing:0];
    self.bmiLabel.frame = CGRectMake(15, zl_screenHeight-10-labelSize.height, labelSize.width, labelSize.height);
    [self addSubview:self.bmiLabel];
    self.doneButton = [[UIButton alloc] initWithFrame:CGRectMake(240, 0, 80, 44)];
    [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
    self.doneButton.backgroundColor = [UIColor clearColor];
    self.doneButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.doneButton.titleLabel.textColor = [UIColor whiteColor];
    self.doneButton.titleLabel.font = zl_fontBoldSysteSize(16);
    self.doneButton.titleLabel.frame = self.doneButton.bounds;
    
    self.mPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, zl_screenWidth, kPickerViewHeight)];
    self.mPickerView.backgroundColor = [UIColor whiteColor];
    self.mPickerView.delegate = self;
    self.mPickerView.dataSource = self;
    
    self.pickerAndDoneView = [[UIView alloc] initWithFrame:CGRectMake(0, zl_screenHeight, zl_screenWidth, self.doneButton.zl_height+self.mPickerView.zl_height)];
    self.pickerAndDoneView.backgroundColor = [UIColor zl_getColorWithRed:37
                                                                   green:156
                                                                    blue:208
                                                                   alpha:1];
    [self.pickerAndDoneView addSubview:self.doneButton];
     [self.pickerAndDoneView addSubview:self.mPickerView];
    [self addSubview:self.pickerAndDoneView];
}

- (UILabel *)getUILabelWithContentStr:(NSString *) contentStr
                                 font:(UIFont *) font
                         titleBarSize:(CGSize) titleBarSize
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.font = font;
    label.textColor = [UIColor whiteColor];
    CGSize size = CGSizeMake(320, CGFLOAT_MAX);
    CGSize labelSize = [contentStr boundingRectWithSize:size
                                           withTextFont:label.font
                                        withLineSpacing:0];
    label.text = contentStr;
    CGPoint orgin = [ZLSystemParameterUtil getMiddlePositionWithViewSize:labelSize
                                                              targetSize:titleBarSize];
    label.frame = CGRectMake(orgin.x, orgin.y+(ceil(zl_statusBarHeight/2.0))-3, labelSize.width, labelSize.height);
    return label;
}

-(void)initGenderArray
{
    self.genderArray = [NSMutableArray arrayWithCapacity:2];
    [self.genderArray addObject:@"男"];
    [self.genderArray addObject:@"女"];
}

-(void)initHeightArray
{
    int height = 30;
    self.heightArray = [NSMutableArray arrayWithCapacity:190];
    while (height <= 220) {
        [self.heightArray addObject:[NSString stringWithFormat:@"%d",height]];
        height++;
    }
}

-(void)initWeightArray
{
    int weight = 30;
    self.weightArray = [NSMutableArray arrayWithCapacity:90];
    while (weight <= 120) {
        [self.weightArray addObject:[NSString stringWithFormat:@"%d",weight]];
        weight+=1;
    }
}

-(void)initTableCellTitleArray
{
    self.tableCellTitleArray = @[@"性别",@"身高",@"体重",@"BMI",@"健康体重范围",@"建议标准体重"];
}

#pragma mark --------------- UITableViewDataSource ---------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableCellTitleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [self.tableCellTitleArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.alpha = 0.4f;
    cell.textLabel.font = zl_fontSysteSize(16);
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.numberOfLines = 0;
    contentLabel.font = zl_fontSysteSize(16);
    contentLabel.alpha = 0.7;
    contentLabel.textColor = [UIColor blackColor];
    CGSize size = CGSizeMake(320, CGFLOAT_MAX);
    NSString *contentText = @"";
    switch (indexPath.row) {
        case 0:
        {
            if(self.userInfoDataModel.gender == ZLGenderTypeMale){
                contentText = @"男";
            }else{
                contentText = @"女";
            }
        }
            break;
        case 1:
            contentText = [NSString stringWithFormat:@"%.0lf CM",self.userInfoDataModel.height];
            break;
        case 2:
            contentText = [NSString stringWithFormat:@"%.0lf KG(1KG=2斤)",self.userInfoDataModel.weight];
            break;
        case 3:
        {
            contentText = [self.userInfoDataModel getBMIDescription];

        }
            break;
        case 4:
        {
            contentText = [self.userInfoDataModel getHealthWeightDescription];
            
        }
            break;
        case 5:
        {
            contentText = [self.userInfoDataModel getStandardWeightDescription];
            
        }
            break;
        default:
            break;
    }
    
    contentLabel.text = contentText;
    CGSize labelSize = [contentText boundingRectWithSize:size
                                            withTextFont:contentLabel.font
                                          withLineSpacing:0];
    contentLabel.frame = CGRectMake(130, (44-labelSize.height)/2.0, labelSize.width, labelSize.height);
    [cell.contentView addSubview:contentLabel];
    
    if(indexPath.row <= 2){
        UIImage* arrowImage = [UIImage imageNamed:@"ArrowRight"];
        UIImageView* arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
        arrowImageView.frame = CGRectMake(zl_screenWidth-15-[arrowImageView zl_width], (kCellHeight-[arrowImageView zl_height])/2.0, [arrowImageView zl_width], [arrowImageView zl_height]);
        [cell.contentView addSubview:arrowImageView];
    }
    
    return cell;
}

#pragma mark --------------- UITableViewDelegate ---------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row <= 2){
        switch (indexPath.row) {
            case 0:
                self.pickerDataArray = self.genderArray;
                break;
            case 1:
                self.pickerDataArray = self.heightArray;
                break;
            case 2:
                self.pickerDataArray = self.weightArray;
                break;
            default:
                break;
        }
        [self.mPickerView reloadAllComponents];
        [self showPickerView];
    }
}

//- (IBAction)pickDoneAction:(id)sender {
//    [self removePickerView];
//}

-(void)showPickerView
{
    [UIView animateWithDuration:.35f animations:^{
        self.pickerAndDoneView.frame = CGRectMake(0, zl_screenHeight-self.mPickerView.zl_height-self.doneButton.zl_height, zl_screenWidth, self.mPickerView.zl_height+self.doneButton.zl_height);
    } completion:^(BOOL finished) {
    }];
}

-(void)removePickerView
{
    [UIView animateWithDuration:.35f animations:^{
        self.pickerAndDoneView.frame = CGRectMake(0, zl_screenHeight, zl_screenWidth, self.mPickerView.zl_height+self.doneButton.zl_height);
    } completion:^(BOOL finished) {
    }];
}

#pragma mark --------------- UIPickerViewDataSource ---------------
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)mPickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerDataArray count];
}

#pragma mark --------------- UIPickerViewDelegate ---------------
- (NSString *)pickerView:(UIPickerView *)mPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerDataArray zl_objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)mPickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%@",[self.pickerDataArray zl_objectAtIndex:row]);
}

@end
