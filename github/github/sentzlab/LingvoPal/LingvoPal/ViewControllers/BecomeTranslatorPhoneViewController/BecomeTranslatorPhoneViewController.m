//
//  BecomeTranslatorPhoneViewController.m
//  LingvoPal
//
//  Created by Artak on 4/14/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "BecomeTranslatorPhoneViewController.h"
#import "Helper.h"
#import "MoreInfoViewController.h"
#import <CoreText/CoreText.h>

@interface BecomeTranslatorPhoneViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *bkgImageView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *verificationStaticLabel;
@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) UITextField *codeTextField;
@property (strong, nonatomic) UILabel *instructionLabel;



@end

@implementation BecomeTranslatorPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bkgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.bkgImageView.image = [Helper getImageByImageName:@"become_gradient"];
    [self.view addSubview:self.bkgImageView];
    
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[Helper getImageByImageName:@"close_icon"] forState:UIControlStateNormal];
    closeButton.frame = [Helper getRectValue:CGRectMake(0, 20, 60, 60)];
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];

    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 70, 290, 160)]];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = [Helper fontWithSize:15];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim.";
    contentLabel.numberOfLines = 10;
    [self.view addSubview:contentLabel];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 240, 320, 240)]];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.scrollEnabled = NO;
    self.scrollView.contentSize = CGSizeMake([Helper getValue:320], [Helper getValue:420]);
    [self.view addSubview:self.scrollView];
    
    UILabel *phoneStaticLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 25, 290, 14)]];
    phoneStaticLabel.text = @"YOUR PHONE NUMBER";
    phoneStaticLabel.font = [Helper fontWithSize:12];
    phoneStaticLabel.textColor = [UIColor whiteColor];
    phoneStaticLabel.textAlignment = NSTextAlignmentLeft;
    phoneStaticLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    phoneStaticLabel.shadowOffset = CGSizeMake(1, 1);
    [self.scrollView addSubview:phoneStaticLabel];
    
    UIImageView *phoneBKG = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"text_cell"]];
    phoneBKG.frame = [Helper getRectValue:CGRectMake(40, 40, 240, 30)];
    phoneBKG.userInteractionEnabled = YES;
    [self.scrollView addSubview:phoneBKG];
    
    self.phoneTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 5, 230, 20)]];
    self.phoneTextField.textColor = [UIColor colorWithRed:(122.0f/255.0f) green:(122.0f/255.0f) blue:(126.0f/255.0f) alpha:1.0f];
    self.phoneTextField.font = [Helper fontWithSize:18];
    self.phoneTextField.backgroundColor = [UIColor clearColor];
    self.phoneTextField.delegate = self;
    self.phoneTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    [phoneBKG addSubview:self.phoneTextField];
    
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setBackgroundImage:[Helper getImageByImageName:@"send_cell"] forState:UIControlStateNormal];
    [sendButton setTitle:@"SEND" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [Helper fontWithSize:18];
    sendButton.frame = [Helper getRectValue:CGRectMake(40, 95 , 240, 30)];
    [sendButton addTarget:self action:@selector(sendPhone:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:sendButton];
    
    
    self.verificationStaticLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 185, 240, 14)]];
    self.verificationStaticLabel.text = @"ENTER THE VERIFICATION CODE";
    self.verificationStaticLabel.font = [Helper fontWithSize:12];
    self.verificationStaticLabel.textColor = [UIColor whiteColor];
    self.verificationStaticLabel.textAlignment = NSTextAlignmentCenter;
    self.verificationStaticLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    self.verificationStaticLabel.shadowOffset = CGSizeMake(1, 1);
    [self.scrollView addSubview:self.verificationStaticLabel];

    UIImageView *verificationBKG = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"text_cell_half"]];
    verificationBKG.frame = [Helper getRectValue:CGRectMake(102, 210, 115, 30)];
    verificationBKG.userInteractionEnabled = YES;
    [self.scrollView addSubview:verificationBKG];
    
    self.codeTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 2, 105, 26)]];
    self.codeTextField.textColor = [UIColor colorWithRed:(122.0f/255.0f) green:(122.0f/255.0f) blue:(126.0f/255.0f) alpha:1.0f];
    self.codeTextField.font = [Helper fontWithSize:24];
    self.codeTextField.backgroundColor = [UIColor clearColor];
    self.codeTextField.delegate = self;
  //  self.codeTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    [verificationBKG addSubview:self.codeTextField];
    
    self.instructionLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 520, 290, 40)]];
    self.instructionLabel.textColor = [UIColor whiteColor];
    self.instructionLabel.font = [Helper fontWithSize:15];
    self.instructionLabel.textAlignment = NSTextAlignmentCenter;
    self.instructionLabel.text = @"you will get all instuction on your\n email or                               .";
    self.instructionLabel.numberOfLines = 2;
    [self.view addSubview:self.instructionLabel];
    

    
    
    UIButton *moreInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreInfoButton.titleLabel.font = [Helper fontWithSize:15];
    moreInfoButton.frame = [Helper getRectValue:CGRectMake(135, 538, 100, 20)];
    [moreInfoButton setTitle:NSLocalizedString(@"get more info", @"get more info") forState:UIControlStateNormal];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"get more info", @"get more info")];
    [attString addAttribute:(NSString*)kCTUnderlineStyleAttributeName
                      value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                      range:(NSRange){0,[attString length]}];
    moreInfoButton.titleLabel.attributedText = attString;
    [moreInfoButton setTitleColor:[UIColor colorWithRed:(0.0f/255.0f) green:(204.0f/255.0f) blue:(205.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    [moreInfoButton addTarget:self action:@selector(moreInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreInfoButton];

    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 100, 120, 120)]];
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:self.activityIndicator];
}


-(void) moreInfoAction:(UIButton *) button{
    MoreInfoViewController *moreInfoViewController = [[MoreInfoViewController alloc] init];
    [self.navigationController pushViewController:moreInfoViewController animated:YES];
}

-(void) closeAction:(UIButton *) button{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) sendPhone:(UIButton *) button{
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if (textField == self.codeTextField) {
        self.scrollView.contentOffset = [Helper getPointValue:CGPointMake(0, 170)];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.phoneTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    self.scrollView.contentOffset=CGPointMake(0, 0);
    return YES;
}

@end
