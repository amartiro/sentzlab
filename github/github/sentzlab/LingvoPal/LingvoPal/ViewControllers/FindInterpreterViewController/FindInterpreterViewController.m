//
//  FindInterpreterViewController.m
//  LingvoPal
//
//  Created by Artak Martirosyan on 5/27/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "FindInterpreterViewController.h"
#import "Helper.h"
#import "AppDelegate.h"
#import "MFSideMenuContainerViewController.h"
#import "PortalSession.h"
#import <CoreText/CoreText.h>
#import "ClientWaitingViewController.h"
#import "Constants.h"


@interface FindInterpreterViewController () <UIActionSheetDelegate, PortalSessionDelegate>

@property (nonatomic, strong) NSArray *toArray;
@property (nonatomic, strong) NSArray *fromArray;
@property (nonatomic, strong) NSDictionary *langDict;

@property (nonatomic, strong) UILabel* transToLabel;
@property (nonatomic, strong) NSString* transToStr;

@property (nonatomic, strong) UILabel* transFromLabel;
@property (nonatomic, strong) NSString* transFromStr;

@property (nonatomic, strong) UIActionSheet *fromActionSheet;
@property (nonatomic, strong) UIActionSheet *toActionSheet;

@property (nonatomic, strong) UIButton *videoCallButton;
@property (nonatomic, strong) UIButton *videoConferenceButton;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *contentVideoView;
@property (nonatomic, strong) UIView *contentConfVideoView;


@property (nonatomic, strong) UILabel *descVideoLabel;
@property (nonatomic, strong) UILabel *priceVideoLabel;

@property (nonatomic, strong) UILabel *descConfVideoLabel;
@property (nonatomic, strong) UILabel *priceConfVideoLabel;


@property (nonatomic, assign) CGPoint panStartPoint;



@property (assign, nonatomic) CallType callType;


@end

@implementation FindInterpreterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.bkgImageView.image = [Helper getImageByImageName:@"find_interpreter_background"];
  //  self.bkgImageView.center = CGPointMake(self.bkgImageView.center.x, self.bkgImageView.center.y + [Helper getValue:10]);
    self.callType = sntzInvalidCall;
    
    UIButton * menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[Helper getImageByImageName:@"burger"] forState:UIControlStateNormal];
    menuButton.frame = [Helper getRectValue:CGRectMake(5, 20, 41, 34)];
    [menuButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(50, 28, 260, 18)]];
    titleLabel.text = @"Find interpreter";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [Helper fontWithSize:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:titleLabel];
    
    UIImageView *yourLangImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"big_language_cell"]];
    yourLangImageView.center = [Helper getPointValue:CGPointMake(160, 86)];
    yourLangImageView.userInteractionEnabled = YES;

    
    UILabel *yourLangLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 5, 60, 34)]];
    
    yourLangLabel.font = [Helper fontWithSize:14];
    yourLangLabel.textAlignment = NSTextAlignmentLeft;
    yourLangLabel.textColor = [UIColor blackColor];
