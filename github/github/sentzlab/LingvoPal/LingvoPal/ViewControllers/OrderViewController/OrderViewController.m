//
//  OrderViewController.m
//  LingvoPal
//
//  Created by Artak on 12/7/15.
//  Copyright © 2015 SentzLab. All rights reserved.
//

#import "OrderViewController.h"
#import "Helper.h"
#import "AppDelegate.h"
#import "MFSideMenuContainerViewController.h"
//#import "DateSelectionViewController.h"
#import "PortalSession.h"
#import "Constants.h"


#define DOWN_ANIMATION_DURATION 0.5f
#define UP_ANIMATION_DURATION 0.3f



@interface OrderViewController () <UIActionSheetDelegate, PortalSessionDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIView * bottomBkgView;
@property (nonatomic, strong) UIButton *nonProTopButton;
@property (nonatomic, strong) UIButton *nonProButton;
@property (nonatomic, strong) UIButton *proTopButton;
@property (nonatomic, strong) UIButton *proButton;

@property (nonatomic, strong) UIButton *videoCallButton;
@property (nonatomic, strong) UIButton *phoneCallButton;
@property (nonatomic, strong) UIButton *conferencePhoneCallButton;
@property (nonatomic, strong) UIButton *conferenceVideoCallButton;
@property (nonatomic, strong) UILabel *callTypeLabel;



@property (nonatomic, strong) UIImageView *descFrameView;
@property (nonatomic, strong) UIImageView *descFrameLineView;

@property (nonatomic, strong) UILabel *pricingLabel;
@property (nonatomic, strong) UILabel *descrLabel;

@property (nonatomic, strong) UIView *yourPhoneView;
@property (nonatomic, strong) UIView *companionPhoneView;

@property (nonatomic, strong) UITextField *yourPhoneTextField;
@property (nonatomic, strong) UITextField *companionPhoneTextField;

@property (nonatomic, strong) UILabel *nonProDescription;
@property (nonatomic, strong) UILabel *proDescription;


@property (nonatomic, strong) UILabel* transToLabel;
@property (nonatomic, strong) NSString* transToStr;

@property (nonatomic, strong) UILabel* transFromLabel;
@property (nonatomic, strong) NSString* transFromStr;

@property (nonatomic, strong) UIActionSheet *fromActionSheet;
@property (nonatomic, strong) UIActionSheet *toActionSheet;

@property (nonatomic, strong) NSArray *toArray;
@property (nonatomic, strong) NSArray *fromArray;
@property (nonatomic, strong) NSDictionary *langDict;

@property (strong, nonatomic) UIImageView* blueCircleImageView;
@property (strong, nonatomic) UIView *descView;
@property (strong, nonatomic) UIView *proDescView;

@property (assign, nonatomic) BOOL isPro;
@property (assign, nonatomic) CallType callType;


@property (assign, nonatomic) BOOL menuOpened;
@end

@implementation OrderViewController

