//
//  FileUtil.m
//  CtripTest
//
//  Created by ctrip ctrip on 12-8-29.
//  Copyright (c) 2012年 1234cc. All rights reserved.
//

#import "FileUtil.h"

static NSDateFormatter *dateFormater = nil;

@implementation FileUtil

static FileUtil *fileUtilInstance = nil;

// 初始化方法
- (id)init
{
    self = [super init];
    
    if(self)
    {
    }

    return self;
}

// 初始化的方法
+ (FileUtil *) shareInstance;
{
    @synchronized(self) 
    {
        if(!fileUtilInstance)
        {
            fileUtilInstance = [[FileUtil alloc] init];

        }
    }
    
    return fileUtilInstance;
}

//@"coreMotionLog.txt"
+(void)writeLogWithContent:(NSString *) content
                  fileName:(NSString *) fileName
               isOverWrite:(BOOL) isOverWrite
{
    if(dateFormater == nil){
        NSString *format = @"yyyy/MM/dd/ HH:mm:ss";
        dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:format];
    }
    NSLog(@"%@",content);
    NSString *filePath = [FileUtil dataFilePath:fileName];
  
    NSString *contentWithDate = [NSString stringWithFormat:@"%@ - %@\n",[dateFormater stringFromDate:[NSDate date]],content];
    
    if([FileUtil isExistsFilePath:filePath] && isOverWrite == NO){
        [FileUtil writeAppendContent:contentWithDate filePath:filePath];
    }else{
        [FileUtil writeContent:contentWithDate filePath:filePath];
    }
}

// 获取文件的路径
+ (NSString *) dataFilePath:(NSString *)fileName
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentPath = [path objectAtIndex:0];

    return [documentPath stringByAppendingPathComponent:fileName];
}

// 判断文件是否存在
+ (BOOL) isExistsFilePath:(NSString *)filePath
{
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        return YES;
    }
    
    return NO;
}

// 根据路径创建文件
+(void) createFileWithFilePath:(NSString *)filePath
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 如果文件存在, 则删除文件
    if([FileUtil isExistsFilePath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    // 创建文件
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
}


// 根据路径创建文件
+(bool) deleteFileWithFilePath:(NSString *)filePath
{
//    TLog(@"deleteFileWithFilePath: %@", filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];

    // 如果文件存在, 则删除文件
    if([FileUtil isExistsFilePath:filePath])
    {
//        TLog(@"if([FileUtil isExistsFilePath:%@])", filePath);

        return [fileManager removeItemAtPath:filePath error:nil];
    }
    return false;
}

//获取文件大小,失败返回0
+(unsigned long long)getFileSizeWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 如果文件存在, 则删除文件
    if([FileUtil isExistsFilePath:filePath])
    {
        NSError *error = nil;
        NSDictionary* fileAttrDic = [fileManager attributesOfItemAtPath:filePath error:&error];
        if(fileAttrDic != nil){
            return [fileAttrDic fileSize];
        }else{
//            CLog(@"获取文件大小失败 description %@, failureReason %@",[error localizedDescription],[error localizedFailureReason]);
            return 0;
        }
    }else{
        return 0;
    }
}

// 读取string 
+ (NSString *) readWithContentsOfFile:(NSString *)filePath
{
    NSString *str = @"";
    
    if([FileUtil isExistsFilePath:filePath])
    {
        str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];;
    }
    
    return str;
}

// 读取文件
+ (NSData *) dataWithContentsOfFile:(NSString *)filePath
{
    NSData *data = nil;
    
    if([FileUtil isExistsFilePath:filePath])
    {
        data = [NSData dataWithContentsOfFile:filePath];
    }
    
    return data;
}

// 写字符串 到文件
+ (bool) writeContent:(NSString *)content filePath:(NSString *)filePath
{
    bool isSuccess = false;
    
    if(content != nil)
    {
       isSuccess = [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }

    return isSuccess;
}

// 追加字符串 到文件
+ (BOOL) writeAppendContent:(NSString *)content filePath:(NSString *)filePath
{
    if(content != nil && filePath.length > 0)
    {
        NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
        // 取得修改的文件句柄
        NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        
        // 移动指针到文件末尾
        [fileHandler seekToEndOfFile];
        
        // 追加内容
        [fileHandler writeData:contentData];
        return YES;
    }
    return NO;
}

// 写文件
+ (bool) writeData:(NSData *)data filePath:(NSString *)filePath
{
    bool isSuccess = false;
    
    if(data != nil)
    {
        isSuccess = [data writeToFile:filePath atomically:YES];
    }
    
    return isSuccess;
}

// 追加文件
+ (void) writeAppendData:(NSData *)data filePath:(NSString *)filePath
{
    if(data != nil)
    {
        // 取得修改的文件句柄
        NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];

        // 移动指针到文件末尾
        [fileHandler seekToEndOfFile];
        
        // 追加内容
        [fileHandler writeData:data];
    }
}

@end
