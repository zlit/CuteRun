//
//  FileUtil.h
//  CtripTest
//
//  Created by ctrip ctrip on 12-8-29.
//  Copyright (c) 2012年 1234cc. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 文件操作相关的方法 */
@interface FileUtil : NSObject

/** 初始化的方法 */
+ (FileUtil *) shareInstance;

/**
 获取文件的路径
 @param fileName 文件名
 @return 组成的文件名
 */
+ (NSString *) dataFilePath:(NSString *)fileName;

/**
 判断文件是否存在
 @param 判断文件名是否存在
 @return YES存在 NO不存在
 */
+ (BOOL) isExistsFilePath:(NSString *)filePath;

/***
 根据路径创建文件(如果存在就直接覆盖)
 @param 文件路径
 */
+(void) createFileWithFilePath:(NSString *)filePath;

/**
 根据文件路径删除文件
 @param filePath 文件路径
 */
+(bool) deleteFileWithFilePath:(NSString *)filePath;

/***
 获取文件大小,失败返回0
 @param filePath 文件路径
 @return 文件的大小
 */
+(unsigned long long)getFileSizeWithFilePath:(NSString *)filePath;

//@"coreMotionLog.txt"
+(void)writeLogWithContent:(NSString *) content
                  fileName:(NSString *) fileName
               isOverWrite:(BOOL) isOverWrite;

/**
 读取string 
 @param filePath 文件路径
 @return 文件的内容
 */
+ (NSString *) readWithContentsOfFile:(NSString *)filePath;

/**
 读取文件内容到 NSData 中
 @param filePath 文件路径
 @return NSData 
 */
+ (NSData *) dataWithContentsOfFile:(NSString *)filePath;

/***
 写字符串 到文件
 @param content 文件内容
 @param filePath 文件目录
 @return 成功与否
 */
+ (bool) writeContent:(NSString *)content
                filePath:(NSString *)filePath;

/**
 追加字符串 到文件
 @param content 文件内容
 @param filePath 文件目录
 @return 成功与否
 */
+ (BOOL) writeAppendContent:(NSString *)content
                   filePath:(NSString *)filePath;

/**
 写文件
 @param data 文件内容
 @param filePath 文件目录
 @return 成功与否
 */
+ (bool) writeData:(NSData *)data
             filePath:(NSString *)filePath;

/**
 追加文件
 @param data 文件内容
 @param filePath 文件目录
 */
+ (void) writeAppendData:(NSData *)data
                filePath:(NSString *)filePath;

@end
