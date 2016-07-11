//
//  QBInitiatorWaitingViewController.m
//  LingvoPal
//
//  Created by Artak on 5/2/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "QBInitiatorWaitingViewController.h"
#import "Helper.h"
#import "Settings.h"
#import "Constants.h"
#import "ChatManager.h"
#import "AppDelegate.h"
#import "QBVideoViewController.h"
#import <Quickblox/Quickblox.h>

@interface QBInitiatorWaitingViewController () <QBRTCClientDelegate>

@property (strong, nonatomic) UINavigationController *nav;
@property (weak, nonatomic) QBRTCSession *currentSession;

@end

@implementation QBInitiatorWaitingViewController

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
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.bkgImageView.image = [Helper getImageByImageName:@"welcome_gradient"];
    
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
    contentLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud ";    contentLabel.numberOfLines = 4;
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

    [QBRTCClient.instance addDelegate:self];
}

-(void) closeAction:(UIButton *) button{
    [ChatManager.instance logOut];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    QBRTCSession *session = [QBRTCClient.instance createNewSessionWithOpponents:self.opponentQBIds withConferenceType:QBRTCConferenceTypeVideo];
    if (session) {
        self.currentSession = session;
        
        QBVideoViewController *viewController = [[QBVideoViewController alloc] init];
        viewController.session = session;
        viewController.streamId = self.streamId;
        viewController.transId = self.transId;
        viewController.translatorQBID = [self.opponentQBIds objectAtIndex:0];
        
        self.nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [self presentViewController:self.nav animated:NO completion:nil];
    }
    

}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

//- (void)logInChatWithUser:(QBUUser *)user {
//    NSLog(@"QBInitiatorWaitingViewController qbID: %ld ", (long)user.ID);
//    
//    [Helper loginQBUser:user completion:^(BOOL error){
//        if (!error) {
//            AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
//            appDelegate.ownQBId = user.ID;
//            
//            NSLog(@"QB Login chat logged in %ld", (long)user.ID);
//            
//            QBRTCSession *session = [QBRTCClient.instance createNewSessionWithOpponents:self.opponentQBIds withConferenceType:QBRTCConferenceTypeVideo];
//            if (session) {
//                self.currentSession = session;
//                
//                QBVideoViewController *viewController = [[QBVideoViewController alloc] init];
//                viewController.session = session;
//                viewController.streamId = self.streamId;
//                viewController.transId = self.transId;
//                viewController.translatorQBID = [self.opponentQBIds objectAtIndex:0];
//                
//                self.nav = [[UINavigationController alloc] initWithRootViewController:viewController];
//                
//                [self presentViewController:self.nav animated:NO completion:nil];
//                
////                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
////                
////                [appDelegate.navigationController presentViewController:navController animated:NO completion:^{
////                    
////                }];
//
//                
//   //             [self.navigationController pushViewController:viewController animated:YES];
//            }
//        } else {
//            [Helper showAlertViewWithText:[NSString stringWithFormat:@"Failed to login with user %ld", (long) user.ID] delegate:nil];
//        }
//    }];
//}

- (void)sessionDidClose:(QBRTCSession *)session {
    
    if (session == self.currentSession ) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.nav.view.userInteractionEnabled = NO;
            [self.nav dismissViewControllerAnimated:NO completion:nil];
            self.currentSession = nil;
            self.nav = nil;
        });
    }
}

@end
