//
//  PhoneWaitingViewController.m
//  LingvoPal
//
//  Created by Artak on 4/7/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "PhoneWaitingViewController.h"
#import "Helper.h"
#import "PortalSession.h"

@interface PhoneWaitingViewController () <PortalSessionDelegate>

@end

@implementation PhoneWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bkgImageView.image = [Helper getImageByImageName:@"welcome_gradient"];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 130, 290, 70)]];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = [Helper fontWithSize:15];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud ";
    contentLabel.numberOfLines = 4;
    [self.view addSubview:contentLabel];
    
    UIImageView *waitingImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"waiting1"]];
    waitingImageView.center = [Helper getPointValue:CGPointMake(160, 320)];
    waitingImageView.animationImages = [NSArray arrayWithObjects:
                                        [Helper getImageByImageName:@"waiting1"],
                                        [Helper getImageByImageName:@"waiting2"],
                                        [Helper getImageByImageName:@"waiting3"],
                                        [Helper getImageByImageName:@"waiting4"],
                                        [Helper getImageByImageName:@"waiting5"],
                                        [Helper getImageByImageName:@"waiting6"],
                                        [Helper getImageByImageName:@"waiting7"],
                                        [Helper getImageByImageName:@"waiting8"],
                                        [Helper getImageByImageName:@"waiting9"],
                                        [Helper getImageByImageName:@"waiting10"],
                                        [Helper getImageByImageName:@"waiting11"],
                                        [Helper getImageByImageName:@"waiting12"],
                                        [Helper getImageByImageName:@"waiting13"],
                                        [Helper getImageByImageName:@"waiting14"],
                                        [Helper getImageByImageName:@"waiting15"],
                                        [Helper getImageByImageName:@"waiting16"],
                                        [Helper getImageByImageName:@"waiting17"],
                                        [Helper getImageByImageName:@"waiting18"],
                                        [Helper getImageByImageName:@"waiting19"],
                                        nil];
    
    [self.view addSubview:waitingImageView];
    [waitingImageView startAnimating];
    
    [self callUser];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) callUser{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session callUserWithTransId:self.transId withStreamId:self.streamId];

}

#pragma mark PortalSessionDelegate


-(void) callUserResponse:(NSDictionary *) dict{
    NSLog(@"callUserResponse %@", dict);

}

-(void) failedToCallUser:(NSDictionary *) dict{
    NSLog(@"failedToCallUser  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (errorCode == 404) {
        [Helper showAlertViewWithText:@"Stream not found" delegate:nil];
    }
}

-(void) timeoutToCallUser:(NSError *) error{
    NSLog(@"timeoutToCallUser");
    [self callUser];
}

@end