//    yourLangLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
//    yourLangLabel.shadowOffset = CGSizeMake(1, 1);
    yourLangLabel.numberOfLines = 2;
    yourLangLabel.text = @"Your\nlanguage";
    [yourLangImageView addSubview:yourLangLabel];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *fromLang = [defaults objectForKey:kPreferedLang1];
    NSString *toLang = [defaults objectForKey:kPreferedLang2];
    
   
    
    self.transFromLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(150, 10, 95, 20)]];
    self.transFromLabel.text = @"options";
    self.transFromLabel.textColor = [UIColor colorWithRed:(44.0f/255.0f) green:(189.0f/255.0f) blue:(242.0f/255.0f) alpha:1.0f];
    self.transFromLabel.font = [Helper fontWithSize:16];
    self.transFromLabel.backgroundColor = [UIColor clearColor];
    [yourLangImageView addSubview:self.transFromLabel];
    
    UIButton* transFromButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [transFromButton setImage:[Helper getImageByImageName:@"down1_arrow"] forState:UIControlStateNormal];
    transFromButton.frame = [Helper getRectValue:CGRectMake(5, 0, 225, 44)];
    transFromButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [transFromButton addTarget:self action:@selector(translateFromAction:) forControlEvents:UIControlEventTouchUpInside];
    [yourLangImageView addSubview:transFromButton];
    
    
    UIImageView *interLangImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"little_language_cell"]];
    interLangImageView.center = [Helper getPointValue:CGPointMake(160, 137)];
    interLangImageView.userInteractionEnabled = YES;
    [self.view addSubview:interLangImageView];
    [self.view addSubview:yourLangImageView];
    
    UILabel *interLangLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 5, 80, 34)]];
    
    interLangLabel.font = [Helper fontWithSize:14];
    interLangLabel.textAlignment = NSTextAlignmentLeft;
    interLangLabel.textColor = [UIColor blackColor];
