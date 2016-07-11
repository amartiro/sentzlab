//
//  BaseViewController.m
//  LingvoPal
//
//  Created by Artak on 16.12.15.
//  Copyright (c) 2015 SentzLab. All rights reserved.
//

#import "BaseViewController.h"
#import "Helper.h"

@interface BaseViewController()

@property (nonatomic, strong) UIImageView *transImageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.transImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 100, 120, 120)]];
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:self.activityIndicator];
    
    
//    NSArray *imageNames = [NSArray arrayWithObjects:@"pic1", @"pic2", @"pic3",
//                           //@"pic4",
//                           @"pic5", @"pic6", @"pic7", @"pic8",
//                           //@"pic9",
//                           @"pic10", nil];
//    
//    NSInteger index = arc4random() % [imageNames count];
//    self.transImageView.image = [Helper getImageByImageName:[imageNames objectAtIndex:index]];
    
//    self.transImageView.animationDuration = 20;
//    [self.transImageView startAnimating];
   // [self.view addSubview:self.transImageView];
   // [self.view sendSubviewToBack:self.transImageView];
    
    self.bkgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.bkgImageView];
    [self.view sendSubviewToBack:self.bkgImageView];
    

}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    NSArray *imageNames = [NSArray arrayWithObjects:@"pic1", @"pic2", @"pic3",
//                           @"pic4",
//                           @"pic5", @"pic6", @"pic7", @"pic8",
//                           @"pic9",
//                           @"pic10", nil];
//    
//    NSInteger index = arc4random() % [imageNames count];
//    self.transImageView.image = [Helper getImageByImageName:[imageNames objectAtIndex:index]];
//    [self.view bringSubviewToFront:self.activityIndicator];
}

-(void) startAnimation{
    [self.view bringSubviewToFront:self.activityIndicator];
    [self.activityIndicator startAnimating];
}

-(void) stopAnimation{
    [self.activityIndicator stopAnimating];
}

-(void) hideBackground{
    self.bkgImageView.hidden = YES;
    self.transImageView.hidden = YES;
}
@end
