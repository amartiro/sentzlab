//
//  ooVooLoginViewController.m
//  LingvoPal
//
//  Created by Artak Martirosyan on 6/28/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "ooVooLoginViewController.h"
#import "ooVooVideoViewController.h"
#import <ooVooSDK/ooVooSDK.h>

NSString * ooVooToken = @"MDAxMDAxAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABf%2BhiIvkH20IQJIrUhQ4rCjiIMsSQ3su40xtnsBjHImiD7fMA4AIBw9g1%2Fv00JoYqTXCfFfXUChUS2uPyxIO92fnuHpRhEUiy6%2BOraqfFexMZBuPJqObEYEJP2b%2FM6GYw%3D";


@interface ooVooLoginViewController () <ooVooAccountDelegate>

@property (strong, nonatomic) ooVooClient *sdk;
@property (strong, nonatomic) NSString *userId;


@end

@implementation ooVooLoginViewController

- (void)dealloc {
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

-(instancetype) init{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.bkgImageView.image = [Helper getImageByImageName:@"gradient"];
    
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[Helper getImageByImageName:@"close_icon"] forState:UIControlStateNormal];
    closeButton.frame = [Helper getRectValue:CGRectMake(0, 20, 60, 60)];
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    UIImageView *videoIconImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"video_wait_icon"]];
    videoIconImageView.center = [Helper getPointValue:CGPointMake(160, 88)];
    [self.view addSubview:videoIconImageView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 130, 290, 70)]];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = [Helper fontWithSize:15];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = @"You are about to connect for video call";
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
    
    
    self.sdk = [ooVooClient sharedInstance];
    self.sdk.Account.delegate = self;
}


-(void) closeAction:(UIButton *) button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.sdk authorizeClient:ooVooToken
                   completion:^(SdkResult *result) {
                       if (result.Result == sdk_error_OK)
                       {
                           NSLog(@"Good Authorization");
                           [self login];
                       }
                       else
                       {
                           NSLog(@"Failed Authorization - Check your token !");
                       }
                   }];

}

//  2 . login user ....
-(void)login{
    self.userId = self.isTranslator ? @"123456789" : @"123456780";
    
    [self.sdk.Account login:self.userId
                 completion:^(SdkResult *result) {
                     if (result.Result == sdk_error_OK)
                     {
                         NSLog(@"Login Success");
                         [self openVideo];
                     }
                     else
                     {
                         UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Login Error" message:result.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alert show];
                     }
                 }];
}

// 3. Create a video panel and open camera
-(void)openVideo{
     ooVooVideoViewController *viewController = [[ooVooVideoViewController alloc] init];

    viewController.streamId = self.streamId;
    viewController.transId = self.transId;
    viewController.isTranslator = self.isTranslator;
    viewController.isInitiator = self.isInitiator;
    viewController.callType = self.callType;
    viewController.userId = self.userId;
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [viewControllers replaceObjectAtIndex:([viewControllers count] - 1) withObject:viewController];
    self.navigationController.viewControllers = [NSArray arrayWithArray:viewControllers];
}


- (void)didAccountLogIn:(id<ooVooAccount>)account{
    NSLog(@"Did Login");
}

- (void)didAccountLogOut:(id<ooVooAccount>)account{
    NSLog(@"Did Logout");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
