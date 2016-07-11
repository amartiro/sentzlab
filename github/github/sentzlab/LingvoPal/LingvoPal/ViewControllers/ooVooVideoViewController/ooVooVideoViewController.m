//
//  ooVooVideoViewController.m
//  LingvoPal
//
//  Created by Artak Martirosyan on 6/28/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "ooVooVideoViewController.h"
#import <ooVooSDK/ooVooSDK.h>
#import "PortalSession.h"
#import "MoneyInformingViewController.h"
#import "RateViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "ooVooVideoView.h"

@interface ooVooVideoViewController ()< PortalSessionDelegate, ooVooAVChatDelegate, ooVooVideoControllerDelegate>

@property (strong, nonatomic) UIView *toolBarView;
@property (nonatomic, assign) BOOL toolbarVisible;

@property (strong, nonatomic) ooVooClient *sdk;

@property (assign, nonatomic) BOOL isOffer;
@property (assign, nonatomic) NSTimeInterval timeDuration;


@property (nonatomic, strong) UIButton *micrButton;
@property (nonatomic, strong) UIButton *videoButton;

@property (nonatomic, strong) UIButton *callEndButton;
@property (nonatomic, strong) UIButton *cameraButton;

@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *shareActvityButton;
@property (nonatomic, strong) UIButton *closeShareView;
@property (nonatomic, strong) UIView *shareView;

@property (nonatomic, strong) NSMutableDictionary *participentState;
@property (nonatomic, strong) NSMutableDictionary *participantDict;
@property (atomic, retain) NSMutableDictionary *videoPanels;
@property (atomic, retain) NSMutableDictionary *participentShowOrHide;

//@property (nonatomic, strong) NSMutableDictionary *resolutionsHeaders;
@property (nonatomic, strong) NSString * defaultRes;
@property (nonatomic, strong) NSString * currentRes;  // The current resolution.

//@property (atomic, assign) BOOL isLoggedIn;

@property (nonatomic, assign) BOOL translatorGone;
@property (nonatomic, assign) BOOL hungUpedByMe;
@property (nonatomic, assign) BOOL wasConnected;


@property (nonatomic, retain) NSString *defaultCameraId;
@property (retain, nonatomic) ooVooVideoView *ownVideoPanelView;

@property (strong, nonatomic) NSMutableArray *activeUsers;
@property (atomic, assign) bool isCameraStateOn;

@end

const NSTimeInterval kRefreshTimeInterval = 1.f;

@implementation ooVooVideoViewController

-(instancetype) init{
    self = [super init];
    if (self) {
        self.toolbarVisible = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0.1465 green:0.1465 blue:0.1465 alpha:1.0];
    
    self.isCameraStateOn = YES;
    [self initFirstInitialize];
    [self initSDKInitializer];
    
    [self joinConference];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.toolBarView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, [Helper isiPhone4] ? 400 : 488 , 320, 80)]];
    self.toolBarView.backgroundColor = [UIColor colorWithWhite:0 alpha:.3f];
    [self.view addSubview:self.toolBarView];
    
    BOOL isConference = ((self.callType == sntzConfVideoCall) && self.isOffer);
    
    CGFloat buttonWidth = isConference ? 60 : 80;
    
    self.micrButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.micrButton.frame = [Helper getRectValue:CGRectMake(0, 0, buttonWidth, 80)];
    [self.micrButton setImage:[Helper getImageByImageName:@"microphone_select_icon"] forState:UIControlStateNormal];
    [self.micrButton addTarget:self action:@selector(micrButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBarView addSubview:self.micrButton];
    
    self.callEndButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.callEndButton.frame = [Helper getRectValue:CGRectMake(isConference ? 2*buttonWidth : 240, 0, 80, 80)];
    [self.callEndButton setImage:[Helper getImageByImageName:(isConference ? @"end_call_big_icon" : @"end_call_icon")] forState:UIControlStateNormal];
    [self.callEndButton addTarget:self action:@selector(endCallAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBarView addSubview:self.callEndButton];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.frame = [Helper getRectValue:CGRectMake(260 , 0, buttonWidth, 80)];
    self.shareButton.hidden = !isConference;
    [self.shareButton setImage:[Helper getImageByImageName:@"share_icon"] forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBarView addSubview:self.shareButton];
    
    self.videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.videoButton.frame = [Helper getRectValue:CGRectMake(buttonWidth, 0, buttonWidth, 80)];
    [self.videoButton setImage:[Helper getImageByImageName:@"video_call_select_icon"] forState:UIControlStateNormal];
    [self.videoButton addTarget:self action:@selector(videoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBarView addSubview:self.videoButton];
    
    self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cameraButton.frame = [Helper getRectValue:CGRectMake(isConference ? 200 : 160, 0, buttonWidth, 80)];
    [self.cameraButton setImage:[Helper getImageByImageName:@"flip_camera_icon"] forState:UIControlStateNormal];
    [self.cameraButton addTarget:self action:@selector(flipButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBarView addSubview:self.cameraButton];
    
    if (isConference) {
        self.shareView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(2, -155, 316, 150)]];
        self.shareView.layer.cornerRadius = [Helper getValue:5];
        self.shareView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0f];
        [self.view addSubview:self.shareView];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(20, 30, 280, 40)]];
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.font = [Helper fontWithSize:18];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.text = @"Share this link to invite participants to this call";
        contentLabel.numberOfLines = 2;
        [self.shareView addSubview:contentLabel];
        
        UILabel *psLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 85, 240, 20)]];
        psLabel.textColor = [UIColor blackColor];
        psLabel.font = [Helper fontWithSize:12];
        psLabel.textAlignment = NSTextAlignmentLeft;
        psLabel.text = @"P.S. Remember you can invite only two person";
        psLabel.adjustsFontSizeToFitWidth = YES;
        [self.shareView addSubview:psLabel];
        
        self.shareActvityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareActvityButton.frame = [Helper getRectValue:CGRectMake(40 , 110, 240, 30)];
        [self.shareActvityButton setBackgroundImage:[Helper getImageByImageName:@"share_popup_cell"] forState:UIControlStateNormal];
        [self.shareActvityButton setTitle:@"SHARE" forState:UIControlStateNormal];
        [self.shareActvityButton addTarget:self action:@selector(shareActvityAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.shareView addSubview:self.shareActvityButton];
    }
}

