//
//  AppDelegate.h
//  LingvoPal
//
//  Created by Artak on 1/15/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MFSideMenuContainerViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) NSUInteger ownQBId;

@property (nonatomic, strong) MFSideMenuContainerViewController *menuViewController;
@property (strong, nonatomic) UINavigationController *navigationController;


@end

