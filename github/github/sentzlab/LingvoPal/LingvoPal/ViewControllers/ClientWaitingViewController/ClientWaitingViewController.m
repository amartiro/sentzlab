//
//  ClientWaitingViewController.m
//  LingvoPal
//
//  Created by Artak on 2/16/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "ClientWaitingViewController.h"
#import "Helper.h"
#import "PortalSession.h"

#import "TranlatorProfileViewController.h"

@interface ClientWaitingViewController () <PortalSessionDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIView *middleBKGView;
@property (strong, nonatomic) UILabel *toLabel;
@property (strong, nonatomic) UILabel *fromLabel;
@property (strong, nonatomic) UILabel *proLabel;

@property (strong, nonatomic) UILabel *countLabel;

@property (strong, nonatomic) UIImageView *mansImageView;
@property (strong, nonatomic) UILabel *callTypeLabel;

@property (strong, nonatomic) UIButton *cancelButton;

@end

@implementation ClientWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bkgImageView.image = [Helper getImageByImageName:@"translate_from_gradient"];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[Helper getImageByImageName:@"back_icon"] forState:UIControlStateNormal];
    backButton.frame = [Helper getRectValue:CGRectMake(5, 20, 26, 42)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 100, 240, 70)]];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = [Helper fontWithSize:15];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.text = @"We are searching interpreters for you hang on there.";
    contentLabel.numberOfLines = 4;
    contentLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    contentLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:contentLabel];
    
    self.middleBKGView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 180, 240, 90)]];
    self.middleBKGView.layer.cornerRadius = [Helper getValue:5];
    self.middleBKGView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.8f];
    [self.view addSubview:self.middleBKGView];
    
    UIImageView *tickImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"tick_ellipse"]];
    tickImageView.center = [Helper getPointValue:CGPointMake(15, 15)];
    [self.middleBKGView addSubview:tickImageView];
    
    UILabel *fromStaticLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(30, 5, 40, 20)]];
    fromStaticLabel.text = @"From:";
    fromStaticLabel.textColor = [UIColor colorWithRed:(116.0f/255.0f) green:(116.0f/255.0f) blue:(116.0f/255.0f) alpha:1.0f];
    fromStaticLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:fromStaticLabel];
    
    self.fromLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 5, 100, 20)]];
    self.fromLabel.text = [Helper getLanguageFromABRV:self.fromLang];
    self.fromLabel.textColor = [UIColor blackColor];
    self.fromLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:self.fromLabel];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"white_long_line"]];
    lineImageView.center = [Helper getPointValue:CGPointMake(120, 30)];
    [self.middleBKGView addSubview:lineImageView];
    
    UIImageView *tickImageView1 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"tick_ellipse"]];
    tickImageView1.center = [Helper getPointValue:CGPointMake(15, 45)];
    [self.middleBKGView addSubview:tickImageView1];
    
    UILabel *toStaticLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(30, 35, 20, 20)]];
    toStaticLabel.text = @"To:";
    toStaticLabel.textColor = [UIColor colorWithRed:(116.0f/255.0f) green:(116.0f/255.0f) blue:(116.0f/255.0f) alpha:1.0f];
    toStaticLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:toStaticLabel];
    
    self.toLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 35, 100, 20)]];
    self.toLabel.text = [Helper getLanguageFromABRV:self.toLang];
    self.toLabel.textColor = [UIColor blackColor];
    self.toLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:self.toLabel];
    
    UIImageView *tickImageView2 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"tick_ellipse"]];
    tickImageView2.center = [Helper getPointValue:CGPointMake(15, 75)];
    [self.middleBKGView addSubview:tickImageView2];
    
    UIImageView *lineImageView2 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"white_long_line"]];
    lineImageView2.center = [Helper getPointValue:CGPointMake(120, 60)];
    [self.middleBKGView addSubview:lineImageView2];
    
    UILabel *callTypeStaticLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(30, 65, 60, 20)]];
    callTypeStaticLabel.text = @"Call Type:";
    callTypeStaticLabel.textColor = [UIColor colorWithRed:(116.0f/255.0f) green:(116.0f/255.0f) blue:(116.0f/255.0f) alpha:1.0f];
    callTypeStaticLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:callTypeStaticLabel];
    
    self.callTypeLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 65, 160, 20)]];
    self.callTypeLabel.text = [Helper getCallType:self.callType];
    self.callTypeLabel.textColor = [UIColor blackColor];
    self.callTypeLabel.font = [Helper fontWithSize:12];
    [self.middleBKGView addSubview:self.callTypeLabel];

    self.mansImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"man1"]];
    self.mansImageView.center = [Helper getPointValue:CGPointMake(160, 370)];
    self.mansImageView.animationImages = [NSArray arrayWithObjects:
                                     [Helper getImageByImageName:@"man1"],
                                     [Helper getImageByImageName:@"man2"],
                                     [Helper getImageByImageName:@"man3"],
                                     [Helper getImageByImageName:@"man4"],
                                     [Helper getImageByImageName:@"man5"],
                                     //                                     [Helper getImageByImageName:@"man_icon3"],
                                     //                                     [Helper getImageByImageName:@"man_icon2"],
                                     //                                     [Helper getImageByImageName:@"man_icon1"],
                                     nil];
    
    self.mansImageView.animationDuration = 3;
    [self.view addSubview:self.mansImageView];
    

    
    
    self.countLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 450, 240, 30)]];
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.font = [Helper fontWithSize:14];
    self.countLabel.numberOfLines = 2;
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.countLabel];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setBackgroundImage:[Helper getImageByImageName:@"login_cell"] forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"CANCEL ORDER" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [Helper fontWithSize:14];
    self.cancelButton.frame = [Helper getRectValue:CGRectMake(25, [Helper isiPhone4] ? 420 : 508, 271, 34)];
    [self.cancelButton addTarget:self action:@selector(cancelOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
//    self.cancelButton.hidden = YES;
//    
//    [self performSelector:@selector(showCancelButton:) withObject:nil afterDelay:20.0f];
    
}

//-(void) showCancelButton:(UIButton *) button{
//    self.cancelButton.hidden = YES;
//}

- (void)backAction:(id)sender {
    [self cancelOrderAction:nil];
}


-(void) cancelOrderAction:(UIButton *) button{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to cancel current order ?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alertView show];
}

