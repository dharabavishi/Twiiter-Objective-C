//
//  Tweets.h
//  Twitter
//
//  Created by Dhara Bavishi on 1/20/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweets : NSObject


@property (nonatomic, copy)NSString *text;
@property (nonatomic, copy)NSDate *timestamp;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) NSInteger favoutitesCount;
@property (nonatomic, assign) NSInteger isRetweet;
@property (nonatomic, copy) NSURL *profileImageURL;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *screen_name;
@property (nonatomic, assign)BOOL favourited;
@property (nonatomic, copy)NSString *retweetedStatus;
@property (nonatomic, copy)NSString *idStr;
@property (nonatomic,copy)NSDictionary *dictTweets;
@property (nonatomic, copy)NSString *retweetedStatusID;
@property (nonatomic, copy)NSString *retweetUserID;

@end