- (void)dealloc {
    NSLog(@"Dealloc ooVooVideoViewController");
    
    NSLog(@"Dealloc Video Conference ");

    self.currentRes=nil;
    self.participentState=nil;
    self.videoPanels=nil;
    self.participentShowOrHide=nil;
}

-(void)removeDelegates{
    self.sdk.AVChat.delegate = nil;
    self.sdk.AVChat.VideoController.delegate = nil;
}

- (void)initFirstInitialize {
    
    self.participantDict = [NSMutableDictionary dictionary];
    
    self.ownVideoPanelView = [[ooVooVideoView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 20, 320, 548)]];
    [self.view addSubview:self.ownVideoPanelView];

    self.videoPanels = [NSMutableDictionary dictionary];
    [self.videoPanels setObject:self.ownVideoPanelView forKey:self.userId];
    
    
    self.participentShowOrHide=[NSMutableDictionary dictionary];
    self.participentState=[NSMutableDictionary dictionary];
    self.activeUsers = [NSMutableArray array];
}

//- (void)initResolutionHeaders {
//    self.resolutionsHeaders = [NSMutableDictionary new];
//    [self.resolutionsHeaders setObject:@"Not Specified" forKey:[NSNumber numberWithInt:0]];
//    [self.resolutionsHeaders setObject:@"Low" forKey:[NSNumber numberWithInt:1]];
//    [self.resolutionsHeaders setObject:@"Medium" forKey:[NSNumber numberWithInt:2]];
//    [self.resolutionsHeaders setObject:@"High" forKey:[NSNumber numberWithInt:3]];
//    [self.resolutionsHeaders setObject:@"HD" forKey:[NSNumber numberWithInt:4]];
//}


- (void)initSDKInitializer {
    
    self.sdk = [ooVooClient sharedInstance];
    self.sdk.AVChat.delegate = self;
    self.sdk.AVChat.VideoController.delegate = self;
    
    self.defaultCameraId = [self.sdk.AVChat.VideoController getConfig:ooVooVideoControllerConfigKeyCaptureDeviceId];
    self.currentRes = self.defaultRes = [self.sdk.AVChat.VideoController getConfig:ooVooVideoControllerConfigKeyResolution];
 
    
    [self.sdk.AVChat.VideoController setConfig:self.currentRes forKey:ooVooVideoControllerConfigKeyResolution];
    
    
    self.ownVideoPanelView.fitVideoMode = FillUp;
    
    self.ownVideoPanelView.videoOrientationLocked = YES;
    self.ownVideoPanelView.videoOrientationChangesAnimated = NO;
    
    [self.sdk.AVChat.VideoController bindVideoRender:self.userId render:self.ownVideoPanelView];
    
    [self.sdk.AVChat.VideoController openCamera];
}

- (void)onHangUp:(id)sender {
    [self.sdk.AVChat.AudioController setPlaybackMute:YES];
    [self.sdk.AVChat.AudioController setRecordMuted:YES];
    
    
    [self.sdk.AVChat.AudioController unInitAudio:^(SdkResult *result) {
        NSLog(@"unInit Result %d",result.Result);
    }];
    
    [self.sdk.AVChat.VideoController closeCamera];
    [self removeDelegates];
    
    [self.sdk.AVChat.VideoController unbindVideoRender:self.userId render:self.ownVideoPanelView];
    [self.sdk.AVChat leave];
    
    [self setHistory];

}

- (void) joinConference{

    [self.sdk.AVChat.AudioController initAudio:^(SdkResult *result) {
        [self.sdk.AVChat.VideoController setConfig:self.currentRes forKey:ooVooVideoControllerConfigKeyResolution];
        
        NSLog(@"result %d description %@", result.Result, result.description);
        NSString *displayName = self.userId;
        //[self.sdk.AVChat.VideoController openCamera];
        
       // [self.sdk.AVChat.VideoController startTransmitVideo];
        
        [self.sdk.AVChat.AudioController setRecordMuted:NO];
        [self.sdk.AVChat.AudioController setPlaybackMute:NO];
      
        [self.sdk.AVChat join:[NSString stringWithFormat:@"%ld", (long)[self.streamId integerValue]] user_data:displayName];
     }];
}