//    interLangLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
//    interLangLabel.shadowOffset = CGSizeMake(1, 1);
    interLangLabel.numberOfLines = 2;
    interLangLabel.text = @"Language\n to interpret";
    [interLangImageView addSubview:interLangLabel];
    
    self.transToLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(150, 10, 95, 20)]];
    self.transToLabel.text = (toLang ? toLang  : @"options");
    self.transToLabel.backgroundColor = [UIColor clearColor];
    self.transToLabel.textColor = [UIColor colorWithRed:(44.0f/255.0f) green:(189.0f/255.0f) blue:(242.0f/255.0f) alpha:1.0f];
    self.transToLabel.font = [Helper fontWithSize:16];
    [interLangImageView addSubview:self.transToLabel];
    
    UIButton* transToButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [transToButton  setImage:[Helper getImageByImageName:@"down1_arrow"] forState:UIControlStateNormal];
    transToButton.frame = [Helper getRectValue:CGRectMake(5, 0, 225, 44)];
    transToButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [transToButton addTarget:self action:@selector(translateToAction:) forControlEvents:UIControlEventTouchUpInside];
    [interLangImageView addSubview:transToButton];
    
    
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"arrows"]];
    arrowImageView.center = [Helper getPointValue:CGPointMake(160, 112)];
    [self.view addSubview:arrowImageView];
    
    
    if (fromLang != nil) {
        self.transFromStr = fromLang;
        self.transFromLabel.text = [Helper getLanguageFromABRV:fromLang];
        [self constructToArray];
    }
    
    if (toLang != nil) {
        self.transToStr = toLang;
        self.transToLabel.text = [Helper getLanguageFromABRV:toLang];
    }
    
    
    
     self.videoCallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[self.videoCallButton setBackgroundImage:[Helper getImageByImageName:@"login_cell"] forState:UIControlStateNormal];
    [self.videoCallButton setTitle:@"VIDEO CALL" forState:UIControlStateNormal];
    self.videoCallButton.titleLabel.font = [Helper fontWithSize:14];
    self.videoCallButton.frame = [Helper getRectValue:CGRectMake(5, 180, 150, 20)];
    [self.videoCallButton addTarget:self action:@selector(videoCallAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.videoCallButton];
    
    
    self.videoConferenceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[self.videoCallButton setBackgroundImage:[Helper getImageByImageName:@"login_cell"] forState:UIControlStateNormal];
    [self.videoConferenceButton setTitle:@"VIDEO CONFERENCE" forState:UIControlStateNormal];
    self.videoConferenceButton.titleLabel.font = [Helper fontWithSize:14];
    self.videoConferenceButton.frame = [Helper getRectValue:CGRectMake(165, 180, 150, 20)];
    [self.videoConferenceButton addTarget:self action:@selector(videoConferenceAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.videoConferenceButton];
    
    self.callType = sntzVideoCall;
    
    self.lineView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 206, 160, 3)]];
    self.lineView.backgroundColor = [UIColor colorWithRed:(148.0f/255.0f) green:(197.0f/255.0f) blue:(255.0f/255.0f) alpha:1.0f];
    [self.view addSubview:self.lineView];
    
    
    self.contentView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 210, 640, 260)]];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];
    
    self.contentVideoView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 320, 260)]];
    self.contentVideoView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.contentVideoView];
    
    self.contentConfVideoView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(320, 0, 320, 260)]];
    self.contentConfVideoView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.contentConfVideoView];
    
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"DESCRIPTION"];
    [attString addAttribute:(NSString*)kCTUnderlineStyleAttributeName
                      value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                      range:(NSRange){0,[attString length]}];
   
    UILabel *descLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 10, 160, 25)]];
    descLabel.attributedText = attString;
    descLabel.textColor = [UIColor blackColor];
    [self.contentVideoView addSubview:descLabel];
    
    UILabel *desc2Label = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 10, 160, 25)]];
    desc2Label.attributedText = attString;
    desc2Label.textColor = [UIColor blackColor];
    [self.contentConfVideoView addSubview:desc2Label];
    
    
    self.descVideoLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 40 , 240, 80)]];
    self.descVideoLabel.textColor = [UIColor blackColor];
    self.descVideoLabel.font = [Helper fontWithSize:14];
    self.descVideoLabel.textAlignment = NSTextAlignmentLeft;
    self.descVideoLabel.text = @"Video Call is a type of connection between only you and interpreter via Video or Audio call.";
    self.descVideoLabel.numberOfLines = 5;

    [self.contentVideoView addSubview:self.descVideoLabel];
    
    self.descConfVideoLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 40 , 240, 80)]];
    self.descConfVideoLabel.textColor = [UIColor blackColor];
    self.descConfVideoLabel.font = [Helper fontWithSize:14];
    self.descConfVideoLabel.textAlignment = NSTextAlignmentLeft;
    self.descConfVideoLabel.text = @"Video Conference is a type of video connection between you, the interpreter and two other participants who you can invite by sending them a link.";
    self.descConfVideoLabel.numberOfLines = 5;
    
    [self.contentConfVideoView addSubview:self.descConfVideoLabel];
    
    
    
    
    attString = [[NSMutableAttributedString alloc] initWithString:@"PRICE"];
    [attString addAttribute:(NSString*)kCTUnderlineStyleAttributeName
                      value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                      range:(NSRange){0,[attString length]}];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 150, 160, 25)]];
    priceLabel.attributedText = attString;
    priceLabel.textColor = [UIColor blackColor];
    [self.contentVideoView addSubview:priceLabel];
    
    UILabel *price2Label = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 150, 160, 25)]];
    price2Label.attributedText = attString;
    price2Label.textColor = [UIColor blackColor];
    [self.contentConfVideoView addSubview:price2Label];
    
    
    self.priceVideoLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 180 , 240, 60)]];
    self.priceVideoLabel.textColor = [UIColor blackColor];
    self.priceVideoLabel.userInteractionEnabled = NO;
    self.priceVideoLabel.font = [Helper fontWithSize:14];
    self.priceVideoLabel.textAlignment = NSTextAlignmentLeft;
    self.priceVideoLabel.text = @"First minute free\nFrom 2-nd to 10-th minutes inclusive minimal charge: 10$\nEvery following minute: 1$/min";
    self.priceVideoLabel.numberOfLines = 4;
    
    [self.contentVideoView addSubview:self.priceVideoLabel];
    
    self.priceConfVideoLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 180 , 240, 60)]];
    self.priceConfVideoLabel.textColor = [UIColor blackColor];
    self.priceConfVideoLabel.userInteractionEnabled = NO;
    self.priceConfVideoLabel.font = [Helper fontWithSize:14];
    self.priceConfVideoLabel.textAlignment = NSTextAlignmentLeft;
    self.priceConfVideoLabel.text = @"First minute free\nFrom 2-nd to 10-th minutes inclusive minimal charge: 10$\nEvery following minute: 1$/min";
    self.priceConfVideoLabel.numberOfLines = 4;
    
    [self.contentConfVideoView addSubview:self.priceConfVideoLabel];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.contentView addGestureRecognizer:panGesture];
    
