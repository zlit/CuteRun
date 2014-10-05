//
//  UIView+CTExtensions.h
//  CTFoundation
//
//  Created by NickJackson on 14-1-21.
//  Copyright (c) 2014年 Ctrip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CTExtensions)

#pragma mark - 视图属性接口
/**
 *  视图左上角x坐标
 *
 *  @return 视图左上角x坐标
 */
- (CGFloat)zl_originX;
/**
 *  视图左上角y坐标
 *
 *  @return 视图左上角y坐标
 */
- (CGFloat)zl_originY;
/**
 *  视图右下角x坐标
 *
 *  @return 视图右下角x坐标
 */
- (CGFloat)zl_bottomX;
/**
 *  视图右下角y坐标
 *
 *  @return 视图右下角y坐标
 */
- (CGFloat)zl_bottomY;
/**
 *  视图宽度
 *
 *  @return 视图宽度
 */
- (CGFloat)zl_width;
/**
 *  视图高度
 *
 *  @return 视图高度
 */
- (CGFloat)zl_height;

/**
 *  设置视图左上角x坐标
 *
 *  @return 视图左上角x坐标
 */
- (void)zl_setOriginX:(CGFloat)originX;
/**
 *  设置视图左上角y坐标
 *
 *  @return 视图左上角y坐标
 */
- (void)zl_setOriginY:(CGFloat)originY;
/**
 *  设置视图右下角x坐标
 *
 *  @return 视图左上角x坐标
 */
- (void)zl_setBottomX:(CGFloat)bottomX;
/**
 *  设置视图右下角y坐标
 *
 *  @return 视图右下角y坐标
 */
- (void)zl_setBottomY:(CGFloat)bottomY;
/**
 *  视图宽度
 *
 *  @param width 视图宽度
 */
- (void)zl_setWidth:(CGFloat)width;
/**
 *  视图高度
 *
 *  @param height 视图高度
 */
- (void)zl_setHeight:(CGFloat)height;

#pragma mark - 坐标点转换
/**
 *  转换当前视图坐标系的点到代理window的坐标系
 *
 *  @param point 点
 *
 *  @return 代理window坐标系上的点
 */
- (CGPoint)zl_convertPointToWindow:(CGPoint)point;
/**
 *  转换代理window坐标系的点到的当前视图坐标系
 *
 *  @param point 点
 *
 *  @return 当前视图坐标系上的点
 */
- (CGPoint)zl_convertPointFromWindow:(CGPoint)point;

#pragma mark - 创建视图
/**
 *  视图创建接口
 *
 *  @param frame 视图frame
 *  @param color 视图背景色
 *
 *  @return 视图对象
 */
+ (UIView *)zl_createViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color;
/**
 *  视图创建接口，背景色默认值透明
 *
 *  @param frame 视图frame
 *
 *  @return 视图对象
 */
+ (UIView *)zl_createViewWithFrame:(CGRect)frame;
/**
 *  通过xib创建视图
 *
 *  @param xibName xib名称
 *  @param owner   owner对象
 *
 *  @return 视图对象
 */
+ (UIView *)zl_createViewWithXibName:(NSString *)xibName owner:(id)owner;

#pragma mark - 删除视图
/**
 *  删除所有子视图
 */
- (void)zl_removeAllSubviews;

#pragma mark - 移动动画
/**
 *  中心点移动动画
 *
 *  @param point      目标中心点
 *  @param duration   动画时间
 *  @param completion 完成后事件block
 */
- (void)zl_moveToCenterPoint:(CGPoint)point duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;
/**
 *  左上角点移动动画
 *
 *  @param point      目标左上角点
 *  @param duration   动画时间
 *  @param completion 完成后事件block
 */
- (void)zl_moveToOriginPoint:(CGPoint)point duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;
/**
 *  视图偏移量移动动画
 *
 *  @param offsetPoint 坐标点偏移量
 *  @param duration    动画时间
 *  @param completion  完成后事件block
 */
- (void)zl_moveWithOffsetPoint:(CGPoint)offsetPoint duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;
@end