-(void) shareAction:(UIButton *) button{
    [UIView beginAnimations:@"shadowMoveRestAway" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if (self.shareView.center.y < 0) {
        self.shareView.center = [Helper getPointValue:CGPointMake(160, 70)];
    } else{
        self.shareView.center = [Helper getPointValue:CGPointMake(160, -80)];
    }
    
    [UIView commitAnimations];
    
}

-(void) shareActvityAction:(UIButton *) button{
    NSString *linkStr = [NSString stringWithFormat:@"http://trans.sentzhost.com/api/red.php?stream_id=%@", self.streamId];
    
    NSURL *shareURL = [NSURL URLWithString:linkStr];
    
    NSArray *itemsToShare = [NSArray arrayWithObject:shareURL];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:^{ self.shareView.center = [Helper getPointValue:CGPointMake(160, -80)]; }];
}

-(void) tapGestureAction:(UITapGestureRecognizer *) gesture{
    
    [UIView beginAnimations:@"shadowMoveRestAway" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    self.toolbarVisible = !self.toolbarVisible;
    
    if (self.toolbarVisible) {
        self.toolBarView.frame = [Helper getRectValue:CGRectMake(0, [Helper isiPhone4] ? 400 : 488 , 320, 80)];
    } else {
        self.shareView.center = [Helper getPointValue:CGPointMake(160, -80)];
        self.toolBarView.frame = [Helper getRectValue:CGRectMake(0, [Helper isiPhone4] ? 480 : 568 , 320, 80)];
    }
    
    [UIView commitAnimations];
    
}



-(void) videoButtonAction:(UIButton *) button{
    self.isCameraStateOn = !self.isCameraStateOn;
    if (self.isCameraStateOn) {
        [self.videoButton setImage:[Helper getImageByImageName:@"video_call_select_icon"] forState:UIControlStateNormal];
        [self.sdk.AVChat.VideoController startTransmitVideo];
        [self.sdk.AVChat.VideoController openCamera];
        self.ownVideoPanelView.hidden = NO;
    } else {
        [self.videoButton setImage:[Helper getImageByImageName:@"video_call_icon"] forState:UIControlStateNormal];
        [self.sdk.AVChat.VideoController stopTransmitVideo];
        [self.sdk.AVChat.VideoController closeCamera];
        self.ownVideoPanelView.hidden = YES;
    }
}

-(void) micrButtonAction:(UIButton *) button{

    [self.sdk.AVChat.AudioController setRecordMuted:![self.sdk.AVChat.AudioController isRecordMuted]];
    
    NSLog(@"record muted %d", [self.sdk.AVChat.AudioController isRecordMuted]);
    
    if ([self.sdk.AVChat.AudioController isRecordMuted]) {
        [self.micrButton setImage:[Helper getImageByImageName:@"microphone_select_icon"] forState:UIControlStateNormal];
    } else {
        [self.micrButton setImage:[Helper getImageByImageName:@"microphone_icon"] forState:UIControlStateNormal];
    }
}

-(void) endCallAction:(UIButton *) button{
    [self onHangUp:nil];
    
    if (self.isTranslator || self.isInitiator) {
        [self setHistory];
    }
    
    self.hungUpedByMe = YES;
//    [self.session hangUp:[NSDictionary dictionaryWithObject:@"hang up" forKey:@"reason"]];
//    
//    if ([self.translatorQBID isEqualToNumber:[self currentUserID]]){
//        //    [self openMoneyViewController:@"New screen with earned money, you are translator and you hunged up"];
//    } else if ([self.session.initiatorID isEqualToNumber:[self currentUserID]]){
//        [self openRateViewController:@"New screen with spent money, you are initiator and you hunged up"];
//    } else {
        [self dismissAction];
//    }
}

-(void) openMoneyViewController:(NSString *) content{
    [self.sdk.Account logout];
    MoneyInformingViewController *viewController = [[MoneyInformingViewController alloc] init];
    viewController.content = content;
    
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:appDelegate.navigationController.viewControllers];
    [viewControllers replaceObjectAtIndex:([viewControllers count] - 1) withObject:viewController];
    
    appDelegate.navigationController.viewControllers = [NSArray arrayWithArray:viewControllers];
    
    [self dismissAction];
}

-(void) openRateViewController:(NSString *) content{
    [self.sdk.Account logout];
    RateViewController *viewController = [[RateViewController alloc] init];
    viewController.content = content;
    viewController.transId = self.transId;
    
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:appDelegate.navigationController.viewControllers];
    [viewControllers replaceObjectAtIndex:([viewControllers count] - 1) withObject:viewController];
    
    appDelegate.navigationController.viewControllers = [NSArray arrayWithArray:viewControllers];
    
    [self dismissAction];
}

-(void) dismissAction{
    [self.sdk.Account logout];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) setHistory{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session setHistoryWithStreamId:self.streamId] ;
}

-(void) startTime{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session startTimeWithStreamId:self.streamId] ;
}

