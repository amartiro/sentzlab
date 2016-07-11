//
//  BaseViewController.h
//  LingvoPal
//
//  Created by Artak on 16.12.15.
//  Copyright (c) 2015 SentzLab. All rights reserved.
//

@import UIKit;

@interface BaseViewController : UIViewController

@property (strong, nonatomic) UIImageView *bkgImageView;


-(void) startAnimation;
-(void) stopAnimation;

-(void) hideBackground;


@end
