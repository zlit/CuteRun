//
//  NSString+CTExtensions.m
//  CTUtility
//
//  Created by jimzhao on 13-12-11.
//  Copyright (c) 2013年 jimzhao. All rights reserved.
//  类文件说明

#import "NSString+CTExtensions.h"
#import "NSData+CTExtensions.h"
#import "Foundation+CTExtentions.h"
#import "NSData+CTExtensions.h"

#pragma mark - String Utils

@implementation NSString(Utils)

/**
 *  @brief 判断当前字符串中是否包含子串
 *
 *  @param string 需要检查的子串
 *
 *  @return 如果当前字符串中包含子串，返回true，否则false
 */
- (BOOL)zl_containsString:(NSString *)string {
    if (string.length == 0) {
        return NO;
    }
    
	return !NSEqualRanges([self rangeOfString:string], NSMakeRange(NSNotFound, 0));
}

- (BOOL)zl_containsStringIgnoreCase:(NSString *)string {
    return [[self uppercaseString] zl_containsString:[string uppercaseString]];
}

/**
 *  生成UUID
 *
 *  @return 生成的UUID字符串
 */
+ (NSString *)zl_UUIDString {
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, uuid);
	CFRelease(uuid);
	return (__bridge_transfer NSString *)string;
}

/**
 *  删除字符串前面的空白
 *
 *  @return 删除前面空白的字符串
 */
- (NSString *)zl_trimPrefixBlank {
    NSString *result = nil;
    
    NSInteger i = 0;
    NSInteger length = [self length];
    
    while (i < length) {
        char ch = [self characterAtIndex:i];
        if (ch == ' ' || ch == '\r' || ch == '\n' || ch == '\t') {
            ++i;
        }
        else {
            break;
        }
    }
    
    if (i < length) {
        result = [self substringFromIndex:i];
    }
    
    return result;
}



/**
 *  删除字符串后面的空白
 *
 *  @return 被删末尾空格的字符串
 */
- (NSString *)zl_trimSufixBlank {
    NSString *result = NULL;
    
    NSInteger i = [self length];
    
    while (i >= 0) {
        char ch = [self characterAtIndex:i-1];
        if (ch == ' ' || ch == '\r' || ch == '\n' || ch == '\t') {
            --i;
        }
        else {
            break;
        }
    }

    i = MAX(0, i);
    
    result = [self substringToIndex:i];
    
    return result;
}


- (NSString *)zl_trimBlank {
   return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL)zl_isEmpty:(NSString *)str {
    return str == NULL || [str isEqual:[NSNull null]] || str.length == 0;
}

- (BOOL)zl_isNumber {
    int dotCount = 0;
    BOOL isLeagalNum = YES;
    
    for (NSUInteger i = 0; i < self.length; i++) {
        unichar cha = [self characterAtIndex:i];
        if (cha == '.') {
            dotCount++;
            if (dotCount >= 2) {
                isLeagalNum = NO;
                break;
            }
        }
        else if (cha >= '0' && cha <= '9') {
            ;
        }
        else {
            isLeagalNum = NO;
            break;
        }
        
    }
    
    return isLeagalNum;
}


/**
 *  判断字符串中是否全部是ASCII码
 *
 *  @return 全部ASCII，返回YES，否则返回NO
 */
- (BOOL)zl_isASCII {
    
    const char *utf8Str = [self UTF8String];
    for (int i = 0; i < strlen(utf8Str); i++) {
        char ch = utf8Str[i];
        bool flag = isascii(ch);
        if (!flag) {
            return NO;
        }
    }
    return YES;
}

/**
 *  判断是否是合法的Email地址
 *
 *  @return email合法返回YES，否则返回NO
 */
- (BOOL)zl_isLegalEmail {
    if ([self zl_containsString:@"@"] && [self zl_containsString:@"."]) {
//        NSString *emailRegex = @"^[A-Za-z0-9d]+([-_.]*[A-Za-z0-9d]*)*@([A-Za-z0-9d]+[-_.]+[A-Za-z0-9d]*)+[A-Za-z0-9d]{2,5}$";
//        NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//        return [emailPredicate evaluateWithObject:self];
        return YES;
    }
    
    return NO;
}

/**
 *  判断是否是合法手机号码，格式：13，14，15，18开头，且为11位数字
 *
 *  @return 手机号码合法返回YES，否则返回NO
 */
- (BOOL)zl_isLegalMobilePhone {
    if (self.length == 0 || [self length] > 16) {
        return NO;
    }
    
    NSString *phoneRegex = @"^(1([3458][0-9]))\\d{8}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL matches = [test evaluateWithObject:self];
    return matches;
}

/**
 *  包装SDK的characterAtIndex:
 *
 *  @param index
 *
 *  @return 返回字符
 */
- (unichar)zl_characterAtIndex:(NSUInteger)index
{
    if (index < self.length) {
        return [self characterAtIndex:index];
    }
    else
    {
        NSAssert(1, @"Error:length:%ld index:%ld", (unsigned long)self.length, (unsigned long)index);
        return (unichar)-1;
    }
}

/**
 *  包装SDK的subStringFromIndex:
 *
 *  @param from
 *
 *  @return 返回sub的字符串
 */
- (NSString *)zl_subStringFromIndex:(NSUInteger)from
{
    if (from <= self.length) {
        return [self substringFromIndex:from];
    }
    else
    {
        NSAssert(YES, @"Error:length:%lu from:%lu", (unsigned long)self.length, (unsigned long)from);
        return nil;
    }
}

