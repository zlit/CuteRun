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
@property(nonatomic, strong) UILabel *pickerTitle;
@property(nonatomic, strong) UIPickerView *mPickerView;
@property(nonatomic, strong) UIButton *doneButton;
@property(nonatomic, strong) UIView *pickerAndDoneView;
@property(nonatomic, strong) UIButton *completeButton;

@property(nonatomic, strong) NSMutableArray *pickerDataArray;
@property(nonatomic, strong) NSMutableArray *pickerDataArrayForDecimal;
@property(nonatomic, strong) NSMutableArray *genderArray;
@property(nonatomic, strong) NSMutableArray *heightArray;
@property(nonatomic, strong) NSMutableArray *weightArray;
@property(nonatomic, strong) NSMutableArray *stepsCountArray;
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
    [self initPickerDataArrayForDecimal];
    self.userInfoDataModel = [[ZLUserInfoDataModel alloc] init];
    [self initGenderArray];
    [self initHeightArray];
    [self initWeightArray];
    [self initStepsCountArray];
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
    
    CGPoint orgin = [ZLSystemParameterUtil getMiddlePositionWithViewSize:CGSizeMake(80, 44)
                                                              targetSize:titleBarSize];
    self.completeButton = [[UIButton alloc] initWithFrame:CGRectMake(240, orgin.y+(ceil(zl_statusBarHeight/2.0))-2, 80, 44)];
    [self.completeButton setTitle:@"完成" forState:UIControlStateNormal];
    self.completeButton.backgroundColor = [UIColor clearColor];
    self.completeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.completeButton.titleLabel.textColor = [UIColor whiteColor];
    self.completeButton.titleLabel.font = zl_fontBoldSysteSize(15);
    [self.completeButton addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.completeButton];
    
    UIImage* myImage = [UIImage imageNamed:@"runner"];
    self.imageView = [[UIImageView alloc] initWithImage:myImage];
    self.imageView.frame = CGRectMake(0, ogrinY, [self.imageView zl_width], [self.imageView zl_height]);
    [self addSubview:self.imageView];
    ogrinY += [self.imageView zl_height];
    
    float tableHeigth = kCellHeight * [self.tableCellTitleArray count];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ogrinY, zl_screenWidth, tableHeigth)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    
    self.pickerTitle = [[UILabel alloc] init];
    self.pickerTitle.backgroundColor = [UIColor clearColor];
    self.pickerTitle.numberOfLines = 0;
    self.pickerTitle.font = zl_fontBoldSysteSize(16);
    self.pickerTitle.textColor = [UIColor whiteColor];
    self.pickerTitle.frame = CGRectMake(0,0,320,44);
    
    self.doneButton = [[UIButton alloc] initWithFrame:CGRectMake(240, 0, 80, 44)];
    [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
    self.doneButton.backgroundColor = [UIColor clearColor];
    self.doneButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.doneButton.titleLabel.textColor = [UIColor whiteColor];
    self.doneButton.titleLabel.font = zl_fontBoldSysteSize(15);
    self.doneButton.titleLabel.frame = self.doneButton.bounds;
    [self.doneButton addTarget:self action:@selector(removePickerView) forControlEvents:UIControlEventTouchUpInside];
    
    self.mPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, zl_screenWidth, kPickerViewHeight)];
    self.mPickerView.backgroundColor = [UIColor whiteColor];
    self.mPickerView.delegate = self;
    self.mPickerView.dataSource = self;
    
    self.pickerAndDoneView = [[UIView alloc] initWithFrame:CGRectMake(0, zl_screenHeight, zl_screenWidth, self.doneButton.zl_height+self.mPickerView.zl_height)];
    self.pickerAndDoneView.backgroundColor = [UIColor zl_getColorWithRed:37
                                                                   green:156
                                                                    blue:208
                                                                   alpha:1];
    [self.pickerAndDoneView addSubview:self.pickerTitle];
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

-(void)initPickerDataArrayForDecimal
{
    self.pickerDataArrayForDecimal = [NSMutableArray arrayWithCapacity:10];
    int decimalNumber = 0;
    while (decimalNumber <= 9) {
        [self.pickerDataArrayForDecimal addObject:[NSString stringWithFormat:@"%d",decimalNumber]];
        decimalNumber++;
    }
}

