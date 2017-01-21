//
//  TwitterClient.m
//  Twitter
//
//  Created by Dhara Bavishi on 1/14/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//


#import "TwitterClient.h"
#import "NSURL+dictionaryFromQueryString.h"

@interface  TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *, NSError *error);

@end


@implementation TwitterClient

NSString  *consumerKey = @"bBRVqCAgL3F3kATxww9DhWtjy";
NSString  *consumerSecret = @"dGz9LTIMNBoXRg06sPsXUpJw89btObtmGYEBaKK0XLWJ129B0X";
NSString  *appUrl = @"https://api.twitter.com";



+ (TwitterClient *)instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:appUrl] consumerKey:consumerKey consumerSecret:consumerSecret];
    });
    return instance;
}

- (void)loginWithTwitter {
    
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"bdboauth://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        
        NSLog(@"request token is %@",requestToken);
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];

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
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        [[UIApplication sharedApplication] openURL:url options:@{}  completionHandler:nil];
    } failure:^(NSError *error) {
        NSLog(@"token failed");
        self.loginCompletion(nil, error);
    }];
}


/*
 get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task : URLSessionDataTask, response : Any?) in
 print("--- TwitterClient: currentAccount : Success")
 let userDictionary = response as! NSDictionary
 let user = User(dictionary : userDictionary)
 
 success(user)
 
 }, failure: { (task : URLSessionDataTask?, error : Error) in
 failure(error)
 
 })
 
 */
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




@end
