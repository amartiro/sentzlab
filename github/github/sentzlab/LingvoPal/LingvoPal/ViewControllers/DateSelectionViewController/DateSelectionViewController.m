//
//  DateSelectionViewController.m
//  LingvoPal
//
//  Created by Artak on 12/8/15.
//  Copyright © 2015 SentzLab. All rights reserved.
//

#import "DateSelectionViewController.h"
#import "Helper.h"
#import <QuartzCore/QuartzCore.h>
#import "PortalSession.h"

#import "ClientWaitingViewController.h"

#import "PortalSession.h"

@interface DateSelectionViewController () <PortalSessionDelegate>

@property (strong, nonatomic) UIButton *searchButton;
@property (strong, nonatomic) UIView *middleBKGView;

@property (strong, nonatomic) UIButton *nowButton;
@property (strong, nonatomic) UIButton *anotherButton;

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *toLabel;
@property (strong, nonatomic) UILabel *fromLabel;
@property (strong, nonatomic) UILabel *proLabel;
@property (strong, nonatomic) UILabel *callTypeLabel;

@property (strong ,nonatomic) UIView *dateView;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) UIDatePicker *datePicker;


@end

@implementation DateSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.bkgImageView.image = [Helper getImageByImageName:@"translate_from_gradient"];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[Helper getImageByImageName:@"back_icon"] forState:UIControlStateNormal];
    backButton.frame = [Helper getRectValue:CGRectMake(5, 20, 26, 42)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    self.middleBKGView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 150, 240, 120)]];
    self.middleBKGView.layer.cornerRadius = [Helper getValue:5];
    self.middleBKGView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.8f];
    [self.view addSubview:self.middleBKGView];
    
    UIImageView *tickImageViewTime = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"tick_ellipse"]];
    tickImageViewTime.center = [Helper getPointValue:CGPointMake(15, 15)];
    [self.middleBKGView addSubview:tickImageViewTime];
    
    UILabel *timeStaticLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(30, 5, 40, 20)]];
    timeStaticLabel.text = @"Time:";
    timeStaticLabel.textColor = [UIColor colorWithRed:(116.0f/255.0f) green:(116.0f/255.0f) blue:(116.0f/255.0f) alpha:1.0f];
    timeStaticLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:timeStaticLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 5, 100, 20)]];
    self.timeLabel.text = @"Now";
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:self.timeLabel];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"white_long_line"]];
    lineImageView.center = [Helper getPointValue:CGPointMake(120, 30)];
    [self.middleBKGView addSubview:lineImageView];
    
    UIImageView *tickImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"tick_ellipse"]];
    tickImageView.center = [Helper getPointValue:CGPointMake(15, 45)];
    [self.middleBKGView addSubview:tickImageView];
    
    UILabel *fromStaticLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(30, 35, 40, 20)]];
    fromStaticLabel.text = @"From:";
    fromStaticLabel.textColor = [UIColor colorWithRed:(116.0f/255.0f) green:(116.0f/255.0f) blue:(116.0f/255.0f) alpha:1.0f];
    fromStaticLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:fromStaticLabel];
  
    self.fromLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 35, 100, 20)]];
    self.fromLabel.text = [Helper getLanguageFromABRV:self.fromLang];
    self.fromLabel.textColor = [UIColor blackColor];
    self.fromLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:self.fromLabel];
    
    UIImageView *tickImageView1 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"tick_ellipse"]];
    tickImageView1.center = [Helper getPointValue:CGPointMake(15, 75)];
    [self.middleBKGView addSubview:tickImageView1];
    
    UIImageView *lineImageView1 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"white_long_line"]];
    lineImageView1.center = [Helper getPointValue:CGPointMake(120, 60)];
    [self.middleBKGView addSubview:lineImageView1];

    UILabel *toStaticLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(30, 65, 20, 20)]];
    toStaticLabel.text = @"To:";
    toStaticLabel.textColor = [UIColor colorWithRed:(116.0f/255.0f) green:(116.0f/255.0f) blue:(116.0f/255.0f) alpha:1.0f];
    toStaticLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:toStaticLabel];
    
    self.toLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 65, 100, 20)]];
    self.toLabel.text = [Helper getLanguageFromABRV:self.toLang];
    self.toLabel.textColor = [UIColor blackColor];
    self.toLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:self.toLabel];
    
    UIImageView *tickImageView2 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"tick_ellipse"]];
    tickImageView2.center = [Helper getPointValue:CGPointMake(15, 105)];
    [self.middleBKGView addSubview:tickImageView2];
    
    UIImageView *lineImageView2 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"white_long_line"]];
    lineImageView2.center = [Helper getPointValue:CGPointMake(120, 90)];
    [self.middleBKGView addSubview:lineImageView2];
    
    UILabel *callTypeStaticLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(30, 95, 60, 20)]];
    callTypeStaticLabel.text = @"Call Type:";
    callTypeStaticLabel.textColor = [UIColor colorWithRed:(116.0f/255.0f) green:(116.0f/255.0f) blue:(116.0f/255.0f) alpha:1.0f];
    callTypeStaticLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:callTypeStaticLabel];
    
    self.callTypeLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 95, 160, 20)]];
    self.callTypeLabel.text = [Helper getCallType:self.callType];
    self.callTypeLabel.textColor = [UIColor blackColor];
    self.callTypeLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:self.callTypeLabel];
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.searchButton setBackgroundImage:[Helper getImageByImageName:@"login_cell"] forState:UIControlStateNormal];
    [self.searchButton setTitle:@"SEARCH" forState:UIControlStateNormal];
    self.searchButton.titleLabel.font = [Helper fontWithSize:14];
    self.searchButton.frame = [Helper getRectValue:CGRectMake(25, 300, 271, 34)];
    [self.searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchButton];
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) searchAction:(UIButton *) button{
    
    [self startAnimation];
    self.searchButton.userInteractionEnabled = NO;
    
    [self setReserve];
}


