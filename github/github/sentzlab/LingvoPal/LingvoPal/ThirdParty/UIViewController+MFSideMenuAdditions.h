//
//  UIViewController+MFSideMenuAdditions.h
//  LingvoPal
//
//  Created by Artak on 2/15/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MFSideMenuContainerViewController;

// category on UIViewController to provide reference to the menuContainerViewController in any of the contained View Controllers
@interface UIViewController (MFSideMenuAdditions)

@property(nonatomic,readonly,retain) MFSideMenuContainerViewController *menuContainerViewController;

@end

