//
//  NSString+CTExtensions.h
//  CTUtility
//
//  Created by jimzhao on 13-12-11.
//  Copyright (c) 2013年 jimzhao. All rights reserved.
//  NSString 扩展

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** NSString_CTExtensions类说明 */

#pragma mark - String Utils

@interface NSString(Utils)

/**
 *  @brief 判断当前字符串中是否包含子串
 *
 *  @param string 需要检查的子串
 *
 *  @return 如果当前字符串中包含子串，返回true，否则false
 */
- (BOOL)zl_containsString:(NSString *)string;

/**
 *  判断当前字符串中是否包含子串,不区分大小写
 *
 *  @param string  需要检查的子串
 *
 *  @return 如果当前字符串中包含子串，返回true，否则false
 */
- (BOOL)zl_containsStringIgnoreCase:(NSString *)string;


/**
 *  生成UUID
 *
 *  @return 生成的UUID字符串
 */
+ (NSString *)zl_UUIDString;

/**
 *  删除字符串前面的空白
 *
 *  @return 删除前面空白的字符串
 */
- (NSString *)zl_trimPrefixBlank;

/**
 *  删除字符串后面的空白
 *
 *  @return 被删末尾空格的字符串
 */
- (NSString *)zl_trimSufixBlank;

/**
 *  删除首尾的空白字符串
 *
 *  @return 首尾字符串被删除的字符串
 */
- (NSString *)zl_trimBlank;


+ (BOOL)zl_isEmpty:(NSString *)str;

- (BOOL)zl_isNumber;

/**
 *  判断字符串中是否全部是ASCII码
 *
 *  @return 全部ASCII，返回YES，否则返回NO
 */
- (BOOL)zl_isASCII;

/**
 *  判断是否是合法的Email地址
 *
 *  @return email合法返回YES，否则返回NO
 */
- (BOOL)zl_isLegalEmail;

/**
 *  判断是否是合法手机号码，格式：13，14，15，18开头，且为11位数字
 *
 *  @return 手机号码合法返回YES，否则返回NO
 */
- (BOOL)zl_isLegalMobilePhone;

/**
 *  包装SDK的characterAtIndex:
 *
 *  @param index
 *
 *  @return 返回字符
 */
- (unichar)zl_characterAtIndex:(NSUInteger)index;

/**
 *  包装SDK的substringFromIndex:
 *
 *  @param from
 *
 *  @return 返回sub的字符串
 */
- (NSString *)zl_subStringFromIndex:(NSUInteger)from;

/**
 *  包装SDK的substringToIndex:
 *
 *  @param to
 *
 *  @return 返回sub的字符串
 */
- (NSString *)zl_subStringToIndex:(NSUInteger)to;

/**
 *  包装SDK的substringWithRange:
 *
 *  @param range
 *
 *  @return 返回sub的字符串
 */
- (NSString *)zl_subStringWithRange:(NSRange)range;

/**
 *  字符串转换成UTF8编码的Data
 *
 *  @return UTF8编码之后的Data
 */
- (NSData *)zl_UTF8Data;

@end

#pragma mark - String URL相关

@interface NSString(URL)

/**
 *  字符串转换成URL对象，#会在内部处理
 *
 *  @return 转换成的URL对象
 */
- (NSURL *)zl_toURL;

/**
 *  对URL做UTF8编码
 *
 *  @return UTF8编码之后的URL字符串
 */
- (NSString *)zl_URLEncode;

/**
 *  对URL做UTF8解码
 *
 *  @return UTF8解码之后的URL字符串
 */
- (NSString *)zl_URLDecode;

@end

#pragma mark - String Hash相关

@interface NSString(Hash)


/**
 * @brief 计算NSString的MD5哈希函数
 *
 * @return 返回NSString的MD5哈希值，长度32，大写
 */
- (NSString *)zl_MD5;

/**
 * @brief 计算NSString的SHA1哈希函数
 *
 * @return 返回NSString的SHA1哈希值，长度40，大写
 */
- (NSString *)zl_SHA1;

/**
 * @brief 计算NSString的SHA256哈希函数
 *
 * @return 返回NSString的SHA256哈希值，长度64，大写
 */
- (NSString *)zl_SHA256;

@end

#pragma mark - String Base64 Encode/Decode

@interface NSString(Base64)

/**
 *  将字符串进行base64 编码
 *
 *  @return base64编码之后的字符串
 */
- (NSString *)zl_Base64EncodeToString;

/**
 *  字符串base64解码成字符串
 *
 *  @param base64String 需要解码的base64字符串
 *
 *  @return 解码之后的base64字符串
 */
- (NSString *)zl_Base64DecodeToString;

/**
 *  将base64字符串解码成Data
 *
 *  @return base64字符串解码之后的Data
 */
- (NSData *)zl_Base64DecodeToData;

@end

@interface NSString(File_UTF8)

- (BOOL)zl_appendToFile:(NSString *)path;

- (BOOL)zl_writeToFile:(NSString *)path;

@end

@interface NSString(Serialize)

/**
 *  字符串转换成对象，不做嵌套对象/容器内对象的转换
 *  参考NSObject扩展，- (NSString *)zl_toSimpleString;
 *  @param cls 转换成的对象类型
 *
 *  @return 字符串对应的对象
 */
- (id)zl_toSimpleObject:(Class)classz;

-(NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font
                                                withLineSpacing:(CGFloat)lineSpacing;

-(CGSize)boundingRectWithSize:(CGSize)size
                 withTextFont:(UIFont *)font
              withLineSpacing:(CGFloat)lineSpacing;

@end