-(void) stopTime{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session stopTimeWithStreamId:self.streamId] ;
}

-(void) checkStream{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *transId =  [defaults objectForKey:kTranslatorId];
    NSString *uuid = [Helper GetUUID];
    
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session checkStreamWithTransId:transId withUUID:uuid];
}

-(void) getStreamTranslator{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session getStreamTranslatorWithStreamId:self.streamId andTransId:self.transId];
}


-(void)  flipButtonAction:(UIButton *) button{
    
    NSString *currentDevice = [self.sdk.AVChat.VideoController getConfig:ooVooVideoControllerConfigKeyCaptureDeviceId];
    
    NSArray *arr_dev = [self.sdk.AVChat.VideoController getDevicesList];

    for (id<ooVooDevice> device in arr_dev) {
        
        if (![device.deviceID isEqualToString:currentDevice]) {
           [self.sdk.AVChat.VideoController setConfig:device.deviceID forKey:ooVooVideoControllerConfigKeyCaptureDeviceId];
        }
    }
}

- (void)refreshCallTime:(NSTimer *)sender {
    
    self.timeDuration += kRefreshTimeInterval;
    self.title = [NSString stringWithFormat:@"Call time - %@", [self stringWithTimeDuration:self.timeDuration]];
}

- (NSString *)stringWithTimeDuration:(NSTimeInterval )timeDuration {
    
    NSInteger minutes = timeDuration / 60;
    NSInteger seconds = (NSInteger)timeDuration % 60;
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld:%02ld", (long)minutes, (long)seconds];
    
    return timeStr;
}

#pragma mark PortalSessionDelegate

-(void) setHistoryResponse:(NSDictionary *) dict{
    NSLog(@"setHistoryResponse %@", dict);
}

-(void) failedToSetHIstory:(NSDictionary *) dict{
    NSLog(@"failedToSetHIstory  %@", dict);
    
    //    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    //    if (errorCode == 1) {
    //        [self.navigationController popToRootViewControllerAnimated:YES];
    //    }
}

-(void) timeoutToSetHistory:(NSError *)error{
    NSLog(@"timeoutToSetHistory");
    [self setHistory];
}

-(void) startTimeResponse:(NSDictionary *) dict{
    NSLog(@"startTimeResponse %@", dict);
}

-(void) failedToStartTime:(NSDictionary *) dict{
    NSLog(@"failedToStartTime  %@", dict);
    
    //    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    //    if (errorCode == 1) {
    //        [self.navigationController popToRootViewControllerAnimated:YES];
    //    }
}

-(void) timeoutToStartTime:(NSError *) error{
    NSLog(@"timeoutToStartTime");
    [self startTime];
}

-(void) stopTimeResponse:(NSDictionary *) dict{
    NSLog(@"stopTimeResponse %@", dict);
}

-(void) failedToStopTime:(NSDictionary *) dict{
    NSLog(@"failedToStopTime  %@", dict);
    
    //    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    //    if (errorCode == 1) {
    //        [self.navigationController popToRootViewControllerAnimated:YES];
    //    }
}

-(void) timeoutToStopTime:(NSError *) error{
    NSLog(@"timeoutToStopTime");
    [self stopTime];
}

-(void) checkStreamResponse:(NSDictionary *) dict{
    NSLog(@"%@ checkStreamResponse %@", self, dict);
    
    BOOL isTranslator = ([[dict objectForKey:@"is_tr"] integerValue] == 1);
    
    if (isTranslator) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:[dict objectForKey:kStreamId] forKey:kStreamId];
        [defaults setObject:[dict objectForKey:kQBId] forKey:kQBId];
        [defaults setObject:[dict objectForKey:kQBPassword] forKey:kQBPassword];
        
        [defaults setObject:[dict objectForKey:koVoId] forKey:koVoId];

        
        if (!self.hungUpedByMe && !self.wasConnected) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://trans.sentzhost.com/api/red.php?stream_id=%@", self.streamId]]];
//            exit(0);
//        } else {
//            [self setHistory];
//            [self openMoneyViewController:@"New screen with earned money, you are translator and initiator hunged up"];
        }
    }
}

