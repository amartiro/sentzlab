//
//  RatingViewController.m
//  LingvoPal
//
//  Created by Artak on 12/18/15.
//  Copyright © 2015 SentzLab. All rights reserved.
//

#import "RatingViewController.h"
#import "Helper.h"
#import "PortalSession.h"
#import "HistoryItem.h"

@interface RatingViewController() <PortalSessionDelegate, UITextViewDelegate>

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *profileBkgView;
@property (strong, nonatomic) UILabel *transNameLabel;
@property (strong, nonatomic) UIImageView *transProfileImage;
@property (strong, nonatomic) UIView *rateView;

@property (strong, nonatomic) UIImageView *star1View;
@property (strong, nonatomic) UIImageView *star2View;
@property (strong, nonatomic) UIImageView *star3View;
@property (strong, nonatomic) UIImageView *star4View;
@property (strong, nonatomic) UIImageView *star5View;
@property (strong, nonatomic) UILabel *proLabel;


@property (strong, nonatomic) UILabel *symbolCountLabel;
@property (strong, nonatomic) UITextView *reviewTextView;
@property (strong, nonatomic) UIButton *sendButton;

@property (assign, nonatomic) NSInteger rate;



@property (strong, nonatomic) UIView *oldRateView;

@end

@implementation RatingViewController


-(instancetype) init{
    self = [super init];
    
    if (self) {

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bkgImageView.image = [Helper getImageByImageName:@"rate_gradient"];
   
    self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.contentView];
  
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[Helper getImageByImageName:@"back_icon"] forState:UIControlStateNormal];
    backButton.frame = [Helper getRectValue:CGRectMake(5, 20, 26, 42)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
        
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(20, 60, 280, 20)]];
    titleLabel.text = @"RATINGS AND REVIEWS";
    titleLabel.font = [Helper fontWithSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    [self.contentView addSubview:titleLabel];
    
    self.profileBkgView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 90, 240, 120)]];
    self.profileBkgView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:.8f];
    self.profileBkgView.layer.cornerRadius = [Helper getValue:5];
    [self.contentView addSubview:self.profileBkgView];
    
    self.transProfileImage = [[UIImageView alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 15, 80, 80)]];
    self.transProfileImage.image = [Helper getImageByImageName:@"translater_profile_cell"];
    [self.profileBkgView addSubview:self.transProfileImage];

    self.transNameLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 15, 120, 25)]];
    self.transNameLabel.font = [Helper fontWithSize:22];
    [self.profileBkgView addSubview:self.transNameLabel];
    
    self.proLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 50, 120, 20)]];
    self.proLabel.text = @"Pro";
    self.proLabel.textColor = [UIColor darkGrayColor];
    self.proLabel.font = [Helper fontWithSize:14];
  //  [self.profileBkgView addSubview:self.proLabel];
    
    
    UILabel *starsLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 220, 240, 20)]];
    starsLabel.text = @"STARS FOR RATING";
    starsLabel.font = [Helper fontWithSize:16];
    starsLabel.textColor = [UIColor whiteColor];
    starsLabel.textAlignment = NSTextAlignmentCenter;
    starsLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    starsLabel.shadowOffset = CGSizeMake(1, 1);
    [self.contentView addSubview:starsLabel];
    
    
    self.rateView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(50, 240, 220, 50)]];
    [self.contentView addSubview:self.rateView];
    
    self.star1View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"empty_rate_star"]];
    self.star1View.center = [Helper getPointValue:CGPointMake(18, 20)];
    [self.rateView addSubview:self.star1View];
    
    self.star2View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"empty_rate_star"]];
    self.star2View.center = [Helper getPointValue:CGPointMake(63, 20)];
    [self.rateView addSubview:self.star2View];
    
    self.star3View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"empty_rate_star"]];
    self.star3View.center = [Helper getPointValue:CGPointMake(108, 20)];
    [self.rateView addSubview:self.star3View];
    
    self.star4View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"empty_rate_star"]];
    self.star4View.center = [Helper getPointValue:CGPointMake(153, 20)];
    [self.rateView addSubview:self.star4View];
    
    self.star5View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"empty_rate_star"]];
    self.star5View.center = [Helper getPointValue:CGPointMake(198, 20)];
    [self.rateView addSubview:self.star5View];
    
    [self.rateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)]];
    
    UILabel *writeLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 295, 150, 20)]];
    writeLabel.text = @"WRITE A REVIEW";
    writeLabel.font = [Helper fontWithSize:14];
    writeLabel.textColor = [UIColor whiteColor];
    writeLabel.textAlignment = NSTextAlignmentLeft;
    writeLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    writeLabel.shadowOffset = CGSizeMake(1, 1);
    [self.contentView addSubview:writeLabel];
    
    self.symbolCountLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(180, 305, 100, 10)]];
    self.symbolCountLabel.text = @"140 symbols";
    self.symbolCountLabel.font = [Helper fontWithSize:8];
    self.symbolCountLabel.textColor = [UIColor whiteColor];
    self.symbolCountLabel.textAlignment = NSTextAlignmentRight;
    self.symbolCountLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    self.symbolCountLabel.shadowOffset = CGSizeMake(1, 1);
    [self.contentView addSubview:self.symbolCountLabel];
    
    
    
    self.reviewTextView = [[UITextView alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 320, 240, 170)]];
    self.reviewTextView.layer.cornerRadius = [Helper getValue:5];
    self.reviewTextView.delegate = self;
    self.reviewTextView.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:self.reviewTextView];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setBackgroundImage:[Helper getImageByImageName:@"send_cell"] forState:UIControlStateNormal];
    [self.sendButton setTitle:@"SEND" forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [Helper fontWithSize:18];
    self.sendButton.frame = [Helper getRectValue:CGRectMake(40, [Helper isiPhone4] ? 420 : 508, 240, 30)];
    [self.sendButton addTarget:self action:@selector(sendReview:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sendButton];
    
    [self getTransInfo];
}


-(void) tapGesture:(UITapGestureRecognizer *) gesture{
    CGPoint location = [gesture locationInView:self.view];
    NSLog(@"tap location %@", NSStringFromCGPoint(location));
    self.rate = (location.x - [Helper getValue: 30])/[Helper getValue:40];

    if(self.rate >= 1){
        self.star1View.image = [Helper getImageByImageName:@"full_rate_star"];
    } else {
        self.star1View.image = [Helper getImageByImageName:@"empty_rate_star"];
    }
    
    if(self.rate >= 2){
        self.star2View.image = [Helper getImageByImageName:@"full_rate_star"];
    } else {
        self.star2View.image = [Helper getImageByImageName:@"empty_rate_star"];
    }

    if(self.rate >= 3){
        self.star3View.image = [Helper getImageByImageName:@"full_rate_star"];
    } else {
        self.star3View.image = [Helper getImageByImageName:@"empty_rate_star"];
    }
    
    if(self.rate >= 4){
        self.star4View.image = [Helper getImageByImageName:@"full_rate_star"];
    } else {
        self.star4View.image = [Helper getImageByImageName:@"empty_rate_star"];
    }
    
    if(self.rate >= 5){
        self.star5View.image = [Helper getImageByImageName:@"full_rate_star"];
    } else {
        self.star5View.image = [Helper getImageByImageName:@"empty_rate_star"];
    }
    
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sendReview:(id)sender {
    
    [self makeReview];
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSInteger len = textView.text.length;
    self.symbolCountLabel.text=[NSString stringWithFormat:@"%ld symbols",(long)140-len];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location != NSNotFound ) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
    }
    else if([[textView text] length] > 139)
    {
        return NO;
    }
    return YES;
}


