//
//  NodeDataClass.h
//  weave3TI
//
//  Created by macuser01 on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseDictionaryData.h"

@interface NodeDataClass : NSObject

@end

//展馆平面图信息
@interface PlanImageInfo : ParseDictionaryData
@property (nonatomic,strong)NSString* _id;     //
@property (nonatomic,strong)NSNumber* updated_at;    //
@end

//登录的用户的信息
@interface LoginUserInfo : ParseDictionaryData
@property (nonatomic,strong)NSString* userId;    //
@property (nonatomic,strong)NSString* username;     //
@property (nonatomic,strong)NSString* userImg;     //
@property (nonatomic,strong)NSString* basePath;     //
@property (nonatomic,strong)NSString* score;    //
@property (nonatomic,strong)NSString* star;    //
@property (nonatomic,strong)NSString* session_id;    //
@property (nonatomic,strong)NSString* abilityCount;//
@end

//我的学习培训计划列表信息
@interface TrainPlanListInfo : ParseDictionaryData
@property (nonatomic,strong)NSString* planId;     //
@property (nonatomic,strong)NSString* planImg;    //
@property (nonatomic,strong)NSString* planName;     //
@property (nonatomic,strong)NSString* planStartTime;     //
@property (nonatomic,strong)NSString* planEndTime;     //
@property (nonatomic,strong)NSString* planCount;     //
@property (nonatomic,strong)NSString* planunsrc;     //
@property (nonatomic,strong)NSString* planUnread;     //
@property (nonatomic,strong)NSString* planDesc;     //
@property (nonatomic,strong)NSString* planType;     //
@end

//我的微知识列表信息
@interface KnowlegeMyListInfo : ParseDictionaryData
@property (nonatomic,strong)NSString* knowledgeId;     //
@property (nonatomic,strong)NSString* knowledgeName;    //
@property (nonatomic,strong)NSString* knowledgeContent;     //
@property (nonatomic,strong)NSString* knowledgeTime;     //
@property (nonatomic,strong)NSString* className;     //
@property (nonatomic,strong)NSString* knowledgeReadCount;     //
@property (nonatomic,strong)NSString* knowledgeUpCount;     //
@property (nonatomic,strong)NSString* categoryThree;     //
@property (nonatomic,strong)NSString* knowledgeFavoriteCount;     //
@property (nonatomic,strong)NSString* knowledgeType;     //
@property (nonatomic,strong)NSString* knowledgeSource;     //
@property (nonatomic,strong)NSString* Knowledgeimage;     //
@property (nonatomic,strong)NSString* knowledgeEditer;     //
@property (nonatomic,strong)NSString* knowledgeIsFavorite;     //
@property (nonatomic,strong)NSString* categoryKnowledgename;     //
@property (nonatomic,strong)NSString* ablityEditor;     //
@property (nonatomic,strong)NSString* categoryKnowledgeid;     //
@property (nonatomic,strong)NSString* path;     //
@property (nonatomic,strong)NSString* resolution;     //
@property (nonatomic,strong)NSString* smallImg;     //
@property (nonatomic,strong)NSString* typeImg;     //
@property (nonatomic,strong)NSString* knowledgeIsPraise;
@property (nonatomic)BOOL bDownloading;
@property (nonatomic,strong)NSString* top;
@property (nonatomic,strong)NSString* abilityCode;
@property (nonatomic,strong)NSString* abilityName;
@end


//能力列表信息
@interface AbilityListInfo : ParseDictionaryData
@property (nonatomic,strong)NSString* code;     //
@property (nonatomic,strong)NSString* name;    //
@property (nonatomic,strong)NSString* state;     //
@end

//核心教辅的coretype信息
@interface CoretypeInfo : ParseDictionaryData
@property (nonatomic,strong)NSString* _id;     //
@property (nonatomic,strong)NSString* name;    //
@property (nonatomic,strong)NSString* code;    //
@property (nonatomic,strong)NSString* img;    //
@end


//微知识评论信息
@interface CommentListInfo : ParseDictionaryData
@property (nonatomic,strong)NSString* commentId;     //
@property (nonatomic,strong)NSString* commentUsername;    //
@property (nonatomic,strong)NSString* commentUserImg;     //
@property (nonatomic,strong)NSString* commentContent;     //
@property (nonatomic,strong)NSString* commentTime;    //
@property (nonatomic,strong)NSString* parent;     //
@property (nonatomic,strong)NSString* _child;     //
@property (nonatomic,strong)NSString* top;
@property (nonatomic,strong)NSMutableArray * children;    //
@property (nonatomic,strong)NSString* anonymous;
@end


