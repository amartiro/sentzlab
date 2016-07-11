//
//  RateViewController.m
//  LingvoPal
//
//  Created by Artak on 4/27/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "RateViewController.h"
#import "Helper.h"
#import "PortalSession.h"

@interface RateViewController () <PortalSessionDelegate, UITextViewDelegate>

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UIView *rateView;

@property (strong, nonatomic) UIImageView *star1View;
@property (strong, nonatomic) UIImageView *star2View;
@property (strong, nonatomic) UIImageView *star3View;
@property (strong, nonatomic) UIImageView *star4View;
@property (strong, nonatomic) UIImageView *star5View;

@property (strong, nonatomic) UILabel *symbolCountLabel;
@property (strong, nonatomic) UITextView *reviewTextView;
@property (strong, nonatomic) UIButton *sendButton;

@property (assign, nonatomic) NSInteger rate;

@end

@implementation RateViewController

- (void)dealloc {
    
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bkgImageView.image = [Helper getImageByImageName:@"gradient2"];
    
    self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    //self.contentView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.contentView];

    
//    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeButton setImage:[Helper getImageByImageName:@"close_icon"] forState:UIControlStateNormal];
//    closeButton.frame = [Helper getRectValue:CGRectMake(0, 20, 60, 60)];
//    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:closeButton];
    
    UILabel* callDurationLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 65, 290, 15)]];
    callDurationLabel.textColor = [UIColor whiteColor];
    callDurationLabel.font = [Helper fontWithSize:12];
    callDurationLabel.textAlignment = NSTextAlignmentCenter;
    callDurationLabel.text = @"CALL DURATION";
    [self.contentView addSubview:callDurationLabel];
    
    self.durationLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 85, 290, 35)]];
    self.durationLabel.textColor = [UIColor whiteColor];
    self.durationLabel.font = [Helper fontWithSize:32];
    self.durationLabel.textAlignment = NSTextAlignmentCenter;
    self.durationLabel.text = @"45 min";
    [self.view addSubview:self.durationLabel];
    
    UILabel* spentLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 133, 290, 15)]];
    spentLabel.textColor = [UIColor whiteColor];
    spentLabel.font = [Helper fontWithSize:12];
    spentLabel.textAlignment = NSTextAlignmentCenter;
    spentLabel.text = @"SPENT MONET";
    [self.contentView addSubview:spentLabel];
   
    UIImageView *spentImageView = [[UIImageView alloc] initWithFrame:[Helper getRectValue:CGRectMake(85, 150, 150, 41)]];
    spentImageView.image = [Helper getImageByImageName: @"spent_money_user_cell"];
    [self.contentView addSubview:spentImageView];
    
    self.spentLabel  = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 155, 290, 30)]];
    self.spentLabel.textColor = [UIColor whiteColor];
    self.spentLabel.font = [Helper fontWithSize:28];
    self.spentLabel.textAlignment = NSTextAlignmentCenter;
    self.spentLabel.text = @"30 $";
    [self.contentView addSubview:self.spentLabel];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(20, 220, 280, 25)]];
    titleLabel.text = @"RATINGS AND REVIEWS";
    titleLabel.font = [Helper fontWithSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    [self.contentView addSubview:titleLabel];


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
    
    self.reviewTextView = [[UITextView alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 320, 240, 110)]];
    self.reviewTextView.layer.cornerRadius = [Helper getValue:5];
    self.reviewTextView.delegate = self;
    self.reviewTextView.returnKeyType = UIReturnKeyDone;
    self.reviewTextView.text = @"";
    [self.contentView addSubview:self.reviewTextView];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setBackgroundImage:[Helper getImageByImageName:@"send_request_cell"] forState:UIControlStateNormal];
    [self.sendButton setTitle:@"SEND" forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [Helper fontWithSize:18];
    self.sendButton.frame = [Helper getRectValue:CGRectMake(40, [Helper isiPhone4] ? 392 : 480, 240, 30)];
    [self.sendButton addTarget:self action:@selector(sendReview:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sendButton];

}

-(void) closeAction:(UIButton *) button{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)sendReview:(id)sender {
    
    [self makeReview];
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSInteger len = textView.text.length;
    self.symbolCountLabel.text=[NSString stringWithFormat:@"%ld symbols",(long)140-len];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.contentView.center = CGPointMake(self.contentView.center.x, self.contentView.center.y - [Helper getValue:100]);
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.contentView.center = CGPointMake(self.contentView.center.x, self.contentView.center.y + [Helper getValue:100]);
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


-(void) makeReview{
//    if ([self.reviewTextView.text length] == 0) {
//        [Helper showAlertViewWithText:@"Please fill review field before submitting." delegate:self];
//        return;
//    }
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session makeReview:self.reviewTextView.text withRate:self.rate forTransId:self.transId];
    [self startAnimation];
}


#pragma mark PortalSessionDelegate



-(void) makeReviewResponse:(NSDictionary *)dict{
    NSLog(@"makeReviewResponse %@", dict);
    
    [Helper showAlertViewWithText:@"Thanks for writing review" delegate:nil];
    [self stopAnimation];
    [self closeAction:nil];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