-(instancetype) init{
    self = [super init];
    
    if (self) {
        self.isPro = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bkgImageView.image = [Helper getImageByImageName:@"find_interpreter_background"];
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
    
//    self.descView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(-320, 80, 640, 100)]];
//    self.descView.backgroundColor = [UIColor clearColor];
//  //  [self.view addSubview:self.descView];
//    
//    UIView *palDescView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(320, 0, 320, 100)]];
//    palDescView.backgroundColor = [UIColor clearColor];
//    [self.descView addSubview:palDescView];
//    
//    UILabel *palPriceLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 10, 220, 20)]];
//    palPriceLabel.text = @"$100 min";
//    palPriceLabel.font = [Helper fontWithSize:16];
//    palPriceLabel.textColor = [UIColor whiteColor];
//    palPriceLabel.textAlignment = NSTextAlignmentLeft;
//    palPriceLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
//    palPriceLabel.shadowOffset = CGSizeMake(1, 1);
//    [palDescView addSubview:palPriceLabel];
//    
//    UILabel *palDescriptionLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 35, 220, 65)]];
//    palDescriptionLabel.text = @"Pal Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Aenean commodo ligula eget dolor. Aenean massa. Ipsum dolor sit amet, consectetuer.";
//    palDescriptionLabel.font = [Helper fontWithSize:12];
//    palDescriptionLabel.numberOfLines = 5;
//    palDescriptionLabel.textColor = [UIColor whiteColor];
//    palDescriptionLabel.textAlignment = NSTextAlignmentLeft;
//    palDescriptionLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
//    palDescriptionLabel.shadowOffset = CGSizeMake(1, 1);
//    [palDescView addSubview:palDescriptionLabel];
//    
//    self.proDescView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 320, 100)]];
//    self.proDescView.backgroundColor = [UIColor clearColor];
//    [self.descView addSubview:self.proDescView];
//    self.proDescView.hidden = YES;
//    
//    UILabel *proPriceLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 10, 220, 20)]];
//    proPriceLabel.text = @"$300 min";
//    proPriceLabel.font = [Helper fontWithSize:16];
//    proPriceLabel.textColor = [UIColor whiteColor];
//    proPriceLabel.textAlignment = NSTextAlignmentLeft;
//    proPriceLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
//    proPriceLabel.shadowOffset = CGSizeMake(1, 1);
//    [self.proDescView addSubview:proPriceLabel];
//    
//    UILabel *proDescriptionLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 35, 220, 65)]];
//    proDescriptionLabel.text = @"Pro Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Aenean commodo ligula eget dolor. Aenean massa. Ipsum dolor sit amet, consectetuer.";
//    proDescriptionLabel.font = [Helper fontWithSize:12];
//    proDescriptionLabel.numberOfLines = 5;
//    proDescriptionLabel.textColor = [UIColor whiteColor];
//    proDescriptionLabel.textAlignment = NSTextAlignmentLeft;
//    proDescriptionLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
//    proDescriptionLabel.shadowOffset = CGSizeMake(1, 1);
//    [self.proDescView addSubview:proDescriptionLabel];
    
    
    self.callTypeLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 55, 300, 18)]];
    self.callTypeLabel.textColor = [UIColor whiteColor];
    self.callTypeLabel.textAlignment = NSTextAlignmentCenter;
    self.callTypeLabel.font = [Helper fontWithSize:16];
    self.callTypeLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    self.callTypeLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:self.callTypeLabel];
    
    self.videoCallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.videoCallButton setImage:[Helper getImageByImageName:@"video_icon"] forState:UIControlStateNormal];
    [self.videoCallButton setImage:[Helper getImageByImageName:@"video_select_icon"] forState:UIControlStateSelected];
    self.videoCallButton.frame = [Helper getRectValue:CGRectMake(28, 75, 66, 66)];
    [self.videoCallButton addTarget:self action:@selector(videoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.videoCallButton];
    
    self.phoneCallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.phoneCallButton setImage:[Helper getImageByImageName:@"call_icon"] forState:UIControlStateNormal];
    [self.phoneCallButton setImage:[Helper getImageByImageName:@"call_select_icon"] forState:UIControlStateSelected];
    self.phoneCallButton.frame = [Helper getRectValue:CGRectMake(94, 75, 66, 66)];
    [self.phoneCallButton addTarget:self action:@selector(phoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.phoneCallButton];
    
    self.conferencePhoneCallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.conferencePhoneCallButton setImage:[Helper getImageByImageName:@"call2_icon"] forState:UIControlStateNormal];
    [self.conferencePhoneCallButton setImage:[Helper getImageByImageName:@"call2_select_icon"] forState:UIControlStateSelected];
    self.conferencePhoneCallButton.frame = [Helper getRectValue:CGRectMake(160, 75, 66, 66)];
    [self.conferencePhoneCallButton addTarget:self action:@selector(conferencePhoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.conferencePhoneCallButton];
    
    self.conferenceVideoCallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.conferenceVideoCallButton setImage:[Helper getImageByImageName:@"video2_icon"] forState:UIControlStateNormal];
    [self.conferenceVideoCallButton setImage:[Helper getImageByImageName:@"video2_select_icon"] forState:UIControlStateSelected];
    self.conferenceVideoCallButton.frame = [Helper getRectValue:CGRectMake(226, 75, 66, 66)];
    [self.conferenceVideoCallButton addTarget:self action:@selector(conferenceVideoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.conferenceVideoCallButton];
    
    self.descFrameView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"frame"]];
    self.descFrameView.center = [Helper getPointValue:CGPointMake(160, 198.5f)];
    [self.view addSubview:self.descFrameView];
    self.descFrameView.alpha = 0;
    
    UILabel *pricingTitleLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 10, 100, 15)]];
    pricingTitleLabel.text = @"PRICING";
    pricingTitleLabel.textColor = [UIColor whiteColor];
    pricingTitleLabel.textAlignment = NSTextAlignmentLeft;
    pricingTitleLabel.font = [Helper fontWithSize:12];
    pricingTitleLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    pricingTitleLabel.shadowOffset = CGSizeMake(1, 1);
    [self.descFrameView addSubview:pricingTitleLabel];
    
    self.pricingLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 25, 100, 55)]];
    self.pricingLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor exercitation ullamco laboris";
    self.pricingLabel.textColor = [UIColor whiteColor];
    self.pricingLabel.textAlignment = NSTextAlignmentLeft;
    self.pricingLabel.font = [Helper fontWithSize:8];
    self.pricingLabel.numberOfLines = 6;
    self.pricingLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    self.pricingLabel.shadowOffset = CGSizeMake(1, 1);
    [self.descFrameView addSubview:self.pricingLabel];
    
    UILabel *descrTitleLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(130, 10, 100, 15)]];
    descrTitleLabel.text = @"DESCRIPTION";
    descrTitleLabel.textColor = [UIColor whiteColor];
    descrTitleLabel.textAlignment = NSTextAlignmentLeft;
    descrTitleLabel.font = [Helper fontWithSize:12];
    descrTitleLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    descrTitleLabel.shadowOffset = CGSizeMake(1, 1);
    [self.descFrameView addSubview:descrTitleLabel];
    
    self.descrLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(130, 25, 100, 55)]];
    self.descrLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor exercitation ullamco laboris";
    self.descrLabel.textColor = [UIColor whiteColor];
    self.descrLabel.textAlignment = NSTextAlignmentLeft;
    self.descrLabel.font = [Helper fontWithSize:8];
    self.descrLabel.numberOfLines = 6;
    self.descrLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    self.descrLabel.shadowOffset = CGSizeMake(1, 1);
    [self.descFrameView addSubview:self.descrLabel];
    
    self.descFrameLineView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"frame_line"]];
    self.descFrameLineView.center = [Helper getPointValue:CGPointMake(61, 143)];
    [self.view addSubview:self.descFrameLineView];
    self.descFrameLineView.alpha = 0;

    self.yourPhoneView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 260, 320, 60)]];
    self.yourPhoneView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.yourPhoneView];
    self.yourPhoneView.hidden = YES;
    
    
    UILabel *yourPhoneLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 0, 220, 14)]];
    yourPhoneLabel.text = @"YOUR PHONE NUMBER";
    yourPhoneLabel.font = [Helper fontWithSize:12];
    yourPhoneLabel.textColor = [UIColor whiteColor];
    yourPhoneLabel.textAlignment = NSTextAlignmentLeft;
    yourPhoneLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    yourPhoneLabel.shadowOffset = CGSizeMake(1, 1);
    [self.yourPhoneView addSubview:yourPhoneLabel];
    
    UIImageView *yourPhoneBKG = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"text_cell"]];
    yourPhoneBKG.frame = [Helper getRectValue:CGRectMake(40, 15, 240, 30)];
    yourPhoneBKG.userInteractionEnabled = YES;
    [self.yourPhoneView addSubview:yourPhoneBKG];
    
    self.yourPhoneTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 5, 200, 20)]];
    self.yourPhoneTextField.textColor = [UIColor colorWithRed:(122.0f/255.0f) green:(122.0f/255.0f) blue:(126.0f/255.0f) alpha:1.0f];
    self.yourPhoneTextField.font = [Helper fontWithSize:14];
    self.yourPhoneTextField.backgroundColor = [UIColor clearColor];
    self.yourPhoneTextField.delegate = self;
    self.yourPhoneTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    [yourPhoneBKG addSubview:self.yourPhoneTextField];

    
    self.companionPhoneView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 320, 320, 65)]];
    self.companionPhoneView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.companionPhoneView];
    self.companionPhoneView.hidden = YES;
    
    UILabel *companionPhoneLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 0, 220, 14)]];
    companionPhoneLabel.text = @"YOUR COMPANION IPHONE NUMBER";
    companionPhoneLabel.font = [Helper fontWithSize:12];
    companionPhoneLabel.textColor = [UIColor whiteColor];
    companionPhoneLabel.textAlignment = NSTextAlignmentLeft;
    companionPhoneLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    companionPhoneLabel.shadowOffset = CGSizeMake(1, 1);
    [self.companionPhoneView addSubview:companionPhoneLabel];
    
    UIImageView *companionPhoneBKG = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"text_cell"]];
    companionPhoneBKG.frame = [Helper getRectValue:CGRectMake(40, 15, 240, 30)];
    companionPhoneBKG.userInteractionEnabled = YES;
    [self.companionPhoneView addSubview:companionPhoneBKG];

    self.companionPhoneTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 5, 200, 20)]];
    self.companionPhoneTextField.textColor = [UIColor colorWithRed:(122.0f/255.0f) green:(122.0f/255.0f) blue:(126.0f/255.0f) alpha:1.0f];
    self.companionPhoneTextField.font = [Helper fontWithSize:14];
    self.companionPhoneTextField.backgroundColor = [UIColor clearColor];
    self.companionPhoneTextField.delegate = self;
    self.companionPhoneTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    [companionPhoneBKG addSubview:self.companionPhoneTextField];
    
    
    self.bottomBkgView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 210, 320, 180)]];
    self.bottomBkgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bottomBkgView];

    UILabel *transFrom = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 0, 220, 14)]];
    transFrom.text = @"TRANSLATE FROM";
    transFrom.font = [Helper fontWithSize:12];
    transFrom.textColor = [UIColor whiteColor];
    transFrom.textAlignment = NSTextAlignmentLeft;
    transFrom.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    transFrom.shadowOffset = CGSizeMake(1, 1);
    [self.bottomBkgView addSubview:transFrom];

    
    UIImageView *transFromBKG = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"text_cell"]];
    transFromBKG.frame = [Helper getRectValue:CGRectMake(40, 15, 240, 30)];
    transFromBKG.userInteractionEnabled = YES;
    [self.bottomBkgView addSubview:transFromBKG];
    
    self.transFromLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 5, 200, 20)]];
    self.transFromLabel.text = @"options";
    self.transFromLabel.textColor = [UIColor colorWithRed:(122.0f/255.0f) green:(122.0f/255.0f) blue:(126.0f/255.0f) alpha:1.0f];
    self.transFromLabel.font = [Helper fontWithSize:14];
    self.transFromLabel.backgroundColor = [UIColor clearColor];
    [transFromBKG addSubview:self.transFromLabel];
    
    UIButton* transFromButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [transFromButton setBackgroundImage:[Helper getImageByImageName:@"text_cell_arrow"] forState:UIControlStateNormal];
    transFromButton.frame = [Helper getRectValue:CGRectMake(210, 0, 30, 30)];
    [transFromButton addTarget:self action:@selector(translateFromAction:) forControlEvents:UIControlEventTouchUpInside];
    [transFromBKG addSubview:transFromButton];
    
    UILabel *transTo = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 60, 220, 14)]];
    transTo.text = @"TRANSLATE TO";
    transTo.font = [Helper fontWithSize:12];
    transTo.textColor = [UIColor whiteColor];
    transTo.textAlignment = NSTextAlignmentLeft;
    transTo.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    transTo.shadowOffset = CGSizeMake(1, 1);
    [self.bottomBkgView addSubview:transTo];
    
    UIImageView *transToBKG = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"text_cell"]];
    transToBKG.frame = [Helper getRectValue:CGRectMake(40, 75, 240,30)];
    transToBKG.userInteractionEnabled = YES;
    [self.bottomBkgView addSubview:transToBKG];
    
    self.transToLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 5, 200, 20)]];
    self.transToLabel.text = @"options";
    self.transToLabel.backgroundColor = [UIColor clearColor];
    self.transToLabel.textColor = [UIColor colorWithRed:(122.0f/255.0f) green:(122.0f/255.0f) blue:(126.0f/255.0f) alpha:1.0f];
    self.transToLabel.font = [Helper fontWithSize:14];
    [transToBKG addSubview:self.transToLabel];
    
    UIButton* transToButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [transToButton setBackgroundImage:[Helper getImageByImageName:@"text_cell_arrow"] forState:UIControlStateNormal];
    transToButton.frame = [Helper getRectValue:CGRectMake(210, 0, 30, 30)];
    [transToButton addTarget:self action:@selector(translateToAction:) forControlEvents:UIControlEventTouchUpInside];
    [transToBKG addSubview:transToButton];
    
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundImage:[Helper getImageByImageName:@"next_cell"] forState:UIControlStateNormal];
    [nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [Helper fontWithSize:14];
    nextButton.frame = [Helper getRectValue:CGRectMake(40, 135, 240, 30)];
    [nextButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBkgView addSubview:nextButton];
    
    UIView *professionalView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, [Helper isiPhone4] ? 380 : 468, 320, 100)]];
    professionalView.backgroundColor = [UIColor clearColor];
  //  [self.view addSubview:professionalView];
    
