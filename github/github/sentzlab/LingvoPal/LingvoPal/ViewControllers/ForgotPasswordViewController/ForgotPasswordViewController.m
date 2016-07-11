//
//  ForgotPasswordViewController.m
//  LingvoPal
//
//  Created by Artak Martirosyan on 6/3/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "Helper.h"
#import "PortalSession.h"

@interface ForgotPasswordViewController () <UITextFieldDelegate, PortalSessionDelegate>
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UIButton *resetButton;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bkgImageView.image = [Helper getImageByImageName:@"gradient1"];

    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[Helper getImageByImageName:@"back_icon"] forState:UIControlStateNormal];
    backButton.frame = [Helper getRectValue:CGRectMake(5, 20, 26, 42)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIFont *labelFont = [Helper fontWithSize:14];

    self.emailTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(25, 100, 270, 20)]];
    self.emailTextField.backgroundColor = [UIColor clearColor];
    self.emailTextField.textColor = [UIColor whiteColor];
    self.emailTextField.font = labelFont;
    // self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"EMAIL", @"EMAIL") attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]; //[UIColor colorWithRed:(120.0f/255.0f) green:(120.0f/255.0f) blue:(120.0f/255.0f) alpha:1.0f]
    self.emailTextField.alpha = 0.8f;
    self.emailTextField.delegate = self;
    self.emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:self.emailTextField];

    
    UIView *lineView1 = [Helper getWhiteViewWithLength:270];
    lineView1.center = [Helper getPointValue:CGPointMake(160, 120)];
    [self.view addSubview:lineView1];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 130, 290, 35)]];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = [Helper fontWithSize:14];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = @"Enter the email address you registeres with\nand we'll send you a link to reset your password.";
    contentLabel.numberOfLines = 2;
    [self.view addSubview:contentLabel];
    
    self.resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.resetButton setBackgroundImage:[Helper getImageByImageName:@"login_cell"] forState:UIControlStateNormal];
    [self.resetButton setTitle:@"RESET PASSWORD" forState:UIControlStateNormal];
    self.resetButton.titleLabel.font = [Helper fontWithSize:18];
    self.resetButton.frame = [Helper getRectValue:CGRectMake(25, 284, 271, 34)];
    [self.resetButton addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.resetButton];
    
    
}

-(void) backAction:(UIButton *) button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) resetAction:(UIButton *) button{
    [self.emailTextField resignFirstResponder];
    
    [self makeReset];
    
}

-(void) makeReset{
    NSString *email = self.emailTextField.text;
    
    if (![Helper isValidEmail:email]) {
        
        [Helper showAlertViewWithText:NSLocalizedString(@"INCORRECT EMAIL. PLEASE TRY AGAIN.", @"INCORRECT EMAIL. PLEASE TRY AGAIN.") delegate:nil];
        return;
    }
    
    
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session resetPassword:email];
    [self startAnimation];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) resetPasswordResponse:(NSDictionary *) dict{
    NSLog(@"resetPasswordResponse %@", dict);
    [Helper showAlertViewWithText:@"Instruction was sent to your email." delegate:nil];
    [self stopAnimation];
    
}

-(void) failedToResetPassword:(NSDictionary *) dict{
    NSLog(@"failedToResetPassword  %@", dict);
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    [self stopAnimation];
    
    if (errorCode == 404) {
        [Helper showAlertViewWithText:@"Email not found." delegate:nil];
        return;
    }
    

}

-(void) timeoutToResetPassword:(NSError *) error{
    NSLog(@"timeoutToResetPassword");
    [self makeReset];
}

@end