/**
 *  包装SDK的substringToIndex:
 *
 *  @param to
 *
 *  @return 返回sub的字符串
 */
- (NSString *)zl_subStringToIndex:(NSUInteger)to
{
    if (to <= self.length) {
        return [self substringToIndex:to];
    }
    else
    {
        NSAssert(YES, @"Error:length:%lu to:%ld", (unsigned long)self.length, (unsigned long)to);
        return nil;
    }
}
/**
 *  包装SDK的subStringWithRange:
 *
 *  @param range
 *
 *  @return 返回sub的字符串
 */
- (NSString *)zl_subStringWithRange:(NSRange)range
{
    if (range.location+range.length <= self.length) {
        return [self substringWithRange:range];
    }
    else
    {
        NSAssert(YES, @"Error:length:%lu Range(%ld,%ld)", (unsigned long)self.length, (unsigned long)range.location, (unsigned long)range.length);
        return nil;
    }
}

- (NSData *)zl_UTF8Data {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

@end


#pragma mark - String URL相关

@implementation NSString(URL)

/**
 *  URL参数转义，空格会换成+
 *
 *  @return 转义之后的URL字符串
 */
- (NSString *)zl_escapingForURLQuery {
	NSString *result = self;
    
	static CFStringRef leaveAlone = CFSTR(" ");
	static CFStringRef toEscape = CFSTR("\n\r:/=,!$&'()*+;[]@#?%");
    
	CFStringRef escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, leaveAlone,
																	 toEscape, kCFStringEncodingUTF8);
    
	if (escapedStr) {
		NSMutableString *mutable = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
		CFRelease(escapedStr);
        
		[mutable replaceOccurrencesOfString:@" " withString:@"+" options:0 range:NSMakeRange(0, [mutable length])];
		result = mutable;
	}
	return result;  
}

/**
 *  转义之后的URL参数还原，+会被还原成空格
 *
 *  @return 还原之后URL参数
 */
- (NSString *)zl_unEscapingFromURLQuery {
	NSString *deplussed = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [deplussed stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

/**
 *  字符串转换成URL对象，#会在内部处理
 *
 *  @return 转换成的URL对象
 */
- (NSURL *)zl_toURL {
    if (self.length == 0) {
        return NULL;
    }
    
    NSString *tmpUrl = self;
    
    tmpUrl = [tmpUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSRange sRange = [tmpUrl rangeOfString:@"#"] ;
    
    NSString *retUrlStr = tmpUrl;
    
    if (sRange.location != NSNotFound) {
        NSString *prefix = [[tmpUrl substringToIndex:sRange.location] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url  = [NSURL URLWithString:prefix];
        
        NSString *sufix = [[tmpUrl substringFromIndex:sRange.location+1] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        retUrlStr= [[url absoluteString] stringByAppendingFormat:@"#%@",sufix];
    }
    else {
        retUrlStr = [retUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return [NSURL URLWithString:retUrlStr];

}

/**
 *  对URL做UTF8编码
 *
 *  @return UTF8编码之后的URL字符串
 */
- (NSString *)zl_URLEncode {
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

/**
 *  对URL做UTF8解码
 *
 *  @return UTF8解码之后的URL字符串
 */
- (NSString *)zl_URLDecode {
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end

#pragma mark - String Hash相关

@implementation NSString(Hash)

/**
 * @brief 计算NSString的MD5哈希函数
 *
 * @return 返回NSString的MD5哈希值，长度32，大写
 */
- (NSString *)zl_MD5 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:self.length];
	return [data zl_MD5];
}

/**
 * @brief 计算NSString的SHA1哈希函数
 *
 * @return 返回NSString的SHA1哈希值，长度40，大写
 */
- (NSString *)zl_SHA1 {
	const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:self.length];
	return [data zl_SHA1];
}

/**
 * @brief 计算NSString的SHA256哈希函数
 *
 * @return 返回NSString的SHA256哈希值，长度64，大写
 */
- (NSString *)zl_SHA256 {
	const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:self.length];
	return [data zl_SHA256];
}


@end

#pragma mark - String Base64 Encode/Decode

@implementation NSString(Base64)

/**
 *  将字符串进行base64 编码
 *
 *  @return base64编码之后的字符串
 */
- (NSString *)zl_Base64EncodeToString  {
    if ([self length] == 0) {
        return nil;
	}
	
	return [[self dataUsingEncoding:NSUTF8StringEncoding] zl_base64EncodeToString];
}

/**
 *  字符串base64解码成字符串
 *
 *  @param base64String 需要解码的base64字符串
 *
 *  @return 解码之后的base64字符串
 */
- (NSString *)zl_Base64DecodeToString {
    NSData *decodeData = [NSData zl_base64DecodeToData:self];
	return [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
}

/**
 *  将base64字符串解码成Data
 *
 *  @return base64字符串解码之后的Data
 */
- (NSData *)zl_Base64DecodeToData {
    return [NSData zl_base64DecodeToData:self];
}

-(NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font
                                                withLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [self length])];
    return attributedStr;
}

-(CGSize)boundingRectWithSize:(CGSize)size
                 withTextFont:(UIFont *)font
              withLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedText = [self attributedStringFromStingWithFont:font
                                                                        withLineSpacing:lineSpacing];
    CGSize textSize = [attributedText boundingRectWithSize:size
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil].size;
    CGSize sizeNew = CGSizeMake(ceilf(textSize.width) , ceilf(textSize.height));
    return sizeNew;
}

@end
