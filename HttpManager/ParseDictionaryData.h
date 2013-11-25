//
//  ParseDictionaryData.h
//  weave3TI
//
//  Created by macuser01 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjFieldName : NSObject
{
	NSString		*key;
	NSObject		* __autoreleasing*value;
}	

@property (nonatomic,retain)NSString	*key;

- (NSObject* __autoreleasing*) getValue;
- (void) setValue:(NSObject * __autoreleasing*) valueAddr;

@end


@interface ParseDictionaryData : NSObject {
	NSMutableArray		*fieldArray;
}
//初始化
- (id)init;
//读取字典数据
- (id)InitWithDictionary:(NSDictionary *) dicObj;
//设置键值对对象
- (void)InitSubFieldName;
//读取字典数据
- (id)SetDictionary:(NSDictionary *) dicObj;


@end
