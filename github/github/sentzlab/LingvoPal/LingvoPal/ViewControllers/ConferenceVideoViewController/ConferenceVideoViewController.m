//
//  ConferenceVideoViewController.m
//  LingvoPal
//
//  Created by Artak on 3/12/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "ConferenceVideoViewController.h"
#import "Helper.h"
#import "AppDelegate.h"
#import "ooVooLoginViewController.h"

@interface ConferenceVideoViewController ()

@property (nonatomic, strong) UIButton * linkCopyButton;
@property (nonatomic, strong) UIButton * shareButton;

@property (nonatomic, strong) UILabel * linkLabel;
@property (nonatomic, strong) NSString * linkStr;
@property (nonatomic, strong) UILabel * streamLabel;


@end

@implementation ConferenceVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bkgImageView.image = [Helper getImageByImageName:@"gradient1_short"];
    // Do any additional setup after loading the view.
    
    self.linkStr = [NSString stringWithFormat:@"http://trans.sentzhost.com/api/red.php?stream_id=%@", self.streamId];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[Helper getImageByImageName:@"back_black_icon"] forState:UIControlStateNormal];
    backButton.frame = [Helper getRectValue:CGRectMake(5, 20, 26, 42)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 80, 290, 180)]];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.font = [Helper fontWithSize:15];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.text = @"Share link with people who you want to invite for call you can invite only 2 participants";
    contentLabel.numberOfLines = 11;
    [self.view addSubview:contentLabel];
    
    self.streamLabel  = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 300, 300, 20)]];
    self.streamLabel.textColor = [UIColor colorWithRed:(125.0f/255.0f) green:(222.0f/255.0f) blue:(248.0f/255.0f) alpha:1.0f];
    self.streamLabel.text = [NSString stringWithFormat:@" %@ ", self.streamId];
    self.streamLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.streamLabel];
 
    self.linkCopyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.linkCopyButton setBackgroundImage:[Helper getImageByImageName:@"copy_link_cell"] forState:UIControlStateNormal];
    [self.linkCopyButton setTitle:@"COPY LINK" forState:UIControlStateNormal];
    self.linkCopyButton.titleLabel.font = [Helper fontWithSize:16];
    self.linkCopyButton.frame = [Helper getRectValue:CGRectMake(40, 354, 240, 30)];
    [self.linkCopyButton addTarget:self action:@selector(copyLinkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.linkCopyButton];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setBackgroundImage:[Helper getImageByImageName:@"share_cell"] forState:UIControlStateNormal];
    [self.shareButton setTitle:@"SHARE" forState:UIControlStateNormal];
    self.shareButton.titleLabel.font = [Helper fontWithSize:16];
    self.shareButton.frame = [Helper getRectValue:CGRectMake(40, 409, 240, 30)];
    [self.shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shareButton];
    
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundImage:[Helper getImageByImageName:@"send_request_cell"] forState:UIControlStateNormal];
    [nextButton setTitle:@"GO TO THE CALL" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [Helper fontWithSize:14];
    nextButton.frame = [Helper getRectValue:CGRectMake(40, 464, 240, 30)];
    [nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
}


-(void) backAction:(UIButton *) button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) nextAction:(UIButton *) button{
    
    ooVooLoginViewController *viewController = [[ooVooLoginViewController alloc] init];
    viewController.streamId = self.streamId;
    viewController.transId = self.transId;
    viewController.isInitiator = YES;
    viewController.isTranslator = NO;
    viewController.callType = sntzConfVideoCall;
    viewController.streamId = self.streamId;

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:appDelegate.navigationController.viewControllers];
    [viewControllers removeObjectsInRange:NSMakeRange([viewControllers count] - 3, 3)];
    [viewControllers addObject:viewController];
    
    appDelegate.navigationController.viewControllers = [NSArray arrayWithArray:viewControllers];
}

-(void) copyLinkAction:(UIButton *) button{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.linkStr;
}

-(void) shareAction:(UIButton *) button{
    
    NSURL *shareURL = [NSURL URLWithString:self.linkStr];
    
    NSArray *itemsToShare = [NSArray arrayWithObject:shareURL];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