//探索菜单信息
@interface ExploreListInfo : ParseDictionaryData
@property (nonatomic,strong)NSString* code;     //
@property (nonatomic,strong)NSString* image;    //
@property (nonatomic,strong)NSString* resolution;     //
@property (nonatomic,strong)NSString* name;    //
@property (nonatomic,strong)NSString* bLocal;    //
@end

//知识问答列表信息
@interface AnswerListInfo : ParseDictionaryData
@property (nonatomic,strong)NSString* _id;     //
@property (nonatomic,strong)NSString* knowledge_name;    //
@property (nonatomic,strong)NSString* categoryKnowledgename;     //
@property (nonatomic,strong)NSString* lession_name;     //
@property (nonatomic,strong)NSString* question;     //
@property (nonatomic,strong)NSString* anwser;     //
@property (nonatomic,strong)NSString* coretype_name;     //
@property (nonatomic,strong)NSString* userName;     //
@property (nonatomic,strong)NSString* createTime;     //
@property (nonatomic,strong)NSString* img;     //
@property (nonatomic,strong)NSString* categoryKnowledgecode;
@end


//搜索Model菜单信息
@interface SearchModelListInfo : ParseDictionaryData
@property (nonatomic,strong)NSString* code;     //
@property (nonatomic,strong)NSString* image;    //
@end

//搜索Tag菜单信息
@interface SearchTagListInfo : ParseDictionaryData
@property (nonatomic,strong)NSString* tagName;     //
@end

//知识问答模块列表信息
@interface QAModelListInfo : ParseDictionaryData
@property (nonatomic,strong)NSString* code;     //
@property (nonatomic,strong)NSString* name;    //
@end


//议题列表信息
@interface CaseDiscussListInfo : ParseDictionaryData
@property (nonatomic,strong)NSString* _id;     //
@property (nonatomic,strong)NSString* topic_name;    //
@property (nonatomic,strong)NSString* topic_content;     //
@property (nonatomic,strong)NSString* start_time;     //
@property (nonatomic,strong)NSString* end_time;     //
@property (nonatomic,strong)NSString* create_user;     //
@property (nonatomic,strong)NSString* master;     //
@property (nonatomic,strong)NSString* comment;     //
@property (nonatomic,strong)NSString* resouce;     //
@property (nonatomic,strong)NSString* create_time;     //
@property (nonatomic,strong)NSString* item_count;     //
@property (nonatomic,strong)NSString* resolution;     //
@property (nonatomic,strong)NSString* small_img;     //
@property (nonatomic,strong)NSString* type;     //
@end

//议题评论信息
@interface CaseCommentListInfo : ParseDictionaryData
@property (nonatomic,strong)NSString* _id;     //
@property (nonatomic,strong)NSString* item_content;    //
@property (nonatomic,strong)NSString* user_id;    //
@property (nonatomic,strong)NSString* parent;    //
@property (nonatomic,strong)NSString* topic_id;    //
@property (nonatomic,strong)NSString* ent;    //
@property (nonatomic,strong)NSString* type;    //
@property (nonatomic,strong)NSString* create_time;    //
@property (nonatomic,strong)NSString* top;    //
@property (nonatomic,strong)NSString* user_icon;    //
@property (nonatomic,strong)NSString* user_name;    //

@property (nonatomic,strong)NSMutableArray * children;    //
@end

//学习积分列表信息
@interface LearnPointListInfo : ParseDictionaryData
@property (nonatomic,strong)NSString* score;     //
@property (nonatomic,strong)NSString* descprit;    //
@property (nonatomic,strong)NSString* create_time;    //
@end

//消息列表信息
@interface MessageListInfo : ParseDictionaryData
@property (nonatomic,strong)NSString* _id;     //
@property (nonatomic,strong)NSString* name;     //
@property (nonatomic,strong)id content;    //
@property (nonatomic,strong)NSString* summary;    //
@property (nonatomic,strong)NSString* create_time;     //
@property (nonatomic,strong)NSString* res_path;    //
@property (nonatomic,strong)NSString* resolution;    //
@property (nonatomic,strong)NSString* thumbs;     //
@property (nonatomic,strong)NSString* top;    //
@end