//
//  NSDictionary+CTExtensions.h
//  CTUtility
//
//  Created by jimzhao on 13-12-11.
//  Copyright (c) 2013年 jimzhao. All rights reserved.
//  类文件说明

#import <Foundation/Foundation.h>

@interface NSDictionary(Object)

/**
 *  Dictionary转换成类。该转化函数支持对象嵌套。
 *  需要转换成的class需要有基类，基类里面必须要有成员变量className，表示该类类名。
 *  NOTE:建议baseClass为CTJSONObject，需要转换的类继承该基类
 *
 *  @param cls       需要被转化成功的类的类名
 *  @param baseClass 需要被转换类的基类
 *
 *  @return Dictionary对应的类
 */
- (id)zl_toObject:(Class)classz baseClass:(Class)baseClass;

/**
 *  对象转化成字符串，不做嵌套对象/容器内对象的转换
 *  参考NSObject扩展，字符串转化成对象- (id)zl_toSimpleDictionary;
 *
 *  @return 对象对应的字符串
 */

- (id)zl_toSimpleObject:(Class)classz;

@end


@interface NSMutableDictionary(Safe)

/**
 *  扩展系统的set方法，如果传人nil或者NULL则为删除相应key值的对象，并且检测了key值必须遵循NSCopy协议
 *
 *  @param anObject 传人对象
 *  @param aKey     key
 */
- (void)zl_setObject:(id)anObject forKey:(id)aKey;

@end