-(void) failedToCheckStream:(NSDictionary *) dict{
    NSLog(@"failedToCheckStream  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self dismissAction];
        AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        [appDelegate.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (errorCode == 100) {
        [self openMoneyViewController:@"New screen with earned money, you are translator and initiator hunged up"];
    }
}

-(void) timeoutToCheckStream:(NSError *) error{
    NSLog(@"timeoutToCheckStream");
    [self checkStream];
}

-(void) getStreamTranslatorResponse:(NSDictionary *)dict{
    NSLog(@"getStreamTranslatorResponse %@", dict);
    NSString *qbId = [dict objectForKey:kQBId];
    
//    NSNumber *userID = [NSNumber numberWithInteger:[qbId integerValue]];
//    self.translatorQBID = userID;
    
//    OpponentVideoView *oppView = self.videoViews[userID];
//    if ([userID isEqualToNumber:self.translatorQBID]) {
//        oppView.roleLabel.text = @"Interpreter";
//    }
    
}

-(void) failedToGetStreamTranslator:(NSDictionary *) dict{
    NSLog(@"failedToGetStreamTranslator  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) timeoutToGetStreamTranslator:(NSError *) error{
    NSLog(@"timeoutToGetStreamTranslator");
    [self getStreamTranslator];
}

#pragma mark ooVooAVChatDelegate


-(NSString*)removeWhiteSpacesFromStartAndEnd:(NSString*)str{
    // comes @"    ddd  ddd       "
    //returns@"ddd  ddd"
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (void)didParticipantJoin:(id<ooVooParticipant>)participant user_data:(NSString *)user_data
{
    [self.activeUsers addObject:participant];
    NSLog(@"Participant join %@ ",participant.participantID);
    NSString *strName = [self removeWhiteSpacesFromStartAndEnd:user_data];
    if ([strName isEqualToString:@""]||!strName) {
        strName=participant.participantID;
    }
    [self.participantDict setValue:strName forKey:participant.participantID];
    
    [self updateVideoViews];
    
    ooVooVideoView *panel = self.videoPanels[participant.participantID];
    
    
    [self.sdk.AVChat.VideoController bindVideoRender:participant.participantID render:panel];
    [self.sdk.AVChat.VideoController registerRemoteVideo:participant.participantID];
}


/**
 *  listener method is being called when new participant left conference.
 *  @param uid - user id of participant.
 */
- (void)didParticipantLeave:(id<ooVooParticipant>)participant{
    NSLog(@"Participant Leave id %@",participant.participantID);
    
    
    if ([participant.participantID isEqualToString:self.initiatoroVoId]) {
        if ([self.transoVoId isEqualToString:self.ownoVoId]){
                    self.wasConnected = [Helper isConnected];
                    [self checkStream];

        }
        else {
            [self onHangUp:nil];
        }
    }

    if ([participant.participantID isEqualToString:self.transoVoId]){
        if ([self.ownoVoId isEqualToString:self.initiatoroVoId]) {
            [self stopTime];
            self.translatorGone = YES;
        }
    }

    for (id<ooVooParticipant> participant1 in self.activeUsers) {
        if ([participant.participantID isEqualToString:participant1.participantID]) {
            [self.activeUsers removeObject:participant1];
        }
    }
    
    [self.participantDict removeObjectForKey:participant.participantID];
    
    ooVooVideoView *panel = [self.videoPanels objectForKey:participant.participantID];
    
    if (panel) {

        [self.videoPanels removeObjectForKey:participant.participantID];
        [self.participentShowOrHide removeObjectForKey:participant.participantID];
        
        panel.hidden = true; // animate instead
        [self.sdk.AVChat.VideoController unbindVideoRender: participant.participantID render:panel];
        [self.sdk.AVChat.VideoController unRegisterRemoteVideo:participant.participantID];
        [self killPanel:panel];

        [self updateVideoViews];
    }
}

/**
 *  listener method is being called when conference state has changed.
 *  @param state - new conference state.
 *  @param errorCode - conference error code.
 */

- (void)didConferenceStateChange:(ooVooAVChatState)state error:(sdk_error)code {
    NSLog(@"state %d code %@", state, [[self class] getErrorDescription:code]);
    
    if (state == ooVooAVChatStateJoined && code == sdk_error_OK)
    {
        [UIApplication sharedApplication].idleTimerDisabled = (code == sdk_error_OK);
        [self.sdk.AVChat.AudioController setRecordMuted:NO];
        [self.sdk.AVChat.AudioController setPlaybackMute:NO];
    }
    else if (state == ooVooAVChatStateJoined || state == ooVooAVChatStateDisconnected)
    {
        if (state == ooVooAVChatStateJoined && code != sdk_error_OK)
        {
            UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"Join Error" message:[[self class] getErrorDescription:code] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        if (state == ooVooAVChatStateDisconnected && code != sdk_error_OK)
        {
            UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"Leave Error" message:[[self class] getErrorDescription:code] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            if (code == sdk_error_ActionNotPermitted)
                return;
        }
        
        if (state == ooVooAVChatStateDisconnected)
        {

            [self resetAll];
            
            [self.sdk.AVChat.VideoController bindVideoRender:self.userId render:self.ownVideoPanelView];
            [self.sdk.AVChat.VideoController setConfig:self.defaultCameraId forKey:ooVooVideoControllerConfigKeyCaptureDeviceId];
            [self.sdk.AVChat.VideoController openCamera];
        }
        
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }
}



/**
 *  listener method is being called when message is received.
 *  @param uid -user id of remote video.
 *  @param buffer - data which contains the message.
 *  @param size - buffer size.
 */
- (void)didReceiveData:(NSString *)uid data:(NSData *)data{

}

/**
 *  listener method is being called when conference error is received.
 *  @param errorCode - conference error code.
 */
- (void)didConferenceError:(sdk_error)code{
    NSLog(@"error code %@",[[self class] getErrorDescription:code]);
    [self.sdk.AVChat.AudioController unInitAudio:^(SdkResult *result) {
        NSLog(@"unInit Resoult %d",result.Result);
    }];
}

/**
 *  listener method is being called when network reilability change.
 *  @param score - a number from 1 - 4  1 indicate that network is worse 4 network is best.
 */
- (void)didNetworkReliabilityChange:(NSNumber*)score {
    NSLog(@"Reliability = %@",score);
}

/**
 *  listener method which indicates if user is in secure mode.
 *  @param score - true for secured otherwise false.
 */
- (void)didSecurityState:(bool)is_secure{
    NSLog(@"Security = %d",is_secure);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ooVooVideoControllerDelegate
/**
 *  listener method is being called when remote video state has changed.
 *  @param uid -user id of remote video.
 *  @param state - new remote video state.
 *  @param width - picture width.
 *  @param height - picture height.
 *  @param errorCode - conference error code.
 */
- (void)didRemoteVideoStateChange:(NSString *)uid state:(ooVooAVChatRemoteVideoState)state width:(const int)width height:(const int)height error:(sdk_error)code{
    NSLog(@"State %d And code %@",state,[[self class] getErrorDescription:code]);
    
    ooVooVideoView *panel = self.videoPanels[uid];
    
    if(state == ooVooAVChatRemoteVideoStatePaused && panel){
        [panel showVideoAlert:YES] ;
    }
    
    if(state == ooVooAVChatRemoteVideoStateResumed && panel){
        [panel showVideoAlert:NO] ;
    }
}

/**
 *  listener method is being called when camera state was changed.
 *  @param state - new camera state .
 *  @param errorCode - conference error code.
 */


-(void)didCameraStateChange:(ooVooDeviceState)state devId:(NSString* )devId width:(const int)width height:(const int)height fps:(const int)fps error:(sdk_error)code {
    NSLog(@"didCameraStateChange -> state [%@], code = %@", state ? @"Opened" : @"Fail", [[self class] getErrorDescription:code]);
    if (state) {
        [self.sdk.AVChat.VideoController openPreview];
        [self.sdk.AVChat.VideoController startTransmitVideo];
        
       // [self.sdk.AVChat.VideoController bindVideoRender:self.userId render:self.ownVideoPanelView];
    }
}

/**
 *  listener method is being called when video transmit state was changed.
 *  @param state - new video transmit state (ON/OFF).
 *  @param errorCode - conference error code.
 */
- (void)didVideoTransmitStateChange:(BOOL)state devId:(NSString *)devId error:(sdk_error)code{
    NSLog(@"State %d And code %@",state,[[self class] getErrorDescription:code]);
}

/**
 *  listener method is being called when preview video state was changed.
 *  @param state - new preview video state (ON/OFF).
 *  @param errorCode - conference error code.
 */
- (void)didVideoPreviewStateChange:(BOOL)state devId:(NSString *)devId error:(sdk_error)code{
    NSLog(@"State %d And code %@",state,[[self class] getErrorDescription:code]);
}

- (void)resetAll {
    // remove all of the video panel which are not me .
    for (id<ooVooParticipant> participant in self.activeUsers) {
        ooVooVideoView *panel = self.videoPanels[participant.participantID];
        [self.videoPanels removeObjectForKey:participant.participantID];
        [self.participentShowOrHide removeObjectForKey:participant.participantID];
        [self.sdk.AVChat.VideoController unbindVideoRender:participant.participantID render:panel];
        [self.sdk.AVChat.VideoController unRegisterRemoteVideo:participant.participantID];
        panel.hidden = true;
        [self killPanel:panel];
    }
    
    for (UIView *panel in self.view.subviews) {
        if ([panel isKindOfClass:[ooVooVideoView class]] && panel != self.ownVideoPanelView) {
            panel.hidden=true;
            [self killPanel:panel];
        }
    }
    
    [self.participantDict removeAllObjects];
}


-(void)killPanel:(UIView*)panel{
    
    [panel removeFromSuperview];
    panel=nil;
    
}
+(NSString*)getStateDescription:(ooVooDeviceState)code{
    
    switch (code) {
        case ooVooNotCreated:
            return @"ooVooNotCreated";
            break;
            
        case ooVooTurningOn:
            return @"ooVooTurningOn";
            break;
        case ooVooTurnedOn:
            return @"ooVooTurnedOn";
            break;
        case ooVooTurningOff:
            return @"ooVooTurningOff";
            break;
        case ooVooTurnedOff:
            return @"ooVooTurnedOff";
            break;
        case ooVooRestarting:
            return @"ooVooRestarting";
            break;
            
        case ooVooOnHold:
            return @"ooVooOnHold";
            break;
    }
    return  @"Unknown state";
}

+(NSString*)getErrorDescription:(sdk_error)code
{
    NSString * des;
    switch (code) {
            
        case sdk_error_InvalidParameter:                // Invalid Parameter
            des = @"Invalid Parameter.";
            break;
        case sdk_error_InvalidOperation:               // Invalid Operation
            des = @"Invalid Operation.";
            break;
        case sdk_error_DeviceNotFound:
            des = @"Device not found.";
            break;
        case sdk_error_AlreadyInSession:
            des = @"Already in session.";
            break;
        case sdk_error_DuplicateParticipantId:
            des = @"Duplicate Participant Id.";
            break;
        case sdk_error_ConferenceIdNotValid:
            des = @"Conference id not valid.";
            break;
        case sdk_error_ClientIdNotValid:
            des = @"client id not valid.";
            break;
        case sdk_error_ParticipantIdNotValid:
            des = @"Participant id not valid.";
            break;
        case sdk_error_CameraIdNotValid:
            des = @"Camera ID Not Valid.";
            break;
        case sdk_error_MicrophoneIdNotValid:
            des = @"Mic. ID Not Valid.";
            break;
        case sdk_error_SpeakerIdNotValid:
            des = @"Speaker ID Not Valid.";
            break;
        case sdk_error_VolumeNotValid:
            des = @"Volume Not Valid.";
            break;
        case sdk_error_ServerAddressNotValid:
            des = @"Server Address Not Valid.";
            break;
        case sdk_error_GroupQuotaExceeded:
            des = @"Group Quota Exceeded.";
            break;
        case sdk_error_NotInitialized:
            des = @" Not Initialized.";
            break;
        case sdk_error_Error:
            des = @"Conference Error.";
            break;
        case sdk_error_NotAuthorized:
            des = @"Not Authorized.";
            break;
        case sdk_error_ConnectionTimeout:
            des = @"Connection Timeout.";
            break;
        case sdk_error_DisconnectedByPeer:
            des = @"Disconnected by peer.";
            break;
        case sdk_error_InvalidToken:
            des = @"Invalid Token.";
            break;
        case sdk_error_ExpiredToken:
            des = @"Expired Token.";
            break;
        case sdk_error_PreviousOperationNotCompleted:
            des = @"Previous Operation Not Completed.";
            break;
        case sdk_error_AppIdNotValid:
            des = @"AppId Not Valid.";
            break;
        case sdk_error_NoAvs:
            des = @"No AVS.";
            break;
        case sdk_error_ActionNotPermitted:
            des = @"Action Not Permitted.";
            break;
        case sdk_error_DeviceNotInitialized:
            des = @"Device Not Initialized.";
            break;
        case sdk_error_Reconnecting:
            des = @"Network Is Reconnecting.";
            break;
        case sdk_error_Held:
            des = @"Application on hold.";
            break;
        case sdk_error_SSLCertificateVerificationFailed:
            des = @"SSL Certificates Verification Failed.";
            break;
        case sdk_error_ParameterAlreadySet:
            des = @"Parameter Already Set.";
            break;
        case sdk_error_AccessDenied:
            des = @"Access Denied.";
            break;
        case sdk_error_NoInternetConnection:
            des = @"Connection Lost.";
            break;
        case sdk_error_NotEnoughMemory:
            des = @"Not Enough Memory.";
            break;
        case sdk_error_ResolutionNotSupported:
            des = @"Resolution not supported.";
            break;
            
        case sdk_error_OK:
            des = @"OK.";
            break;
            
        default:
            des = [NSString stringWithFormat:@"Error Code %d", code];
            break;
    }
    return des;
}

-(void) constructVideoViewWithOpponentID:(id<ooVooParticipant>) participant{
    ooVooVideoView * panel = [[ooVooVideoView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 100,  125)]];
    
    [self.sdk.AVChat.VideoController registerRemoteVideo:participant.participantID];
    [self.sdk.AVChat.VideoController bindVideoRender:participant.participantID render:panel];
    [self.videoPanels setObject:panel forKey:participant.participantID];
    [self.participentShowOrHide setObject:[NSNumber numberWithBool:true] forKey:participant.participantID];
    [self.view addSubview:panel];
    [self.view sendSubviewToBack:panel];
}

-(void) updateVideoViews{
    NSInteger usersCount = [self.activeUsers count];
   
    if (usersCount > 0) {
        id<ooVooParticipant> participant= [self.activeUsers lastObject];
        
        ooVooVideoView *oppView = self.videoPanels[participant.participantID];
        
        if (!oppView) {
            [self constructVideoViewWithOpponentID:participant];
            oppView = self.videoPanels[participant.participantID];
        }
        
        if ([participant.participantID isEqualToString:self.transoVoId]) {
            oppView.roleLabel.text = @"Interpreter";
        }
        
        if ([participant.participantID isEqualToString:self.initiatoroVoId]) {
            oppView.roleLabel.text = @"Initiator";
        }

    }
  
    switch (usersCount) {
        case 0:
            self.ownVideoPanelView.frame = [Helper getRectValue:CGRectMake(0, 20, 320, 548)];
            break;
        case 1:{
            self.ownVideoPanelView.frame = [Helper getRectValue:CGRectMake(10, 363, 100, 125)];
            id<ooVooParticipant> participant1 = [self.activeUsers objectAtIndex:0];
            ooVooVideoView *user1View = self.videoPanels[participant1.participantID];
            user1View.frame = [Helper getRectValue:CGRectMake(0, 20, 320, 548)];
        }
            break;
        case 2:{

            id<ooVooParticipant> participant1 = [self.activeUsers objectAtIndex:0];
            ooVooVideoView *user1View = self.videoPanels[participant1.participantID];
            user1View.frame = [Helper getRectValue:CGRectMake(20, 20, 130, 162.5f)];

            id<ooVooParticipant> participant2 = [self.activeUsers objectAtIndex:1];
            ooVooVideoView *user2View = self.videoPanels[participant2.participantID];
            user2View.frame = [Helper getRectValue:CGRectMake(170, 20, 130, 162.5f)];
        }
            break;
        case 3:{

            id<ooVooParticipant> participant1 = [self.activeUsers objectAtIndex:0];
            ooVooVideoView *user1View = self.videoPanels[participant1.participantID];
            user1View.frame = [Helper getRectValue:CGRectMake(20, 20, 130, 162.5f)];

            id<ooVooParticipant> participant2 = [self.activeUsers objectAtIndex:1];
            ooVooVideoView *user2View = self.videoPanels[participant2.participantID];
            user2View.frame = [Helper getRectValue:CGRectMake(170, 20, 130, 162.5f)];

            id<ooVooParticipant> participant3 = [self.activeUsers objectAtIndex:2];
            ooVooVideoView *user3View = self.videoPanels[participant3.participantID];
            user3View.frame = [Helper getRectValue:CGRectMake(95, 190, 130, 162.5f)];
        }
            break;
        case 4:{

            id<ooVooParticipant> participant1 = [self.activeUsers objectAtIndex:0];
            ooVooVideoView *user1View = self.videoPanels[participant1.participantID];
            user1View.frame = [Helper getRectValue:CGRectMake(20, 20, 130, 162.5f)];

            id<ooVooParticipant> participant2 = [self.activeUsers objectAtIndex:1];
            ooVooVideoView *user2View = self.videoPanels[participant2.participantID];
            user2View.frame = [Helper getRectValue:CGRectMake(170, 20, 130, 162.5f)];

            id<ooVooParticipant> participant3 = [self.activeUsers objectAtIndex:2];
            ooVooVideoView *user3View = self.videoPanels[participant3.participantID];
            user3View.frame = [Helper getRectValue:CGRectMake(20, 190, 130, 162.5f)];

            id<ooVooParticipant> participant4 = [self.activeUsers objectAtIndex:3];
            ooVooVideoView *user4View = self.videoPanels[participant4.participantID];
            user4View.frame = [Helper getRectValue:CGRectMake(170, 190, 130, 162.5f)];
        }
            break;
        case 5:{

            id<ooVooParticipant> participant1 = [self.activeUsers objectAtIndex:0];
            ooVooVideoView *user1View = self.videoPanels[participant1.participantID];
            user1View.frame = [Helper getRectValue:CGRectMake(5, 20, 100, 125)];

            id<ooVooParticipant> participant2 = [self.activeUsers objectAtIndex:1];
            ooVooVideoView *user2View = self.videoPanels[participant2.participantID];
            user2View.frame = [Helper getRectValue:CGRectMake(110, 20, 100, 125)];

            id<ooVooParticipant> participant3 = [self.activeUsers objectAtIndex:2];
            ooVooVideoView *user3View = self.videoPanels[participant3.participantID];
            user3View.frame = [Helper getRectValue:CGRectMake(215, 20, 100, 125)];

            id<ooVooParticipant> participant4 = [self.activeUsers objectAtIndex:3];
            ooVooVideoView *user4View = self.videoPanels[participant4.participantID];
            user4View.frame = [Helper getRectValue:CGRectMake(58, 150, 100, 125)];
            
            id<ooVooParticipant> participant5 = [self.activeUsers objectAtIndex:4];
            ooVooVideoView *user5View = self.videoPanels[participant5.participantID];
            user5View.frame = [Helper getRectValue:CGRectMake(162, 150, 100, 125)];
        }
            break;
        case 6:{

            id<ooVooParticipant> participant1 = [self.activeUsers objectAtIndex:0];
            ooVooVideoView *user1View = self.videoPanels[participant1.participantID];
            user1View.frame = [Helper getRectValue:CGRectMake(5, 20, 100, 125)];

            id<ooVooParticipant> participant2 = [self.activeUsers objectAtIndex:1];
            ooVooVideoView *user2View = self.videoPanels[participant2.participantID];
            user2View.frame = [Helper getRectValue:CGRectMake(110, 20, 100, 125)];

            id<ooVooParticipant> participant3 = [self.activeUsers objectAtIndex:2];
            ooVooVideoView *user3View = self.videoPanels[participant3.participantID];
            user3View.frame = [Helper getRectValue:CGRectMake(215, 20, 100, 125)];

            id<ooVooParticipant> participant4 = [self.activeUsers objectAtIndex:3];
            ooVooVideoView *user4View = self.videoPanels[participant4.participantID];
            user4View.frame = [Helper getRectValue:CGRectMake(5, 150, 100, 125)];

            id<ooVooParticipant> participant5 = [self.activeUsers objectAtIndex:4];
            ooVooVideoView *user5View = self.videoPanels[participant5.participantID];
            user5View.frame = [Helper getRectValue:CGRectMake(110, 150, 100, 125)];

            id<ooVooParticipant> participant6 = [self.activeUsers objectAtIndex:5];
            ooVooVideoView *user6View = self.videoPanels[participant6.participantID];
            user6View.frame = [Helper getRectValue:CGRectMake(215, 150, 100, 125)];
        }
            break;

        default:
            break;
    }
}


@end