-(void) showDatePickerStuff{
    if (self.dateView ==  nil) {
        self.dateView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 280, 320, 230)]];
        self.dateView.backgroundColor = [UIColor whiteColor];
        
        self.dateView.center = CGPointMake([Helper getValue:160], [UIScreen mainScreen].bounds.size.height - [Helper getValue:115]);
        
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.backgroundColor = [UIColor whiteColor];
        self.datePicker.center = [Helper getPointValue:CGPointMake(160, 140)];
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [self.dateView addSubview:self.datePicker];
        
        UIToolbar* picketToolBar = [[UIToolbar alloc] init];
        picketToolBar.frame = [Helper getRectValue:CGRectMake(0, 0, 320, 40)];
        picketToolBar.barStyle = UIBarStyleBlack;
        picketToolBar.translucent = YES;
        picketToolBar.tintColor = nil;
        [self.dateView addSubview:picketToolBar];
        
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone target:self
                                                                      action:@selector(doneClicked:)];
        UIBarButtonItem*spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                         style:UIBarButtonItemStyleDone target:self
                                                                        action:@selector(cancelClicked:)];
        
        [picketToolBar setItems:[NSArray arrayWithObjects:doneButton, spaceButton, cancelButton, nil]];
    }
    
    self.datePicker.minimumDate = [NSDate date];
    if(self.date){
        self.datePicker.date = self.date;
    }
    [self.view addSubview:self.dateView];
    
}

-(void) nowAction:(UIButton *) button{
    if (self.date != nil) {
        [self showDatePickerStuff];
    }
}

-(void) otherAction:(UIButton *) button{
    
    if (self.date == nil) {
        [self showDatePickerStuff];
    } else {
        self.date = nil;
        [self.nowButton setTitle:@"Now" forState:UIControlStateNormal];
        self.nowButton.frame = [Helper getRectValue:CGRectMake(0, 5, 80, 20)];
        [self.nowButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.anotherButton setTitle:@"Another time" forState:UIControlStateNormal];
    }
}


-(void) doneClicked:(UIBarButtonItem *) button{
    self.date = self.datePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM d, hh:mm"];
    NSString *dateString = [dateFormat stringFromDate:self.date];
    
    [self.nowButton setTitleColor:[UIColor colorWithRed:(41.0f/255.0f) green:(221.0f/255.0f) blue:(242.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    [self.nowButton setTitle:dateString forState:UIControlStateNormal];
    [self.anotherButton setTitle:@"Now" forState:UIControlStateNormal];
    self.nowButton.frame = [Helper getRectValue:CGRectMake(30, 5, 80, 20)];
    
    [self.dateView removeFromSuperview];
}

-(void) cancelClicked:(UIBarButtonItem *) button{
    [self.dateView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setReserve{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session setReserveOfTranslatorFromLanguage:self.fromLang toLanguage:self.toLang withIsPro:self.isPro withPhoneNumber1:self.number1 withPhoneNumber2:self.number2 andTime:self.time andCallType:self.callType];
    [self startAnimation];
}


#pragma mark PortalSessionDelegate

-(void) setReserveResponse:(NSDictionary *) dict{
    NSLog(@"setReserveResponse %@", dict);
    [self stopAnimation];
    
    ClientWaitingViewController *viewController = [[ClientWaitingViewController alloc] init];
    viewController.fromLang = self.fromLang;
    viewController.toLang = self.toLang;
    viewController.isPro = self.isPro;
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