//    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
//    leftSwipeGesture.delegate = self;
//    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
//    [professionalView addGestureRecognizer:leftSwipeGesture];
//    
//    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
//    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
//    [professionalView addGestureRecognizer:rightSwipeGesture];
//    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [professionalView addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [professionalView addGestureRecognizer:panGesture];
    
    UILabel *palLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 12, 100, 14)]];
    palLabel.text = @"Lingvo Pal";
    palLabel.font = [Helper fontWithSize:12];
    palLabel.textColor = [UIColor whiteColor];
    palLabel.backgroundColor = [UIColor clearColor];
    palLabel.textAlignment = NSTextAlignmentLeft;
    palLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    palLabel.shadowOffset = CGSizeMake(1, 1);
    [professionalView addSubview:palLabel];
    
    UILabel *proLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(175, 12, 100, 14)]];
    proLabel.text = @"Lingvo Pro";
    proLabel.font = [Helper fontWithSize:12];
    proLabel.textColor = [UIColor whiteColor];
    proLabel.backgroundColor = [UIColor clearColor];
    proLabel.textAlignment = NSTextAlignmentRight;
    proLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    proLabel.shadowOffset = CGSizeMake(1, 1);
    [professionalView addSubview:proLabel];
  
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"scale"]];
    lineImageView.center = [Helper getPointValue:CGPointMake(160, 55)];
    [professionalView addSubview:lineImageView];
    
    self.blueCircleImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"scale_ellipse"]];
    self.blueCircleImageView.center = [Helper getPointValue:CGPointMake(50, 55)];
    [professionalView addSubview:self.blueCircleImageView];
}