-(void) getTransInfo{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session getTransInfo:self.item.transId];
    [self startAnimation];
    self.contentView.hidden = YES;
}

-(void) makeReview{
    if ([self.reviewTextView.text length] == 0) {
        [Helper showAlertViewWithText:@"Please fill review field before submitting." delegate:self];
        return;
    }
    
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session makeReview:self.reviewTextView.text withRate:self.rate forTransId:self.item.transId];
    [self startAnimation];
}


#pragma mark PortalSessionDelegate

-(void) getTransInfoResponse:(NSDictionary *)dict{
    NSLog(@"getTransInfoResponse %@", dict);
    
    self.oldRateView = [Helper getRateView:[[dict objectForKey:@"rating"] integerValue]];
    self.oldRateView.center = [Helper getPointValue:CGPointMake(135, 85)];
    [self.profileBkgView addSubview:self.oldRateView];

    self.transNameLabel.text = [dict objectForKey:@"name"];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"img"]]];
    if ([imageData length] > 0) {
        self.transProfileImage.image = [UIImage imageWithData:imageData];
    }
    
     self.proLabel.text = [[dict objectForKey:@"pro"] isEqualToString:@"1"] ? @"Lingvo Pro" : @"Lingvo Pal";
    
    [self stopAnimation];
    self.contentView.hidden = NO;
}

-(void) failedToGetTransInfo:(NSDictionary *)dict{
    NSLog(@"failedToGetTransInfo  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (errorCode == 100) {
        [Helper showAlertViewWithText:@"Translator not found" delegate:nil];
        [self stopAnimation];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) timeoutToGetTransInfo:(NSError *)error{
    NSLog(@"timeoutToGetTransInfo");
    [self getTransInfo];
}

-(void) makeReviewResponse:(NSDictionary *)dict{
    NSLog(@"makeReviewResponse %@", dict);

    [Helper showAlertViewWithText:@"Thanks for writing review" delegate:nil];
    [self stopAnimation];
    [self backAction:nil];
}

-(void) failedToMakeReview:(NSDictionary *)dict{
    NSLog(@"failedToMakeReview  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

-(void) timeoutToMakeReview:(NSError *)error{
    NSLog(@"timeoutToMakeReview");
    [self makeReview];
}


@end