#pragma UIAlertViewController
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self cancelOrder];        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getTrans];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getTrans{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session getTranslatorForOrderId:self.orderId declineTransId:self.transId];
    [self.mansImageView startAnimating];
}

-(void) cancelOrder{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session cancelOrderWithOrderId:self.orderId] ;
}


#pragma mark PortalSessionDelegate

-(void) getTranslatorResponse:(NSDictionary *)dict{
    NSLog(@"getTranslatorResponse %@", dict);
    
    self.transId =  [dict objectForKey:@"tr_id"];
    [self.mansImageView stopAnimating];
    
    TranlatorProfileViewController *viewController = [[TranlatorProfileViewController alloc] init];
    viewController.transDict = dict;
    viewController.orderId = self.orderId;
    viewController.callType = self.callType;

    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) failedToGetTranslator:(NSDictionary *)dict{
    
    NSLog(@"failedToGetTranslator  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (errorCode == 100) {
        self.countLabel.text = [NSString stringWithFormat:@"We have sent your request to %@ interpreters. Wait till one of ther replies.", [dict objectForKey:@"tr_count"]];
        
        [self performSelector:@selector(getTrans) withObject:nil afterDelay:5.0f];
        return;
    }
    
    if (errorCode == 404) {
        [Helper showAlertViewWithText:@"System error!. Please make your order again." delegate:nil];
     
        NSArray *viewControllers = self.navigationController.viewControllers;
        [self.navigationController popToViewController:[viewControllers objectAtIndex:([viewControllers count] - 3)] animated:YES];
    }
}

-(void) timeoutToGetTranslator:(NSError *)error{
    NSLog(@"timeoutToGetTranslator");
    [self getTrans];
}

@end
