//
//  InstructionViewController.m
//  LingvoPal
//
//  Created by Artak on 2/19/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "InstructionViewController.h"
#import "Helper.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "PortalSession.h"
#import "Constants.h"
#import "MFSideMenuContainerViewController.h"

#import "AppDelegate.h"
#import <Google/SignIn.h>
#import "ooVooLoginViewController.h"



@interface InstructionViewController () <PortalSessionDelegate, UIScrollViewDelegate, GIDSignInDelegate>
@property (strong, nonatomic) UIImageView *bkgImageView;
@property (strong, nonatomic) UIScrollView *imageScrollView;
@property (strong, nonatomic) UIScrollView *textScrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *signUpButton;



@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * surname;
@property (strong, nonatomic) NSString * email;
@property (strong, nonatomic) NSString * fbId;
@property (strong, nonatomic) NSString * gId;


@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation InstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.bkgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.bkgImageView.image = [Helper getImageByImageName:@"introduction_background"];
    [self.view addSubview:self.bkgImageView];
    
    [GIDSignIn sharedInstance].delegate = self;
    
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 100, 320, 200)]];
    self.imageScrollView.backgroundColor = [UIColor clearColor];
    self.imageScrollView.contentSize = CGSizeMake(2*[Helper getValue:320], [Helper getValue:200]);
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    self.imageScrollView.delegate = self;
    [self.view addSubview:self.imageScrollView];
    
    UIImageView *logo1ImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"infographic1"]];
    logo1ImageView.center = [Helper getPointValue:CGPointMake(160, 120)];
    [self.imageScrollView addSubview:logo1ImageView];
    
    UIImageView *logo2ImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"infographic"]];
    logo2ImageView.center = [Helper getPointValue:CGPointMake(480, 120)];
    [self.imageScrollView addSubview:logo2ImageView];
    
    self.textScrollView = [[UIScrollView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 300, 320, 130)]];
    self.textScrollView.backgroundColor = [UIColor clearColor];
    self.textScrollView.contentSize = CGSizeMake(2*[Helper getValue:320], [Helper getValue:130]);
    self.textScrollView.pagingEnabled = YES;
    self.textScrollView.showsHorizontalScrollIndicator = NO;
    self.textScrollView.delegate = self;
    [self.view addSubview:self.textScrollView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 320, 50)]];
    titleLabel.numberOfLines = 2;
    titleLabel.font = [Helper fontWithSize:20];
    titleLabel.text = @"Live Language Interpreter\nOnly a Tap Away";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [self.textScrollView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 50, 320, 65)]];
    contentLabel.numberOfLines = 4;
    contentLabel.font = [Helper fontWithSize:14];
    contentLabel.text = @"This app will allow you to connect to real live multilingual interpreters form all over the world to help you with your everyday communications with foreigners.";
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.textColor = [UIColor whiteColor];
    [self.textScrollView addSubview:contentLabel];
    
    UILabel *title2Label = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(320, 0, 320, 50)]];
    title2Label.numberOfLines = 2;
    title2Label.font = [Helper fontWithSize:20];
    title2Label.text = @"Become An Interpreter\nYourself";
    title2Label.textAlignment = NSTextAlignmentCenter;
    title2Label.textColor = [UIColor whiteColor];
    [self.textScrollView addSubview:title2Label];
    
    UILabel *content2Label = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(320, 50, 320, 50)]];
    content2Label.numberOfLines = 3;
    content2Label.font = [Helper fontWithSize:14];
    content2Label.text = @"You can also apply through the app for becoming a LingvoPal interpreter and earning up to $42/hour at you spare time.";
    content2Label.textAlignment = NSTextAlignmentCenter;
    content2Label.textColor = [UIColor whiteColor];
    [self.textScrollView addSubview:content2Label];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 430, 320, 20)]];
    self.pageControl.numberOfPages = 2;
    [self.view addSubview:self.pageControl];
    
    self.signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.signUpButton setBackgroundImage:[Helper getImageByImageName:@"sign_up_short_cell"] forState:UIControlStateNormal];
    [self.signUpButton setTitle:@"REGISTER" forState:UIControlStateNormal];
    self.signUpButton.titleLabel.font = [Helper fontWithSize:18];
    self.signUpButton.frame = [Helper getRectValue:CGRectMake(20, 490, 125, 37)];
    [self.signUpButton addTarget:self action:@selector(signUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signUpButton];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setBackgroundImage:[Helper getImageByImageName:@"login_short_cell"] forState:UIControlStateNormal];
    [self.loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [Helper fontWithSize:18];
    self.loginButton.frame = [Helper getRectValue:CGRectMake(175, 490, 125, 37)];
    [self.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 100, 120, 120)]];
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:self.activityIndicator];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self makeLoginWithUUID];
}

-(void) loginAction:(UIButton *) button{
    LoginViewController *viewController = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) signUpAction:(UIButton *) button{
    RegisterViewController *viewController = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) makeLoginWithUUID{
    NSString *uuid = [Helper GetUUID];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceId = [defaults valueForKey:kDeviceToken];
    NSString *streamId = [defaults valueForKey:kStreamId];
    
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session loginWithUUID:uuid andRegId:deviceId andStreamId:streamId];
    [self.activityIndicator startAnimating];
}

