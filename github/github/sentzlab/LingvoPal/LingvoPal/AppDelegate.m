//
//  AppDelegate.m
//  LingvoPal
//
//  Created by Artak on 1/15/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "MFSideMenuContainerViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Google/SignIn.h>
#import <ooVooSDK/ooVooSDK.h>

//const CGFloat kQBRingThickness = 1.f;
const NSTimeInterval kQBAnswerTimeInterval = 360.f;
const NSTimeInterval kQBRTCDisconnectTimeInterval = 360.0f;
const NSTimeInterval kQBDialingTimeInterval = 5.f;


@interface AppDelegate()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = [UIColor whiteColor];
        
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    if ([[UIApplication sharedApplication]
         respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert |
                                                                                               UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    self.navigationController = (UINavigationController *) self.window.rootViewController;
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"%@ sournceApp %@", url, sourceApplication);
    
    NSString *urlStr = [url absoluteString];
    NSRange keyRange = [urlStr rangeOfString:@"stream_id/"];
    
    if (keyRange.location != NSNotFound) {
        NSString *streamId = [urlStr substringFromIndex:(keyRange.location + keyRange.length)];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:streamId forKey:kStreamId];
        [defaults synchronize];

        [(UINavigationController *)self.window.rootViewController popToRootViewControllerAnimated:YES];
    //    [ChatManager.instance logOut];
        
        return YES;
    }

    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    
   BOOL googleHandled =  [[GIDSignIn sharedInstance] handleURL:url
                        sourceApplication:sourceApplication
                               annotation:annotation];
    
    
    return handled && googleHandled;
}

//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
//    
//    NSLog(@"%@ options %@", url, options);
//    NSString *urlStr = [url absoluteString];
//    NSRange keyRange = [urlStr rangeOfString:@"stream_id/"];
//    
//    if (keyRange.location != NSNotFound) {
//        NSString *streamId = [urlStr substringFromIndex:(keyRange.location + keyRange.length)];
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:streamId forKey:kStreamId];
//        [defaults synchronize];
//        
//        [(UINavigationController *)self.window.rootViewController popToRootViewControllerAnimated:YES];
// //       [ChatManager.instance logOut];
//    }
//    
//    return YES;
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
}

-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"%@", deviceToken);
    
    NSString* newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:newToken forKey:kDeviceToken];
    [defaults synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}
//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo
//fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler{
//    if (application.applicationState !=  UIApplicationStateActive) {
//        NSArray * notifArray = [userInfo objectForKey:@"notifs"];
//
//        NSArray *notifs = [userInfo objectForKey:@"notifs"];
//        NSString *notifName = [notifs objectAtIndex:2];
//        NSString *action = [notifArray objectAtIndex:2];
//
//
//        if ([action isEqualToString:@"new_order"]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNewOrderNotification object: userInfo];
//        } else if ([action isEqualToString:@"accept_order"]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kAcceptOrderNotification object: userInfo];
//        } else  if ([notifName isEqualToString:@"accept_translator"]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kAcceptTranslatorNotification object: userInfo];
//        }
//    }
//
//    handler(UIBackgroundFetchResultNewData);
//
//}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"receive remote %@",userInfo);
   
  //  if (application.applicationState !=  UIApplicationStateActive) {
        NSArray * notifArray = [userInfo objectForKey:@"notifs"];

        NSArray *notifs = [userInfo objectForKey:@"notifs"];
        NSString *action = [notifArray objectAtIndex:2];


        if ([action isEqualToString:@"new_order"]) {
            if (application.applicationState != UIApplicationStateActive) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kOpenOrdersNotification object: userInfo];

            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNewOrderNotification object: userInfo];
        } else if ([action isEqualToString:@"accept_order"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kAcceptOrderNotification object: userInfo];
        } else  if ([action isEqualToString:@"accept_translator"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kAcceptTranslatorNotification object: userInfo];
        }
  //  }
    
//    NSArray * notifArray = [userInfo objectForKey:@"notifs"];
//    
//    NSString *us_id = [notifArray objectAtIndex:0];
//    NSString *tr_id = [notifArray objectAtIndex:1];
//    NSString *action = [notifArray objectAtIndex:2];
//    NSString *order_id = [notifArray objectAtIndex:3];
//    NSString *stream_id = [notifArray objectAtIndex:5];
//
//    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:action message:[NSString stringWithFormat:@"%@", userInfo] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
//    [alertView show];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

}

@end


