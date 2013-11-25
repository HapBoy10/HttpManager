//
//  ParseDictionaryData.m
//  weave3TI
//
//  Created by macuser01 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ParseDictionaryData.h"

@implementation ObjFieldName

@synthesize key;


- (NSObject* __autoreleasing*) getValue
{
	return value;
}

- (void) setValue:(NSObject * __autoreleasing*) valueAddr
{
	value = valueAddr;
}

//释放内存
- (void)dealloc
{
    [key release];
    [super dealloc];
}

@end

@implementation ParseDictionaryData

//初始化
- (id)init
{
	self=[super init];
    
	if(self)
	{
		/*if (fieldArray != nil) 
		{
			[fieldArray release];
			fieldArray = nil;
		}
		fieldArray=[[NSMutableArray alloc] init];
		[self InitSubFieldName];*/
	}
	
	return self;
}

//读取字典数据
- (id)InitWithDictionary:(NSDictionary *) dicObj
{
	self = [super init];
	if(self)
	{
        if (fieldArray != nil) 
		{
			[fieldArray release];
			fieldArray = nil;
		}
		fieldArray = [[NSMutableArray alloc] init];
		[self InitSubFieldName];
		[self SetDictionary:dicObj];
	}
	
	return self;
}
//设置键值对对象
- (void)InitSubFieldName
{
	
}

//读取字典数据
- (id)SetDictionary:(NSDictionary *) dicObj
{
	for(ObjFieldName * filed in fieldArray)
	{
		NSObject** objValue=[filed getValue];
		
		*objValue=[[dicObj objectForKey:filed.key] retain];
	}
	return self;
}

- (void)dealloc
{
	[fieldArray release];
    [super dealloc];
}
@end
