//
//  TwitterClient.m
//  Twitter
//
//  Created by Dhara Bavishi on 1/14/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
#import "NSURL+dictionaryFromQueryString.h"
#import "Constant.h"
@interface  TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *, NSError *error);

@end


@implementation TwitterClient





+ (TwitterClient *)instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:APP_URL] consumerKey:CONSUMER_KEY consumerSecret:CONSUMER_SECRET];
    });
    return instance;
}

- (void)loginWithTwitter {
    
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"bdboauth://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        
        NSLog(@"request token is %@",requestToken);
        NSString *authURL = [NSString stringWithFormat:@"%@/oauth/authorize?oauth_token=%@",APP_URL, requestToken.token];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL] options:@{}  completionHandler:nil];
        
    } failure:^(NSError *error) {
        
         NSLog(@"failure token is %@",error);
        
    }];
    
    
}
-(void)handleOpenURL:(NSURL *)url{
    
        if ([url.scheme isEqualToString:@"bdboauth"]) {
            
                NSDictionary *parameters = [url dictionaryFromQueryString];
                if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                    
                    [self fetchAccessTokenWithPath:@"/oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
                        //success
                        
                        [self getCurrentUser:accessToken completion:^(User *user, NSError *error) {
                            
                            if(error==nil){
                                
                                NSLog(@"user is %@",user);
                            }else{
                                
                                NSLog(@"Error on getting user %@",error);
                            }
                            
                        }];
                        
                    } failure:^(NSError *error) {
                         NSLog(@"Error on gettting access token %@",error);
                    }];
                }
            
        }
    
    
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion{
    
    self.loginCompletion = completion;
    [self.requestSerializer removeAccessToken];
    
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"bdboauth://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/authorize?oauth_token=%@", APP_URL,requestToken.token]];
        [[UIApplication sharedApplication] openURL:url options:@{}  completionHandler:nil];
    } failure:^(NSError *error) {
        NSLog(@"token failed");
        self.loginCompletion(nil, error);
    }];
}


-(void)getCurrentUser: (BDBOAuth1Credential *)accessToken completion:(void (^)(User *user, NSError *error))completion{
    
    [self GET:@"1.1/account/verify_credentials.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        User *user = [[User alloc] initWithDictionary:responseObject];
        
        [User setCurrentUser:user];
        
        NSLog(@"name si : %@",user.name);
        
        self.loginCompletion(user,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        self.loginCompletion(nil,error);
        
    }];
}
- (void)finishLoginWithRequestURL:(NSURL *)requestURL {


    
    [self fetchAccessTokenWithPath:@"oauth/access_token"
                            method:@"POST"
                      requestToken:[BDBOAuth1Credential credentialWithQueryString:requestURL.query]
                           success:^(BDBOAuth1Credential *accessToken) {
                               
                               NSLog(@"Access token is %@",accessToken);
                               [[TwitterClient instance].requestSerializer saveAccessToken:accessToken];
                               
                           } failure:^(NSError *error) {
                               
                           }];
}

- (void)homeTimeLineWithParams:(NSString *)lowestID completion:(void (^)(NSArray *tweets, NSError *error))completion{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"20" forKey:@"count"];
    if([lowestID isEqualToString:@"0"]){
        dict = nil;
    }else{
        [dict setObject:lowestID forKey:@"max_id"];
    }
    
    [self GET:TIMELINE_URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *tweets = [Tweets tweetsWithArray:responseObject];
        completion(tweets,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil,error);
    }];
}

 

- (void)favoriteATweet:(NSString *)tweetID completion:(void (^)(id help, NSError *error))completion{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:tweetID forKey:@"id"];
    
    
   
    
    NSString *url1 = [NSString stringWithFormat: @"%@?id=%@",FAVORITE_URL, tweetID];
    [self POST:url1 parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"resp %@",responseObject);
        completion(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil,error);
        NSLog(@"%@",error.description);
    }];
    
    
}

- (void)unfavoriteATweet:(NSString *)tweetID completion:(void (^)(id help, NSError *error))completion{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:tweetID forKey:@"id"];
    
    
   
    
    [self POST:UN_FAVORITE_URL parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil,error);
    }];
    
    
}

- (void)retweetATweet:(NSString *)tweetID completion:(void (^)(id help, NSError *error))completion{
   
    
    
    NSString *url = [NSString stringWithFormat:@"%@/%@.json",RETWEET_A_TWEET,tweetID];
    [self POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil,error);
    }];

}
- (void)undoRetweet:(NSString *)tweetID completion:(void (^)(id help, NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@/%@.json",UNDO_RETWEET_A_TWEET,tweetID];
    [self POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil,error);
    }];

}
/*
func composeTweet(tweetText: String, inReplyTo:Int64, completion:@escaping (_ response:AnyObject?, _ error:Error?)->())
{
    var params = ["status": tweetText, "in_reply_to_status_id": "\(inReplyTo)"] as [String: Any]
    if(inReplyTo == 0)
    {
        params = ["status": tweetText, "in_reply_to_status_id": ""] as [String: Any]
    }
    post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
        completion(response as AnyObject? , nil)
    }, failure: { (task:URLSessionDataTask?, err:Error) -> Void in
        completion(nil, err)
    })
}*/

-(void)composeTweet:(NSString *)tweetText reply:(NSString *)replyID completion:(void (^)(id help, NSError *error))completion{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:tweetText forKey:@"status"];
    [dict setObject:@"" forKey:@"in_reply_to_status_id"];

    if(replyID){
        
        [dict setObject:replyID forKey:@"in_reply_to_status_id"];
    }
    [self POST:COMPOSE_TWEET parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject , nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
  
}
-(void)showAlert:(UIViewController *)controller alertTitle:(NSString *)strTitle{
  
    
    UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"Something went wrong" message:strTitle preferredStyle:UIAlertControllerStyleAlert];
    [alert1 showViewController:controller sender:nil];
}

@end
