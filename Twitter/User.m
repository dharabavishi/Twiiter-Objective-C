//
//  User.m
//  Twitter
//
//  Created by Dhara Bavishi on 1/14/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"
#import "AppDelegate.h"

@interface User()

@property (nonatomic, weak) NSDictionary *dictionary;

@end
@implementation User


- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    
    if (self) {
        self.name = dict[@"name"];
        self.screenName = dict[@"screen_name"];
        self.profileImageUrl = [NSURL URLWithString:dict[@"profile_image_url_https"]];
        //self.tagline = dict[@"description"];
        self.dictionary = dict;
    }
    
    return self;
}
static User *_currentUser = nil;

NSString *const kCurrentUserKey = @"kCurrentUserKey";
+ (User *)getCurrentUser {
    
    if (_currentUser == nil) {
        NSData *data =[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dict];
            
        }
    }
    
    return  _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    
    if (_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
}
+ (void)logout {
    _currentUser = nil;
    
    [[TwitterClient instance].requestSerializer removeAccessToken];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLogoutNotification" object:nil];
}

@end
