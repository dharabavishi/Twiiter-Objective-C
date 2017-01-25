//
//  Tweets.h
//  Twitter
//
//  Created by Dhara Bavishi on 1/20/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"


typedef enum TweetType {
    kReTweet,
    kReply,
    kOriginal
} TweetType;


@interface Tweets : NSObject

@property (nonatomic, copy)NSString *text;
@property (nonatomic, strong)NSDate *timestamp;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) NSInteger favoutitesCount;
@property (nonatomic, assign) NSInteger isRetweet;
@property (nonatomic, copy) NSURL *profileImageURL;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *screen_name;

@property (nonatomic, copy)NSString *retweetedStatus;
@property (nonatomic, copy)NSString *tweetID;
@property (nonatomic,copy)NSDictionary *retweetedStatusDic;
@property (nonatomic, copy)NSString *retweetedStatusID;
@property (nonatomic, copy)NSString *retweetUserID;

@property (nonatomic,strong)User *user;
@property (nonatomic, assign) BOOL curUserReTweeted;
@property (nonatomic, assign) BOOL curUserFavorited;
@property (nonatomic,copy)NSString *replyToScreenName;

@property(nonatomic,assign)TweetType  *tweetType;
@property (nonatomic,strong)User *retweetedUser;

@property (nonatomic,copy)NSString *strDate;
@property (nonatomic,copy)NSString *createdAt;

@property(nonatomic,strong)NSURL *mediaUrl;
@property(nonatomic,strong)NSDictionary *mediaDic;


- (id)initWithDictionary:(NSDictionary *)dict;
+ (NSArray *)tweetsWithArray:(NSArray *)array;
-(NSString *)getDateTime;
- (NSString *)getAgoTime;
-(NSMutableAttributedString*)decorateTags:(NSString *)stringWithTags;

@end
