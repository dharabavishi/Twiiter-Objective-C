//
//  TwitterClient.h
//  Twitter
//
//  Created by Dhara Bavishi on 1/14/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1SessionManager

+ (TwitterClient *)instance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;

- (void)loginWithTwitter;
-(void)handleOpenURL:(NSURL *)url;
@end
