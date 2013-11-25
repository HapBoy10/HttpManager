//
//  NodeDataClass.m
//  weave3TI
//
//  Created by macuser01 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "NodeDataClass.h"

//添加字段宏定义
#define ADD_FIELD(fn,strFn) ObjFieldName * filed_##fn=[[ObjFieldName alloc] init]; \
filed_##fn.key=strFn;							\
[filed_##fn setValue:&fn];						\
[fieldArray addObject:filed_##fn]; \
[filed_##fn release];

@implementation NodeDataClass
-(void)dealloc
{
    [super dealloc];
}
@end

@implementation PlanImageInfo
@synthesize _id,updated_at;

- (void)InitSubFieldName
{
    ADD_FIELD(_id,@"_id");
    ADD_FIELD(updated_at,@"updated_at");
}

-(void)dealloc
{
    
    [_id release];
    [updated_at release];
    
	[super dealloc];
}
@end

@implementation LoginUserInfo
@synthesize userId,userImg,username,basePath,score,star,session_id,abilityCount;

- (void)InitSubFieldName
{
    ADD_FIELD(userId,@"userId");
    ADD_FIELD(userImg,@"userImg");
    ADD_FIELD(username,@"username");
    ADD_FIELD(basePath,@"basePath");
    ADD_FIELD(score,@"score");
    ADD_FIELD(star,@"star");
    ADD_FIELD(session_id,@"session_id");
    ADD_FIELD(abilityCount,@"abilityCount");
}

-(void)dealloc
{
    [userId release];
    [userImg release];
    [username release];
    [basePath release];
    [score release];
    [star release];
    [session_id release];
    [abilityCount release];
    
	[super dealloc];
}
@end

@implementation TrainPlanListInfo
@synthesize planId,planImg,planName,planStartTime,planEndTime,planCount,planunsrc,planUnread,planDesc,planType;

- (void)InitSubFieldName
{
    ADD_FIELD(planId,@"planId");
    ADD_FIELD(planImg,@"planImg");
    ADD_FIELD(planName,@"planName");
    ADD_FIELD(planStartTime,@"planStartTime");
    ADD_FIELD(planEndTime,@"planEndTime");
    ADD_FIELD(planCount,@"planCount");
    ADD_FIELD(planunsrc,@"planunsrc");
    ADD_FIELD(planUnread,@"planUnread");
    ADD_FIELD(planDesc,@"desc");
    ADD_FIELD(planType,@"planType");
}

-(void)dealloc
{
    [planId release];
    [planImg release];
    [planName release];
    [planStartTime release];
    [planEndTime release];
    [planCount release];
    [planunsrc release];
    [planUnread release];
    [planDesc release];
    [planType release];
    
	[super dealloc];
}
@end

@implementation KnowlegeMyListInfo
@synthesize knowledgeId,knowledgeName,knowledgeContent,knowledgeTime,className,knowledgeReadCount,knowledgeUpCount,categoryThree,knowledgeFavoriteCount,knowledgeType,knowledgeSource,Knowledgeimage,knowledgeEditer,knowledgeIsFavorite,categoryKnowledgename,ablityEditor,categoryKnowledgeid,path,resolution,smallImg,typeImg,knowledgeIsPraise,top,abilityName,abilityCode;

- (void)InitSubFieldName
{
    ADD_FIELD(abilityCode,@"abilityCode");
    ADD_FIELD(abilityName,@"abilityName");
    ADD_FIELD(top,@"top");
    ADD_FIELD(path,@"path");
    ADD_FIELD(resolution,@"resolution");
    ADD_FIELD(smallImg,@"smallImg");
    ADD_FIELD(typeImg,@"typeImg");
    ADD_FIELD(knowledgeId,@"knowledgeId");
    ADD_FIELD(knowledgeName,@"knowledgeName");
    ADD_FIELD(knowledgeContent,@"knowledgeContent");
    ADD_FIELD(knowledgeTime,@"knowledgeTime");
    ADD_FIELD(className,@"className");
    ADD_FIELD(knowledgeReadCount,@"knowledgeReadCount");
    ADD_FIELD(knowledgeUpCount,@"knowledgeUpCount");
    ADD_FIELD(categoryThree,@"categoryThree");
    ADD_FIELD(knowledgeFavoriteCount,@"knowledgeFavoriteCount");
    ADD_FIELD(knowledgeType,@"knowledgeType");
    ADD_FIELD(knowledgeSource,@"knowledgeSource");
    ADD_FIELD(Knowledgeimage,@"Knowledgeimage");
    ADD_FIELD(knowledgeEditer,@"knowledgeEditer");
    ADD_FIELD(knowledgeIsFavorite,@"knowledgeIsFavorite");
    ADD_FIELD(categoryKnowledgename,@"categoryKnowledgename");
    ADD_FIELD(ablityEditor,@"ablityEditor");
    ADD_FIELD(categoryKnowledgeid,@"categoryKnowledgeid");
    ADD_FIELD(knowledgeIsPraise,@"knowledgeIsPraise");
}

-(void)dealloc
{
    [abilityName release];
    [abilityCode release];
    [top release];
    [knowledgeIsPraise release];
    [path release];
    [resolution release];
    [smallImg release];
    [typeImg release];
    [knowledgeId release];
    [knowledgeName release];
    [knowledgeContent release];
    [knowledgeTime release];
    [className release];
    [knowledgeReadCount release];
    [knowledgeUpCount release];
    [categoryThree release];
    [knowledgeFavoriteCount release];
    [knowledgeType release];
    [knowledgeSource release];
    [Knowledgeimage release];
    [knowledgeEditer release];
    [knowledgeIsFavorite release];
    [categoryKnowledgename release];
    [ablityEditor release];
    [categoryKnowledgeid release];
    
	[super dealloc];
}
@end


@implementation AbilityListInfo
@synthesize code,name,state;

- (void)InitSubFieldName
{
    ADD_FIELD(code,@"code");
    ADD_FIELD(name,@"name");
    ADD_FIELD(state,@"state");
}

-(void)dealloc
{
    [code release];
    [name release];
    [state release];
    
	[super dealloc];
}
@end

@implementation CoretypeInfo
@synthesize code,name,_id,img;

- (void)InitSubFieldName
{
    ADD_FIELD(code,@"code");
    ADD_FIELD(name,@"name");
    ADD_FIELD(_id,@"id");
    ADD_FIELD(img,@"img");
}

-(void)dealloc
{
    [code release];
    [name release];
    [_id release];
    [img release];
	[super dealloc];
}
@end


@implementation CommentListInfo
@synthesize commentContent,commentId,commentTime,commentUserImg,commentUsername,parent,_child,children,anonymous,top;

- (void)InitSubFieldName
{
    ADD_FIELD(commentContent,@"commentContent");
    ADD_FIELD(commentId,@"commentId");
    ADD_FIELD(commentTime,@"commentTime");
    ADD_FIELD(commentUserImg,@"commentUserImg");
    ADD_FIELD(commentUsername,@"commentUsername");
    ADD_FIELD(parent,@"parent");
    ADD_FIELD(_child,@"_child");
    ADD_FIELD(children,@"children");
    ADD_FIELD(anonymous,@"anonymous");
    ADD_FIELD(top,@"top");
}

-(void)dealloc
{
    [top release];
    [anonymous release];
    [commentContent release];
    [commentId release];
    [commentTime release];
    [commentUserImg release];
    [commentUsername release];
    [parent release];
    [_child release];
    [children release];
    
	[super dealloc];
}
@end

@implementation ExploreListInfo
@synthesize code,image,resolution,name,bLocal;

- (void)InitSubFieldName
{
    ADD_FIELD(code,@"code");
    ADD_FIELD(image,@"image");
    ADD_FIELD(resolution,@"resolution");
    ADD_FIELD(name,@"name");
}

-(void)dealloc
{
    [bLocal release];
    [code release];
    [image release];
    [resolution release];
    [name release];
	[super dealloc];
}
@end

@implementation AnswerListInfo
@synthesize _id,img,question,anwser,knowledge_name,lession_name,categoryKnowledgename,coretype_name,userName,createTime,categoryKnowledgecode;

- (void)InitSubFieldName
{
    ADD_FIELD(_id,@"id");
    ADD_FIELD(img,@"coretype_img");
    ADD_FIELD(question,@"question");
    ADD_FIELD(anwser,@"answer");
    ADD_FIELD(knowledge_name,@"knowledge_name");
    ADD_FIELD(lession_name,@"lession_name");
    ADD_FIELD(categoryKnowledgename,@"categoryKnowledgename");
    ADD_FIELD(categoryKnowledgecode,@"categoryKnowledgeid");
    ADD_FIELD(coretype_name,@"coretype_name");
    ADD_FIELD(userName,@"userName");
    ADD_FIELD(createTime,@"createTime");
}

-(void)dealloc
{
    [categoryKnowledgecode release];
    [_id release];
    [img release];
    [question release];
    [anwser release];
    [knowledge_name release];
    [lession_name release];
    [categoryKnowledgename release];
    [coretype_name release];
    [userName release];
    [createTime release];
	[super dealloc];
}
@end

@implementation SearchModelListInfo
@synthesize code,image;

- (void)InitSubFieldName
{
    ADD_FIELD(code,@"code");
    ADD_FIELD(image,@"img");

}

-(void)dealloc
{
    [code release];
    [image release];

	[super dealloc];
}
@end

@implementation SearchTagListInfo
@synthesize tagName;

- (void)InitSubFieldName
{
    ADD_FIELD(tagName,@"tagName");
}

-(void)dealloc
{
    [tagName release];

	[super dealloc];
}
@end

@implementation QAModelListInfo
@synthesize code,name;

- (void)InitSubFieldName
{
    ADD_FIELD(code,@"code");
    ADD_FIELD(name,@"name");
}

-(void)dealloc
{
    [code release];
    [name release];
    
	[super dealloc];
}
@end


@implementation CaseDiscussListInfo
@synthesize _id,topic_content,topic_name,create_time,comment,create_user,start_time,end_time,master,resouce,type,small_img,resolution,item_count;

- (void)InitSubFieldName
{
    ADD_FIELD(_id,@"id");
    ADD_FIELD(topic_name,@"topic_name");
    ADD_FIELD(topic_content,@"topic_content");
    ADD_FIELD(create_time,@"create_time");
    ADD_FIELD(comment,@"comment");
    ADD_FIELD(create_user,@"create_user");
    ADD_FIELD(start_time,@"start_time");
    ADD_FIELD(end_time,@"end_time");
    ADD_FIELD(master,@"master");
    ADD_FIELD(resouce,@"resouce");
    ADD_FIELD(type,@"type");
    ADD_FIELD(small_img,@"small_img");
    ADD_FIELD(resolution,@"resolution");
    ADD_FIELD(item_count,@"item_count");
}

-(void)dealloc
{
    [type release];
    [small_img release];
    [resolution release];
    [item_count release];
    [_id release];
    [topic_name release];
    [topic_content release];
    [create_time release];
    [comment release];
    [create_user release];
    [start_time release];
    [end_time release];
    [master release];
    [resouce release];
	[super dealloc];
}
@end

@implementation CaseCommentListInfo
@synthesize _id,item_content,user_id,parent,type,create_time,ent,topic_id,top,user_icon,user_name,children;

- (void)InitSubFieldName
{
    ADD_FIELD(_id,@"id");
    ADD_FIELD(item_content,@"item_content");
    ADD_FIELD(user_id,@"user_id");
    ADD_FIELD(parent,@"parent");
    ADD_FIELD(type,@"type");
    ADD_FIELD(create_time,@"create_time");
    ADD_FIELD(ent,@"ent");
    ADD_FIELD(topic_id,@"topic_id");
    ADD_FIELD(top,@"top");
    ADD_FIELD(user_icon,@"user_icon");
    ADD_FIELD(user_name,@"user_name");
    ADD_FIELD(children,@"children");
    
}

-(void)dealloc
{
    [children release];
    [_id release];
    [item_content release];
    [user_id release];
    [parent release];
    [type release];
    [create_time release];
    [ent release];
    [topic_id release];
    [top release];
    [user_icon release];
    [user_name release];
	[super dealloc];
}
@end

@implementation LearnPointListInfo
@synthesize score,descprit,create_time;

- (void)InitSubFieldName
{
    ADD_FIELD(score,@"score");
    ADD_FIELD(descprit,@"descprition");
    ADD_FIELD(create_time,@"create_time");
}

-(void)dealloc
{
    [score release];
    [descprit release];
    [create_time release];
	[super dealloc];
}
@end


@implementation MessageListInfo
@synthesize _id,name,content,summary,create_time,res_path,resolution,thumbs,top;

- (void)InitSubFieldName
{
    ADD_FIELD(_id,@"id");
    ADD_FIELD(name,@"name");
    ADD_FIELD(content,@"content");
    ADD_FIELD(summary,@"summary");
    ADD_FIELD(create_time,@"create_time");
    ADD_FIELD(res_path,@"res_path");
    ADD_FIELD(resolution,@"resolution");
    ADD_FIELD(thumbs,@"thumbs");
    ADD_FIELD(top,@"top");
}

-(void)dealloc
{
    [_id release];
    [name release];
    [content release];
    [summary release];
    [top release];
    [create_time release];
    [res_path release];
    [resolution release];
    [thumbs release];
	[super dealloc];
}
@end