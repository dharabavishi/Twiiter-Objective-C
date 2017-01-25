//
//  AppDelegate.m
//  Twitter
//
//  Created by Ruchit Mehta on 1/14/17.
//  Copyright © 2017 Dhara Bavishi. All rights reserved.
//

#import "AppDelegate.h"
#import "NSURL+dictionaryFromQueryString.h"
#import "TwitterClient.h"
#import "User.h"
#import "LoginViewController.h"
#import "TweetsViewController.h"
#import "Constant.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : TWITTER_BLUE}];
    [[UINavigationBar appearance] setBarTintColor:WHITE];
    [[UINavigationBar appearance] setTintColor:TWITTER_BLUE];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:@"UserDidLogoutNotification" object:nil];

     
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    User *currentUser = [User getCurrentUser];
    if (currentUser == nil) {
        
        LoginViewController *loginViewController= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"]; //or the homeController
       
        self.window.rootViewController = loginViewController;
        
        
    } else {
        
        TweetsViewController *tweetsViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TweetsViewController"];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:tweetsViewController];
        self.window.rootViewController = navController;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}
- (void)userDidLogout
{
    LoginViewController *loginViewController= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    self.window.rootViewController = loginViewController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app
             openURL:(NSURL *)url
             options:(NSDictionary<NSString *,id> *)options {
    
    
    [[TwitterClient instance] handleOpenURL:url];
    return  YES;
    
}


@end
