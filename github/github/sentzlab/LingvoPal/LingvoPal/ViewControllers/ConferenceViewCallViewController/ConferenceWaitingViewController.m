//
//  ConferenceWaitingViewController.m
//  LingvoPal
//
//  Created by Artak on 3/14/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "ConferenceWaitingViewController.h"
#import "Helper.h"
#import "Constants.h"

#import "Settings.h"
#import "ChatManager.h"
#import "AppDelegate.h"
#import "GustConferenceViewController.h"
#import "PortalSession.h"


@interface ConferenceWaitingViewController () <QBRTCClientDelegate, PortalSessionDelegate>

@property (nonatomic, strong) Settings *settings;
@property (weak, nonatomic) QBRTCSession *currentSession;

@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation ConferenceWaitingViewController


-(instancetype) init{
    self = [super init];
    if (self) {
        [QBRTCClient.instance addDelegate:self];
    }
    
    return self;
}

- (void)dealloc {
    [QBRTCClient.instance removeDelegate:self];
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
      NSLog(@"ConferenceWaitingViewController qbID: %@ ", self.qbId);
    
    self.bkgImageView.image = [Helper getImageByImageName:@"welcome_gradient"];
 
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[Helper getImageByImageName:@"back_icon"] forState:UIControlStateNormal];
    backButton.frame = [Helper getRectValue:CGRectMake(5, 20, 26, 42)];
    [backButton addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
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
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setBackgroundImage:[Helper getImageByImageName:@"cancel_cell"] forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [Helper fontWithSize:14];
    self.cancelButton.frame = [Helper getRectValue:CGRectMake(121, [Helper isiPhone4] ? 420 : 508, 78, 30)];
    [self.cancelButton addTarget:self action:@selector(cancelStreamAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    self.cancelButton.hidden = YES;
        
    self.settings = Settings.instance;
    
  //  NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

    if (!self.isTranslator){
        [[ChatManager instance] logOut];
        QBUUser *user = [[QBUUser alloc] init];
        user.ID = [self.qbId integerValue];
        user.password = self.qbPassword;
        [self performSelector:@selector(logInChatWithUser:) withObject:user afterDelay:14.0f];
        
     //   [self logInChatWithUser:user];
    }
        
//    QBUUser *user = [[QBUUser alloc] init];
//    user.ID = [self.qbId integerValue];
//    user.password = self.qbPassword;
//    [self logInChatWithUser:user];
    
 //   [self performSelector:@selector(logInChatWithUser:) withObject:user afterDelay:4.0f];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    if (self.isTranslator) {
        [self performSelector:@selector(showCancelButton) withObject:nil afterDelay:20.0f];
    }
}

-(void) showCancelButton{
    self.cancelButton.hidden = NO;
}

-(void) dismissAction:(UIButton *) button{
    [self .navigationController popViewControllerAnimated:YES];
}

-(void) cancelStreamAction:(UIButton *) button{
    
    [self cancelStream];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logInChatWithUser:(QBUUser *)user {
    
    [[ChatManager instance] logInWithUser:user completion:^(BOOL error) {
        
        if (!error) {
            AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
   //         appDelegate.ownQBFullName = user.fullName;
            appDelegate.ownQBId = user.ID;
            
            NSLog(@"QB Login chat logged in %ld", (long)user.ID);        }
        else {
            NSLog(NSLocalizedString(@"Login chat error!", nil));
        }
    } disconnectedBlock:^{
        NSLog(NSLocalizedString(@"Chat disconnected. Attempting to reconnect", nil));
        
    } reconnectedBlock:^{
        NSLog(@"Chat reconnected");
    }];
}

#pragma mark - QBWebRTCChatDelegate

- (void)didReceiveNewSession:(QBRTCSession *)session userInfo:(NSDictionary *)userInfo {
    
    self.currentSession = session;
    
    [QBRTCSoundRouter.instance initialize];
    
    GustConferenceViewController *viewController = [[GustConferenceViewController alloc] init];
    viewController.translatorQBID = [NSNumber numberWithInteger:[[userInfo objectForKey:@"tr_qb_id"] integerValue]];
    viewController.streamId = [userInfo objectForKey:@"stream_id"];

    viewController.session = session;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    NSLog(@"GUEST OPPONENT IDS %@", session.opponentsIDs);
    
    [self presentViewController:navController animated:NO completion:^
     {
         [self backToPreviousView];
     }];
}

- (void)sessionDidClose:(QBRTCSession *)session {
    
    if (session == self.currentSession ) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.currentSession = nil;
        });
    }
}

-(void) backToPreviousView{
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    if ([viewControllers count] <= 3) {
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        [self.navigationController popToViewController:[viewControllers objectAtIndex:[viewControllers count] - 3] animated:YES];
    }
}

-(void) cancelStream{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *streamId = [defaults valueForKey:kStreamId];
    NSString *transId =  [defaults objectForKey:kTranslatorId];
    
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session cancelStreamWithStreamId:streamId andTransId:transId];
}

-(void) cancelStreamResponse:(NSDictionary *) dict{
    NSLog(@"cancelStreamResponse %@", dict);
    [self backToPreviousView];
}

-(void) failedToCancelStream:(NSDictionary *) dict{
    NSLog(@"failedToCancelStream  %@", dict);
    
    //    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    //    if (errorCode == 1) {
    //        [self.navigationController popToRootViewControllerAnimated:YES];
    //    }
}

-(void) timeoutToCancelStream:(NSError *) error{
    NSLog(@"timeoutToCancelStream");
    [self cancelStream];
}


@end
