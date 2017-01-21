//
//  User.h
//  Twitter
//
//  Created by Dhara Bavishi on 1/14/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, copy) NSURL *profileBannerUrl;
@property (nonatomic, copy) NSURL *profileImageUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *screenName;
@property (nonatomic, assign) NSInteger numTweets;
@property (nonatomic, assign) NSInteger numFollowing;
@property (nonatomic, assign) NSInteger numFollowers;

- (id)initWithDictionary:(NSDictionary *)dict;
+ (void)setCurrentUser:(User *)currentUser;
+ (User *)getCurrentUser;
@end