-(void) makeSocialLogin{
    NSString *uuid = [Helper GetUUID];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceId = [defaults valueForKey:kDeviceToken];
    
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session socialLoginWitName:self.name withSurname:self.surname withEmail:self.email withFacbookId:self.fbId andGoogleId:self.gId withUUID:uuid andRegId:deviceId];
    [self.activityIndicator startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"location %@", NSStringFromCGPoint(scrollView.contentOffset));
    
    [UIView beginAnimations:@"shadowMoveRestAway" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (scrollView == self.imageScrollView){
        self.textScrollView.contentOffset = scrollView.contentOffset;
    } else {
        self.imageScrollView.contentOffset = scrollView.contentOffset;
    }
    
    [UIView commitAnimations];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"decelerate location %@", NSStringFromCGPoint(scrollView.contentOffset));
    self.pageControl.currentPage = (scrollView.contentOffset.x / [Helper getValue:320]);
}

-(void) loginWithUUIDResponse:(NSDictionary *) dict{
    NSLog(@"loginWithUUIDResponse %@", dict);
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[dict objectForKey:kAccessToken] forKey:kAccessToken];
    [defaults setObject:[dict objectForKey:kAccessId] forKey:kAccessId];
    [defaults setObject:[dict objectForKey:kTranslatorId] forKey:kTranslatorId]; // TO Test
    [defaults setObject:[dict objectForKey:kEmail] forKey:kEmail];
    [defaults setObject:[dict objectForKey:kNickName] forKey:kNickName];
    [defaults setObject:[dict objectForKey:koVoId] forKey:koVoId];
    
    [defaults setObject:[dict objectForKey:kQBId] forKey:kQBId];
    [defaults setObject:[dict objectForKey:kQBPassword] forKey:kQBPassword];
    
    
    [self.activityIndicator stopAnimating];
    
    NSString *streamId = [dict objectForKey:kStreamId];
    [defaults setObject:streamId forKey:kStreamId];
    
    if (streamId == nil || [streamId isEqualToString:@""]){
        NSInteger roomStatus = [[dict objectForKey:@"room_status"] integerValue];
        
        if (roomStatus == 2) {
            [Helper showAlertViewWithText:@"The room doesn't exist anymore." delegate:nil];
        } else  if (roomStatus == 1) {
            [Helper showAlertViewWithText:@"The room is full." delegate:nil];
        }
        
        MFSideMenuContainerViewController *viewController = [[MFSideMenuContainerViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        BOOL isTranslator = ([[dict objectForKey:@"is_tr"] integerValue] == 1);

        ooVooLoginViewController *viewController = [[ooVooLoginViewController alloc] init];
        viewController.streamId = streamId;
        viewController.isInitiator = NO;
        viewController.isTranslator = isTranslator;
        viewController.streamId = streamId;


        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [appDelegate.navigationController pushViewController:viewController animated:YES];
    }
}

-(void) failedToLoginWithUUID:(NSDictionary *) dict{
    
    NSLog(@"failedToLoginWithUUID  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];

    if (errorCode == 100) {
        [Helper showAlertViewWithText:@"The room doesn't exist anymore." delegate:nil];
    } else  if (errorCode == 101) {
        [Helper showAlertViewWithText:@"The room is full." delegate:nil];
    }
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kStreamId];

    [self.activityIndicator stopAnimating];
    
}

-(void) timeoutToLoginWithUUID:(NSError *) error{
    NSLog(@"timeoutToLoginWithUUID");
    [self makeLoginWithUUID];
}

-(void) socialLoginResponse:(NSDictionary *) dict{
    NSLog(@"socialLoginResponse %@", dict);
    
    NSString *trId = [dict objectForKey:kTranslatorId];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[dict objectForKey:kAccessToken] forKey:kAccessToken];
    [defaults setObject:[dict objectForKey:kAccessId] forKey:kAccessId];
    [defaults setObject:[dict objectForKey:kEmail] forKey:kEmail];
    [defaults setObject:[dict objectForKey:kNickName] forKey:kNickName];
    
    [defaults setObject:[dict objectForKey:kQBId] forKey:kQBId];
    [defaults setObject:[dict objectForKey:kQBPassword] forKey:kQBPassword];
    
    if (trId != nil) {  [defaults setObject:trId forKey:kTranslatorId]; }
 
    
    MFSideMenuContainerViewController *viewController = [[MFSideMenuContainerViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) failedToSocialLogin:(NSDictionary *) dict{
    
    NSLog(@"failedToSocialLogin  %@", dict);
    
//    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
}

-(void) timeoutToSocialLogin:(NSError *) error{
    NSLog(@"timeoutToSocialLogin");
    [self makeSocialLogin];
}

#pragma mark GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    self.gId= user.userID;                  // For client-side use only!
    self.name = user.profile.givenName;
    self.surname = user.profile.familyName;

    self.email = user.profile.email;
    
//    NSString *givenName = user.profile.givenName;
//    NSString *familyName = user.profile.familyName;
//    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    
    [self makeSocialLogin];
    // ...
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}


@end
