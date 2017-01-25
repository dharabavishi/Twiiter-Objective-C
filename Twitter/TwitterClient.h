//
//  TwitterClient.h
//  Twitter
//
//  Created by Dhara Bavishi on 1/14/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "User.h"
#import "Tweets.h"
@interface TwitterClient : BDBOAuth1SessionManager

+ (TwitterClient *)instance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;

- (void)loginWithTwitter;
-(void)handleOpenURL:(NSURL *)url;
- (void)homeTimeLineWithParams:(NSString *)lowestID completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)favoriteATweet:(NSString *)tweetID completion:(void (^)(id help, NSError *error))completion;
- (void)unfavoriteATweet:(NSString *)tweetID completion:(void (^)(id help, NSError *error))completion;
- (void)retweetATweet:(NSString *)tweetID completion:(void (^)(id help, NSError *error))completion;
- (void)undoRetweet:(NSString *)tweetID completion:(void (^)(id help, NSError *error))completion;
-(void)composeTweet:(NSString *)tweetText reply:(NSString *)replyID completion:(void (^)(id help, NSError *error))completion;
-(void)showAlert:(UIViewController *)controller alertTitle:(NSString *)strTitle;
@end