//    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
//  //  leftSwipeGesture.delegate = self;
//    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.contentView addGestureRecognizer:leftSwipeGesture];
//
//    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
//    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.contentView addGestureRecognizer:rightSwipeGesture];
    
    
    
    UIButton * findButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [findButton setBackgroundImage:[Helper getImageByImageName:@"find_interpreter_cell"] forState:UIControlStateNormal];
    [findButton setTitle:@"FIND INTERPRETER" forState:UIControlStateNormal];
    findButton.titleLabel.font = [Helper fontWithSize:14];
    findButton.frame = [Helper getRectValue:CGRectMake(40, 496, 240, 30)];
    [findButton addTarget:self action:@selector(findInterpreterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findButton];
    
}

-(void) leftMenuOpened{
   // self.contentView.hidden = YES;
}

-(void) leftMenuClosed{
   // self.contentView.hidden = NO;
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getLangs];
}

-(void) getLangs{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session getLangs];
    [self startAnimation];
}

-(void) setReserve{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session setReserveOfTranslatorFromLanguage:self.transFromStr toLanguage:self.transToStr withIsPro:NO withPhoneNumber1:@"" withPhoneNumber2:@"" andTime:0 andCallType:self.callType];
    [self startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) menuAction:(UIButton *) button{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.menuViewController toggleLeftSideMenuCompletion:^{
        
    }];
}

-(void) videoCallAction:(UIButton *) button{
//    self.lineView.center = CGPointMake([Helper getValue:80], self.lineView.center.y);
//    self.callType = sntzVideoCall;
//    self.contentView.center = [Helper getPointValue:CGPointMake(320, 340)];
//    self.contentConfVideoView.hidden = YES;
//    self.contentVideoView.hidden = NO;

    [self animateVideoSelection];
}

-(void) videoConferenceAction:(UIButton *) button{
//    self.lineView.center = CGPointMake([Helper getValue:240], self.lineView.center.y);
//    self.callType = sntzConfVideoCall;
//    self.contentView.center = [Helper getPointValue:CGPointMake(0, 340)];
//    self.contentVideoView.hidden = YES;
//    self.contentConfVideoView.hidden = NO;
    [self animateConfVideoSelection];
}

-(void) findInterpreterAction:(UIButton *) button{
    
    if ([self.transFromStr length] == 0) {
        [Helper showAlertViewWithText:@"Please select FROM language" delegate:nil];
        return;
    }
    
    if ([self.transToStr length] == 0) {
        [Helper showAlertViewWithText:@"Please select TO language" delegate:nil];
        return;
    }
    
    if (self.callType == sntzInvalidCall) {
        [Helper showAlertViewWithText:@"Please select call type" delegate:nil];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.transFromStr forKey:kPreferedLang1];
    [[NSUserDefaults standardUserDefaults] setObject:self.transToStr forKey:kPreferedLang2];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self setReserve];

}

-(void) animateVideoSelection{
    [UIView beginAnimations:@"shadowMoveRestAway" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  
    self.lineView.center = CGPointMake([Helper getValue:80], self.lineView.center.y);
    self.callType = sntzVideoCall;
    self.contentView.center = [Helper getPointValue:CGPointMake(320, 340)];
    self.contentConfVideoView.alpha = 0.0f;
    self.contentVideoView.alpha = 1.0f;

    [UIView commitAnimations];
}

-(void) animateConfVideoSelection{
    
    [UIView beginAnimations:@"shadowMoveRestAway" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    self.lineView.center = CGPointMake([Helper getValue:240], self.lineView.center.y);
    self.callType = sntzConfVideoCall;
    self.contentView.center = [Helper getPointValue:CGPointMake(0, 340)];
    self.contentVideoView.alpha = 0.0f;
    self.contentConfVideoView.alpha = 1.0f;
//    
    [UIView commitAnimations];
}



-(void) panGestureAction:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:gesture.view];
    if (gesture.state == UIGestureRecognizerStateBegan) {

        self.panStartPoint = point;
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.panStartPoint.x < point.x) {
            [self animateVideoSelection];
        } else {
            [self animateConfVideoSelection];
        }
    }
}