-(void) videoAction:(UIButton *) button{
    [self closeKeyboards];
    [UIView beginAnimations:@"MOVMENT" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if (self.videoCallButton.selected) {
        [UIView setAnimationDuration:UP_ANIMATION_DURATION];
        self.phoneCallButton.selected = NO;
        self.videoCallButton.selected = NO;
        self.conferencePhoneCallButton.selected = NO;
        self.conferenceVideoCallButton.selected = NO;
        self.callType = sntzInvalidCall;
        
        self.bottomBkgView.center = [Helper getPointValue:CGPointMake(160, 300)];
        self.descFrameView.alpha = 0;
        self.descFrameLineView.alpha = 0;
       
    } else {
        [UIView setAnimationDuration:DOWN_ANIMATION_DURATION];
        self.phoneCallButton.selected = NO;
        self.videoCallButton.selected = YES;
        self.conferencePhoneCallButton.selected = NO;
        self.conferenceVideoCallButton.selected = NO;
        self.callType = sntzVideoCall;
        
        self.descFrameLineView.center = [Helper getPointValue:CGPointMake(61, 143)];
        self.bottomBkgView.center = [Helper getPointValue:CGPointMake(160, 360)];
        self.descFrameView.alpha = 1;
        self.descFrameLineView.alpha = 1;
        
        self.pricingLabel.text = @"Pricing Video call. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor exercitation ullamco laboris";
        self.descrLabel.text = @"Descr Video call. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor exercitation ullamco laboris";
    }
    
    self.yourPhoneView.hidden = YES;
    self.companionPhoneView.hidden = YES;
    self.callTypeLabel.text = [Helper getCallType:self.callType];
    
    [UIView commitAnimations];
}

-(void) phoneAction:(UIButton *) button{
    [self closeKeyboards];
    
    [UIView beginAnimations:@"MOVMENT" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if (self.phoneCallButton.selected) {
        [UIView setAnimationDuration:UP_ANIMATION_DURATION];
        self.phoneCallButton.selected = NO;
        self.videoCallButton.selected = NO;
        self.conferencePhoneCallButton.selected = NO;
        self.conferenceVideoCallButton.selected = NO;
        self.callType = sntzInvalidCall;
        
        self.bottomBkgView.center = [Helper getPointValue:CGPointMake(160, 300)];
        self.descFrameView.alpha = 0;
        self.descFrameLineView.alpha = 0;
        self.yourPhoneView.hidden = YES;
        
    } else {
        [UIView setAnimationDuration:DOWN_ANIMATION_DURATION];
        self.phoneCallButton.selected = YES;
        self.videoCallButton.selected = NO;
        self.conferencePhoneCallButton.selected = NO;
        self.conferenceVideoCallButton.selected = NO;
        self.callType = sntzPhoneCall;
        
        self.descFrameLineView.center = [Helper getPointValue:CGPointMake(127, 143)];
        self.bottomBkgView.center = [Helper getPointValue:CGPointMake(160, 410)];
        self.descFrameView.alpha = 1;
        self.descFrameLineView.alpha = 1;
        
        self.yourPhoneView.hidden = NO;
        
        self.pricingLabel.text = @"Pricing Phone call. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor exercitation ullamco laboris";
        self.descrLabel.text = @"Descr Phone call. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor exercitation ullamco laboris";

    }
    
    self.callTypeLabel.text = [Helper getCallType:self.callType];
    self.companionPhoneView.hidden = YES;
    [UIView commitAnimations];
}

-(void) conferencePhoneAction:(UIButton *) button{
    [self closeKeyboards];
    [UIView beginAnimations:@"MOVMENT" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if (self.conferencePhoneCallButton.selected) {
        [UIView setAnimationDuration:UP_ANIMATION_DURATION];
        self.phoneCallButton.selected = NO;
        self.videoCallButton.selected = NO;
        self.conferencePhoneCallButton.selected = NO;
        self.conferenceVideoCallButton.selected = NO;
        self.callType = sntzInvalidCall;
        
        self.bottomBkgView.center = [Helper getPointValue:CGPointMake(160, 300)];
        self.descFrameView.alpha = 0;
        self.descFrameLineView.alpha = 0;
        
        self.yourPhoneView.hidden = YES;
        self.companionPhoneView.hidden = YES;
        
    } else {
        [UIView setAnimationDuration:DOWN_ANIMATION_DURATION];
        self.phoneCallButton.selected = NO;
        self.videoCallButton.selected = NO;
        self.conferencePhoneCallButton.selected = YES;
        self.conferenceVideoCallButton.selected = NO;
        self.callType = sntzConfPhoneCall;
        
        self.descFrameLineView.center = [Helper getPointValue:CGPointMake(193, 143)];
        self.bottomBkgView.center = [Helper getPointValue:CGPointMake(160, 470)];
        self.descFrameView.alpha = 1;
        self.descFrameLineView.alpha = 1;
        
        self.yourPhoneView.hidden = NO;
        self.companionPhoneView.hidden = NO;
        
        self.pricingLabel.text = @"Pricing Conferance Phone call. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor exercitation ullamco laboris";
        self.descrLabel.text = @"Descr Conferance Phone call. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor exercitation ullamco laboris";
    }
    
    self.callTypeLabel.text = [Helper getCallType:self.callType];
    
    [UIView commitAnimations];
}

-(void) conferenceVideoAction:(UIButton *) button{
    [self closeKeyboards];
    [UIView beginAnimations:@"MOVMENT" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if (self.conferenceVideoCallButton.selected) {
        [UIView setAnimationDuration:UP_ANIMATION_DURATION];
        self.phoneCallButton.selected = NO;
        self.videoCallButton.selected = NO;
        self.conferencePhoneCallButton.selected = NO;
        self.conferenceVideoCallButton.selected = NO;
        self.callType = sntzInvalidCall;
        
        self.bottomBkgView.center = [Helper getPointValue:CGPointMake(160, 300)];
        self.descFrameView.alpha = 0;
        self.descFrameLineView.alpha = 0;
        
    }else {
        [UIView setAnimationDuration:DOWN_ANIMATION_DURATION];
        self.phoneCallButton.selected = NO;
        self.videoCallButton.selected = NO;
        self.conferencePhoneCallButton.selected = NO;
        self.conferenceVideoCallButton.selected = YES;
        self.callType = sntzConfVideoCall;
        self.descFrameLineView.center = [Helper getPointValue:CGPointMake(259, 143)];
        self.bottomBkgView.center = [Helper getPointValue:CGPointMake(160, 360)];
        self.descFrameView.alpha = 1;
        self.descFrameLineView.alpha = 1;
        
        self.pricingLabel.text = @"Pricing Conferance Video call. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor exercitation ullamco laboris";
        self.descrLabel.text = @"Descr Conferance Video call. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor exercitation ullamco laboris";
    }
    
    self.yourPhoneView.hidden = YES;
    self.companionPhoneView.hidden = YES;
    self.callTypeLabel.text = [Helper getCallType:self.callType];
    
    [UIView commitAnimations];
}



-(void) leftMenuOpened{
//    self.proDescView.hidden = YES;
}

-(void) leftMenuClosed{
  //  self.proDescView.hidden = NO;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


-(void) swipeGestureAction:(UISwipeGestureRecognizer *) gesture{
    [UIView beginAnimations:@"shadowMoveRestAway" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if(gesture.direction == UISwipeGestureRecognizerDirectionRight){
        self.blueCircleImageView.center = [Helper getPointValue:CGPointMake(270, 55)];
        self.descView.center = [Helper getPointValue:CGPointMake(320, 130)];
        self.isPro = YES;
    } else if(gesture.direction == UISwipeGestureRecognizerDirectionLeft){
        self.blueCircleImageView.center = [Helper getPointValue:CGPointMake(50, 55)];
        self.descView.center = [Helper getPointValue:CGPointMake(0, 130)];
        self.isPro = NO;
        
    }

    [UIView commitAnimations];
    
}

-(void) tapGestureAction:(UITapGestureRecognizer *) gesture{
    CGPoint location = [gesture locationInView:gesture.view];
    NSLog(@"location : %@", NSStringFromCGPoint(location));
    
    [UIView beginAnimations:@"shadowMoveRestAway" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if (CGRectContainsPoint([Helper getRectValue:CGRectMake(30, 35, 40, 40)], location)) {
        self.blueCircleImageView.center = [Helper getPointValue:CGPointMake(50, 55)];
        self.descView.center = [Helper getPointValue:CGPointMake(0, 130)];
        self.isPro = NO;
        self.proDescView.hidden = YES;
    } else if (CGRectContainsPoint([Helper getRectValue:CGRectMake(250, 35, 40, 40)], location)){
        self.blueCircleImageView.center = [Helper getPointValue:CGPointMake(270, 55)];
        self.descView.center = [Helper getPointValue:CGPointMake(320, 130)];
        self.isPro = YES;
        self.proDescView.hidden = NO;
    }
    
    [UIView commitAnimations];
}

-(void) panGestureAction:(UIPanGestureRecognizer *) gesture{
    CGPoint location = [gesture locationInView:gesture.view];
    NSLog(@"pan location : %@", NSStringFromCGPoint(location));
    
    NSInteger pointX = location.x;
    pointX = MIN([Helper getValue:270], pointX);
    pointX = MAX([Helper getValue:50], pointX);
    self.blueCircleImageView.center = CGPointMake(pointX, [Helper getValue:55]);
    self.descView.center = [Helper getPointValue:CGPointMake((pointX  -  [Helper getValue:50] )* (320.0f/220.0f), 130)];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.proDescView.hidden = NO;
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [UIView beginAnimations:@"panEnd" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  
        
        if (pointX < [Helper getValue:160]) {
            self.blueCircleImageView.center = [Helper getPointValue:CGPointMake(50, 55)];
            self.descView.center = [Helper getPointValue:CGPointMake(0, 130)];
            self.isPro = NO;
            self.proDescView.hidden = YES;
        } else {
            self.blueCircleImageView.center = [Helper getPointValue:CGPointMake(270, 55)];
            self.descView.center = [Helper getPointValue:CGPointMake(320, 130)];
            self.isPro = YES;
            self.proDescView.hidden = NO;
        }
        
        [UIView commitAnimations];
    }
    
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

-(void) nonProTopAction:(UIButton *) button{
    self.nonProTopButton.selected = !self.nonProTopButton.selected;
    self.proTopButton.selected = NO;
    
}

-(void) proTopAction:(UIButton *) button{
    self.proTopButton.selected = !self.proTopButton.selected;
    self.nonProTopButton.selected = NO;
}

//-(void) nonProAction:(UIButton *) button{
//    self.nonProButton.selected = !self.nonProButton.selected;
//    
//    if (self.nonProButton.selected) {
//        self.nonProButton.frame = [Helper getRectValue:CGRectMake(40, 251, 118, 19)];
//        self.nonProDescription.hidden = NO;
//    } else {
//        self.nonProButton.frame = [Helper getRectValue:CGRectMake(40, 191, 118, 19)];
//        self.nonProDescription.hidden = YES;
//    }
//    
//    if(self.nonProButton.selected || self.proButton.selected){
//        self.bottomBkgView.center = [Helper getPointValue:CGPointMake(160, 360)];
//    } else {
//        self.bottomBkgView.center = [Helper getPointValue:CGPointMake(160, 300)];
//    }
//}
//
//
//
//-(void) proAction:(UIButton *) button{
//    self.proButton.selected = !self.proButton.selected;
//    
//    if (self.proButton.selected) {
//        self.proButton.frame = [Helper getRectValue:CGRectMake(163, 251, 118, 19)];
//        self.proDescription.hidden = NO;
//    } else {
//        self.proButton.frame = [Helper getRectValue:CGRectMake(163, 191, 118, 19)];
//        self.proDescription.hidden = YES;
//    }
//    
//    if(self.nonProButton.selected || self.proButton.selected){
//        self.bottomBkgView.center = [Helper getPointValue:CGPointMake(160, 360)];
//    } else {
//        self.bottomBkgView.center = [Helper getPointValue:CGPointMake(160, 300)];
//    }
//}


-(void) translateFromAction:(UIButton *) button{
    [self closeKeyboards];
    
    self.fromActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please specify from language:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *lang in self.fromArray) {
        [self.fromActionSheet addButtonWithTitle:[Helper getLanguageFromABRV:lang]];
    }
    
    [self.fromActionSheet showInView:self.view];
}

-(void) translateToAction:(UIButton *) button{
    [self closeKeyboards];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) menuAction:(UIButton *) button{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.menuViewController toggleLeftSideMenuCompletion:^{

    }];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self closeKeyboards];
    return YES;
}

-(void) closeKeyboards{
    [self.yourPhoneTextField resignFirstResponder];
    [self.companionPhoneTextField resignFirstResponder];
}
-(void) searchAction:(UIButton *) button{
    
//    if ([self.transFromStr length] == 0) {
//        [Helper showAlertViewWithText:@"Please select FROM language" delegate:nil];
//        return;
//    }
//    
//    if ([self.transToStr length] == 0) {
//        [Helper showAlertViewWithText:@"Please select TO language" delegate:nil];
//        return;
//    }
//    
//    if (self.callType == sntzInvalidCall) {
//        [Helper showAlertViewWithText:@"Please select call type" delegate:nil];
//        return;
//    }
    [self.navigationController popViewControllerAnimated:YES];

//    DateSelectionViewController *viewController = [[DateSelectionViewController alloc] init];
//    viewController.isPro = self.isPro;
//    viewController.fromLang = self.transFromStr;
//    viewController.toLang = self.transToStr;
//    viewController.callType = self.callType;
//    viewController.number1 = self.yourPhoneTextField.text;
//    viewController.number2 = self.companionPhoneTextField.text;
//    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark  UIActionSheetDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != 0) {
        if (actionSheet == self.fromActionSheet) {
            self.transFromStr = [self.fromArray objectAtIndex:(buttonIndex - 1)];
            self.transFromLabel.text = [Helper getLanguageFromABRV:self.transFromStr];
            self.toArray = [self.langDict objectForKey:self.transFromStr];
            
            self.transToLabel.text = @"options";
            self.transToStr = nil;
        }
        
        if (actionSheet == self.toActionSheet) {
            self.transToStr = [self.toArray objectAtIndex:(buttonIndex - 1)];
            self.transToLabel.text = [Helper getLanguageFromABRV:self.transToStr];
        }
    }
}


#pragma mark PortalSessionDelegate

-(void) getLangsResponse:(NSDictionary *)dict{
    NSLog(@"getLangsResponse %@", dict);
    
    self.langDict = [dict objectForKey:@"langs"];
    self.fromArray = [self.langDict allKeys];
    [self stopAnimation];
    
//    NSString *prefLang =   [[NSUserDefaults standardUserDefaults] objectForKey:@"preferedLang"];
//    
//    if ([self.fromArray containsObject:prefLang]) {
//        self.transFromStr = prefLang;
//        self.transFromLabel.text = [Helper getLanguageFromABRV:self.transFromStr];
//        self.toArray = [self.langDict objectForKey:self.transFromStr];
//        
//        self.transToLabel.text = @"options";
//        self.transToStr = nil;
//    }
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




@end