-(void)initGenderArray
{
    self.genderArray = [NSMutableArray arrayWithCapacity:2];
    [self.genderArray addObject:@"男"];
    [self.genderArray addObject:@"女"];
}

-(void)initHeightArray
{
    int height = 120;
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

-(void)initStepsCountArray
{
    int stepsCount = 5000;
    self.stepsCountArray = [NSMutableArray arrayWithCapacity:15];
    while (stepsCount <= 20000) {
        [self.stepsCountArray addObject:[NSString stringWithFormat:@"%d",stepsCount]];
        stepsCount+=1000;
    }
}

-(void)initTableCellTitleArray
{
    self.tableCellTitleArray = @[@"性别",@"身高",@"体重",@"BMI",@"健康体重范围",@"建议标准体重",@"每日目标"];
}

#pragma mark --------------- UITableViewDataSource ---------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableCellTitleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            contentText = [NSString stringWithFormat:@"%.1lf KG(1KG=2斤)",self.userInfoDataModel.weight];
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
        case 6:
        {
            contentText = [NSString stringWithFormat:@"%d 步",self.userInfoDataModel.stepsCountPurpose];
            
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
    
    if(indexPath.row <= 2 || indexPath.row == 6){
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
    self.mPickerView.tag = indexPath.row;
    if(indexPath.row <= 2 || indexPath.row == 6){
        switch (indexPath.row) {
            case 0:
            {
                self.pickerDataArray = self.genderArray;
                [self.mPickerView reloadAllComponents];
                if(self.userInfoDataModel.gender == ZLGenderTypeFemale){
                    [self.mPickerView selectRow:1 inComponent:0 animated:NO];
                }
                [self.pickerTitle setText:@"输入性别"];
            }
                break;
            case 1:
            {
                self.pickerDataArray = self.heightArray;
                [self.mPickerView reloadAllComponents];
                for (NSString *tempHeightStr in self.pickerDataArray) {
                    if(self.userInfoDataModel.height == [tempHeightStr floatValue]){
                        [self.mPickerView selectRow:[self.pickerDataArray indexOfObject:tempHeightStr] inComponent:0 animated:NO];
                    }
                }
                [self.pickerTitle setText:@"输入身高"];
            }
                break;
            case 2:
            {
                self.pickerDataArray = self.weightArray;
                [self.mPickerView reloadAllComponents];
                int weightIntValue = (int)self.userInfoDataModel.weight;
                for (NSString *tempIntStr in self.pickerDataArray) {
                    if(weightIntValue == [tempIntStr intValue]){
                        [self.mPickerView selectRow:[self.pickerDataArray indexOfObject:tempIntStr] inComponent:0 animated:NO];
                    }
                }
                
                int weightDecimalValue = roundf((self.userInfoDataModel.weight - weightIntValue) * 10);
                for (NSString *tempDecimalStr in self.pickerDataArrayForDecimal) {
                    if(weightDecimalValue == [tempDecimalStr intValue]){
                        [self.mPickerView selectRow:[self.pickerDataArrayForDecimal indexOfObject:tempDecimalStr] inComponent:1 animated:NO];
                    }
                }
                [self.pickerTitle setText:@"输入体重"];
            }
                break;
            case 6:
            {
                self.pickerDataArray = self.stepsCountArray;
                [self.mPickerView reloadAllComponents];
                for (NSString *tempStepsCountStr in self.pickerDataArray) {
                    if(self.userInfoDataModel.stepsCountPurpose == [tempStepsCountStr floatValue]){
                        [self.mPickerView selectRow:[self.pickerDataArray indexOfObject:tempStepsCountStr] inComponent:0 animated:NO];
                    }
                }
                [self.pickerTitle setText:@"输入目标步数"];
            }
                break;
            default:
                break;
         }
         CGSize titleSize = [self.pickerTitle.text boundingRectWithSize:CGSizeMake(320, CGFLOAT_MAX)
                                                           withTextFont:self.pickerTitle.font
                                                        withLineSpacing:0];
         CGPoint titleOrgin = [ZLSystemParameterUtil getMiddlePositionWithViewSize:titleSize targetSize:CGSizeMake(320, 44)];
         self.pickerTitle.frame = CGRectMake(titleOrgin.x+5, titleOrgin.y, titleSize.width, titleSize.height);
        [self showPickerView];
    }
}

-(void)showPickerView
{
    [UIView animateWithDuration:.35f animations:^{
        self.pickerAndDoneView.frame = CGRectMake(0, zl_screenHeight-self.mPickerView.zl_height-self.doneButton.zl_height, zl_screenWidth, self.mPickerView.zl_height+self.doneButton.zl_height);
    } completion:^(BOOL finished) {
    }];
    self.tableView.userInteractionEnabled = NO;
}

-(void)removePickerView
{
    [UIView animateWithDuration:.35f animations:^{
        self.pickerAndDoneView.frame = CGRectMake(0, zl_screenHeight, zl_screenWidth, self.mPickerView.zl_height+self.doneButton.zl_height);
    } completion:^(BOOL finished) {
    }];
    [self.tableView reloadData];
    self.tableView.userInteractionEnabled = YES;
}

-(void)removeSelf
{
    [UIView animateWithDuration:.35f animations:^{
        self.frame = CGRectMake(0, zl_screenHeight, zl_screenWidth, zl_screenHeight);
        [ZLUserInfoDataModel writeUserInfoDataModel:self.userInfoDataModel];
        self.editCompleteCallback();
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark --------------- UIPickerViewDataSource ---------------
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(pickerView.tag == 2){
        return 2;
    }else{
        return 1;
    }
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView.tag == 2){
        if(component == 0){
            return [self.pickerDataArray count];
        }else{
            return [self.pickerDataArrayForDecimal count];
        }
    }else{
        return [self.pickerDataArray count];
    }
}

#pragma mark --------------- UIPickerViewDelegate ---------------
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView.tag == 2){
        if(component == 0){
            return [self.pickerDataArray zl_objectAtIndex:row];
        }else{
            return [NSString stringWithFormat:@".%@",[self.pickerDataArrayForDecimal zl_objectAtIndex:row]];
        }
    }else{
        return [self.pickerDataArray zl_objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%@",[self.pickerDataArray zl_objectAtIndex:row]);
    NSString *pickValueStr = nil;
    switch (pickerView.tag) {
        case 0:
            pickValueStr = (NSString *)[self.pickerDataArray zl_objectAtIndex:row];
            self.userInfoDataModel.gender = [pickValueStr isEqualToString:@"男"]?ZLGenderTypeMale:ZLGenderTypeFemale;
            break;
        case 1:
            pickValueStr = (NSString *)[self.pickerDataArray zl_objectAtIndex:row];
            self.userInfoDataModel.height = [pickValueStr floatValue];
            break;
        case 2:
        {
            if (component == 0) {
                pickValueStr = [NSString stringWithFormat:@"%@.%@",[self.pickerDataArray zl_objectAtIndex:row],[self.pickerDataArrayForDecimal objectAtIndex:[pickerView selectedRowInComponent:1]]];
            }else{
                pickValueStr = [NSString stringWithFormat:@"%@.%@",[self.pickerDataArray objectAtIndex:[pickerView selectedRowInComponent:0]],[self.pickerDataArrayForDecimal zl_objectAtIndex:row]];
            }
            NSDecimalNumber *weightNumber = [NSDecimalNumber decimalNumberWithString:pickValueStr];
            self.userInfoDataModel.weight = weightNumber.floatValue;
        }
            break;
        case 6:
            pickValueStr = (NSString *)[self.pickerDataArray zl_objectAtIndex:row];
            self.userInfoDataModel.stepsCountPurpose = [pickValueStr intValue];
            break;
        default:
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if(pickerView.tag == 2){
        if(component == 0){
            return zl_screenWidth - 120;
        }else{
            return 120;
        }
    }else{
        return zl_screenWidth;
    }
}

@end