-(void) translateFromAction:(UIButton *) button{
 //   [self closeKeyboards];
    
    self.fromActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please specify from language:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *lang in self.fromArray) {
        [self.fromActionSheet addButtonWithTitle:[Helper getLanguageFromABRV:lang]];
    }
    
    [self.fromActionSheet showInView:self.view];
}

-(void) translateToAction:(UIButton *) button{
  //  [self closeKeyboards];
    
    if ([self.transFromStr length] == 0) {
        [Helper showAlertViewWithText:@"Please select FROM language before choosing TO language" delegate:nil];
        return;
    }
    
    self.toActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please specify from language:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *lang in self.toArray) {
        [self.toActionSheet addButtonWithTitle:[Helper getLanguageFromABRV:lang]];
    }
    
    [self.toActionSheet showInView:self.view];
}



#pragma mark  UIActionSheetDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != 0) {
        if (actionSheet == self.fromActionSheet) {
            self.transFromStr = [self.fromArray objectAtIndex:(buttonIndex - 1)];
            self.transFromLabel.text = [Helper getLanguageFromABRV:self.transFromStr];
            [self constructToArray];
            
            self.transToLabel.text = @"options";
            self.transToStr = nil;
        }
        
        if (actionSheet == self.toActionSheet) {
            self.transToStr = [self.toArray objectAtIndex:(buttonIndex - 1)];
            self.transToLabel.text = [Helper getLanguageFromABRV:self.transToStr];
        }
    }
}

-(void) constructToArray{
    self.toArray = [self.langDict objectForKey:self.transFromStr];
    
    self.toArray =  [self.toArray sortedArrayUsingComparator:^NSComparisonResult(NSString* a, NSString* b) {
        
        return [[Helper getLanguageFromABRV:a] compare:[Helper getLanguageFromABRV:b]];
    }];
}

#pragma mark PortalSessionDelegate

-(void) getLangsResponse:(NSDictionary *)dict{
    NSLog(@"getLangsResponse %@", dict);
    
    self.langDict = [dict objectForKey:@"langs"];
    self.fromArray = [self.langDict allKeys];
    self.fromArray =  [self.fromArray sortedArrayUsingComparator:^NSComparisonResult(NSString* a, NSString* b) {
        
        return [[Helper getLanguageFromABRV:a] compare:[Helper getLanguageFromABRV:b]];
    }];
    
    [self stopAnimation];
    
    if (self.transFromStr != nil) {
        [self constructToArray];
    }
}

-(void) failedToGetLangs:(NSDictionary *)dict{
    NSLog(@"failedToGetLangs  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) timeoutToGetLangs:(NSError *)error{
    NSLog(@"timeoutToGetLangs");
    [self getLangs];
}

-(void) setReserveResponse:(NSDictionary *) dict{
    NSLog(@"setReserveResponse %@", dict);
    [self stopAnimation];
    
    ClientWaitingViewController *viewController = [[ClientWaitingViewController alloc] init];
    viewController.fromLang = self.transFromStr;
    viewController.toLang = self.transToStr;
    viewController.isPro = NO;
    viewController.orderId = [dict objectForKey:@"ord_id"];
    viewController.callType = self.callType;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) failedToSetReserve:(NSDictionary *) dict{
    
    NSLog(@"failedToSetReserve  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    [self stopAnimation];
}

-(void) timeoutToSetReserve:(NSError *) error{
    NSLog(@"timeoutToSetReserve");
    [self setReserve];
}

@end
