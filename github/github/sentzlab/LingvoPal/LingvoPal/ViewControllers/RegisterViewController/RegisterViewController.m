//
//  RegisterViewController.m
//  SentzTrans
//
//  Created by Artak on 11/24/15.
//  Copyright © 2015 SentzLab. All rights reserved.
//

#import "RegisterViewController.h"

#import "AppDelegate.h"

#import "Helper.h"
#import "PortalSession.h"
#import "Constants.h"

#import "MFSideMenuContainerViewController.h"
#import "NSString+MD5.h"
#import <Google/SignIn.h>

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Google/SignIn.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>


@interface RegisterViewController () <PortalSessionDelegate, UITextFieldDelegate, GIDSignInUIDelegate>

@property (strong, nonatomic) UIScrollView *contentScrollView;

@property (strong, nonatomic) UITextField *firstNameTextField;
@property (strong, nonatomic) UITextField *lastNameTextField;
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UITextField *mobileTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic)  UITextField *confirmTextField;

@property (strong, nonatomic) UIButton *googlePlusButton;
@property (strong, nonatomic) UIButton *facebookButton;
@property (strong, nonatomic) UIButton *signUpButton;

@property (nonatomic, strong) NSString *fbId;
@property (nonatomic, strong) NSString *fbLastName;
@property (nonatomic, strong) NSString *fbFirstName;
@property (nonatomic, strong) NSString *fbEmail;

@end

@implementation RegisterViewController

-(instancetype) init{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bkgImageView.image = [Helper getImageByImageName:@"gradient1"];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[Helper getImageByImageName:@"back_icon"] forState:UIControlStateNormal];
    backButton.frame = [Helper getRectValue:CGRectMake(5, 20, 26, 42)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 70, 320, 400)]];
    self.contentScrollView.backgroundColor = [UIColor clearColor];
    self.contentScrollView.contentSize = CGSizeMake([Helper getValue:320], [Helper getValue:540]);
    self.contentScrollView.scrollEnabled = NO;
    [self.view addSubview:self.contentScrollView];
                                                                                                 
    
    self.googlePlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.googlePlusButton setBackgroundImage:[Helper getImageByImageName:@"google_cell"] forState:UIControlStateNormal];
    self.googlePlusButton.frame = [Helper getRectValue:CGRectMake(24, 0, 126, 37)];
    [self.googlePlusButton addTarget:self action:@selector(googlePlusAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentScrollView addSubview:self.googlePlusButton];
    
//    GIDSignInButton *signInButton = [[GIDSignInButton alloc] initWithFrame:[Helper getRectValue:CGRectMake(24, 0, 126, 26)]];
//    
//    [self.self.contentScrollView addSubview:signInButton];

    
    
    self.facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.facebookButton setBackgroundImage:[Helper getImageByImageName:@"facebook_cell"] forState:UIControlStateNormal];
    self.facebookButton.frame = [Helper getRectValue:CGRectMake(170, 0, 126, 37)];
    [self.facebookButton addTarget:self action:@selector(facebookAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentScrollView addSubview:self.facebookButton];
    
    UIView *halflineView1 = [Helper getWhiteViewWithLength:126];
    halflineView1.center = [Helper getPointValue:CGPointMake(88, 53)];
    [self.contentScrollView addSubview:halflineView1];
    
    UIView *halflineView2 = [Helper getWhiteViewWithLength:126];
    halflineView2.center = [Helper getPointValue:CGPointMake(232, 53)];
    [self.contentScrollView addSubview:halflineView2];

    UILabel *orLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(150, 46, 20, 14)]];
    orLabel.textAlignment = NSTextAlignmentCenter;
    orLabel.text = @"or";
    orLabel.textColor = [UIColor whiteColor];
    orLabel.font = [Helper fontWithSize:12];
    //    orLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    //    orLabel.shadowOffset = CGSizeMake(1, 1);
    [self.contentScrollView addSubview:orLabel];
    
    UIFont *labelFont = [Helper fontWithSize:14];
    
//    UILabel *nameLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 80, 100, 18)]];
//    nameLabel.textAlignment = NSTextAlignmentLeft;
//    nameLabel.text = @"Name";
//    nameLabel.textColor = [UIColor whiteColor];
//    nameLabel.font = [Helper fontWithSize:16];
//    nameLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
//    nameLabel.shadowOffset = CGSizeMake(1, 1);
//    [self.view addSubview:nameLabel];
    
    self.firstNameTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(25, 75, 128, 25)]];
    self.firstNameTextField.textColor = [UIColor whiteColor];
    self.firstNameTextField.font = labelFont;
    self.firstNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"FIRST NAME", @"FIRST NAME") attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.firstNameTextField.delegate = self;
    [self.contentScrollView addSubview:self.firstNameTextField];
    
    self.lastNameTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(167, 75, 128, 25)]];
    self.lastNameTextField.textColor = [UIColor whiteColor];
    self.lastNameTextField.font = labelFont;
    self.lastNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"LAST NAME", @"LAST NAME") attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.lastNameTextField.delegate = self;
    [self.contentScrollView addSubview:self.lastNameTextField];

    UIView *halflineView3 = [Helper getWhiteViewWithLength:126];
    halflineView3.center = [Helper getPointValue:CGPointMake(88, 100)];
    [self.contentScrollView addSubview:halflineView3];
    
    UIView *halflineView4 = [Helper getWhiteViewWithLength:126];
    halflineView4.center = [Helper getPointValue:CGPointMake(232, 100)];
    [self.contentScrollView addSubview:halflineView4];
    
    
//    UILabel *emailLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 140, 100, 18)]];
//    emailLabel.textAlignment = NSTextAlignmentLeft;
//    emailLabel.text = @"Email";
//    emailLabel.textColor = [UIColor whiteColor];
//    emailLabel.font = [Helper fontWithSize:16];
//    emailLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
//    emailLabel.shadowOffset = CGSizeMake(1, 1);
//    [self.view addSubview:emailLabel];
    
    self.emailTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(25, 135, 270, 25)]];
    self.emailTextField.textColor = [UIColor whiteColor];
    self.emailTextField.font = labelFont;
 //   self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"EMAIL ADDRESS", @"EMAIL ADDRESS") attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.emailTextField.alpha = 0.8f;
    self.emailTextField.delegate = self;
    self.emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.contentScrollView addSubview:self.emailTextField];
    
    UIView *lineView1 = [Helper getWhiteViewWithLength:270];
    lineView1.center = [Helper getPointValue:CGPointMake(160, 160)];
    [self.contentScrollView addSubview:lineView1];
    
//    UILabel *mobileLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(25, 195, 60, 25)]];
//    mobileLabel.textAlignment = NSTextAlignmentLeft;
//    mobileLabel.text = @"MOBILE";
//    mobileLabel.textColor = [UIColor whiteColor];
//    mobileLabel.font = labelFont;
////    passwordLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
////    passwordLabel.shadowOffset = CGSizeMake(1, 1);
//    [self.contentScrollView addSubview:mobileLabel];
//    
//    UIView *lineViewM = [Helper getWhiteViewWithLength:60];
//    lineViewM.center = [Helper getPointValue:CGPointMake(55, 220)];
//    [self.contentScrollView addSubview:lineViewM];
//    
//    self.mobileTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(95, 195, 200, 25)]];
//    self.mobileTextField.backgroundColor = [UIColor clearColor];
//    self.mobileTextField.textColor = [UIColor whiteColor];
//    self.mobileTextField.font = labelFont;
//    //   self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
////    self.mobileTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"", @"") attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    self.mobileTextField.alpha = 0.8f;
//    self.mobileTextField.delegate = self;
//    self.mobileTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    [self.contentScrollView addSubview:self.mobileTextField];
//    
//    
//    UIView *lineViewMF = [Helper getWhiteViewWithLength:200];
//    lineViewMF.center = [Helper getPointValue:CGPointMake(195, 220)];
//    [self.contentScrollView addSubview:lineViewMF];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(25, 195, 270, 25)]];
    self.passwordTextField.textColor = [UIColor whiteColor];
    self.passwordTextField.font = labelFont;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"PASSWORD", @"PASSWORD") attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.passwordTextField.alpha = 0.8f;
    self.passwordTextField.delegate = self;
    [self.contentScrollView addSubview:self.passwordTextField];
    
    UIView *lineView3 = [Helper getWhiteViewWithLength:270];
    lineView3.center = [Helper getPointValue:CGPointMake(160, 220)];
    [self.contentScrollView addSubview:lineView3];
    
    
//    UILabel *confirmPasswordLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 260, 130, 18)]];
//    confirmPasswordLabel.textAlignment = NSTextAlignmentLeft;
//    confirmPasswordLabel.text = @"Confirm Password";
//    confirmPasswordLabel.textColor = [UIColor whiteColor];
//    confirmPasswordLabel.font = [Helper fontWithSize:16];
//    confirmPasswordLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
//    confirmPasswordLabel.shadowOffset = CGSizeMake(1, 1);
//    [self.view addSubview:confirmPasswordLabel];
    
    self.confirmTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(25, 245, 270, 25)]];
    self.confirmTextField.textColor = [UIColor whiteColor];
    self.confirmTextField.font = labelFont;
    self.confirmTextField.secureTextEntry = YES;
    self.confirmTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"CONFIRM PASSWORD", @"CONFIRM PASSWORD") attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.confirmTextField.alpha = 0.8f;
    self.confirmTextField.delegate = self;
    [self.contentScrollView addSubview:self.confirmTextField];
   
    UIView *lineView2 = [Helper getWhiteViewWithLength:270];
    lineView2.center = [Helper getPointValue:CGPointMake(160, 270)];
    [self.contentScrollView addSubview:lineView2];
    
    
    self.signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.signUpButton setBackgroundImage:[Helper getImageByImageName:@"register_cell"] forState:UIControlStateNormal];
    [self.signUpButton setTitle:@"REGISTER" forState:UIControlStateNormal];
    self.signUpButton.titleLabel.font = [Helper fontWithSize:18];
    self.signUpButton.frame = [Helper getRectValue:CGRectMake(40, 350, 240, 30)];
    [self.signUpButton addTarget:self action:@selector(signUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentScrollView addSubview:self.signUpButton];
    
//    GIDSignInButton *signInButton = [[GIDSignInButton alloc] initWithFrame:[Helper getRectValue:CGRectMake(80, 40, 160, 30)]];
//  //  signInButton.style = kGIDSignInButtonStyleWide;
//  //  signInButton.colorScheme = kGIDSignInButtonColorSchemeDark;
//    
//    [self.view addSubview:signInButton];
    
}

// Implement these methods only if the GIDSignInUIDelegate is not a subclass of
// UIViewController.

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
  //  [myActivityIndicator stopAnimating];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) googlePlusAction:(UIButton *) button{
    [[GIDSignIn sharedInstance] signIn];
}

-(void) facebookAction:(UIButton *) button{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:@"com.apple.facebook"];
    if (accountStore && accountType && [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        NSString *fAppId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"];
        
        NSDictionary *options = @{ACFacebookAppIdKey : fAppId,
                                  ACFacebookPermissionsKey : @[@"email", @"public_profile"] };
        
        [accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error){
            if (granted == YES && error == nil)
            {
                NSLog(@"Im in!");
                NSArray *facebookAccounts =  [accountStore accountsWithAccountType:accountType];
                ACAccount *facebookAccount = [facebookAccounts lastObject];
                
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                        requestMethod:SLRequestMethodGET
                                                                  URL:[NSURL URLWithString:@"https://graph.facebook.com/me"]
                                                           parameters:[NSDictionary dictionaryWithObject:@"email, first_name, last_name" forKey:@"fields"]];
                
                request.account = facebookAccount;
                
                [request performRequestWithHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (error == nil && ((NSHTTPURLResponse *)response).statusCode == 200) {
                        NSError *deserializationError;
                        NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&deserializationError];
                        
                        if (userData != nil && deserializationError == nil) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^(void){
                                [self makeFacebookLogin:userData];
                            });
                        }
                    }
                }];
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    
                    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
                    [login
                     logInWithReadPermissions: @[@"public_profile"]
                     fromViewController:self
                     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                         if (error) {
                             NSLog(@"Process error");
                         } else if (result.isCancelled) {
                             NSLog(@"Cancelled");
                         } else {
                             if ([FBSDKAccessToken currentAccessToken]) {
                                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:[NSDictionary dictionaryWithObject:@"email, first_name, last_name" forKey:@"fields"]]
                                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                      if (!error) {
                                          dispatch_async(dispatch_get_main_queue(), ^(void){
                                              [self makeFacebookLogin:result];
                                          });
                                      }
                                  }];
                             }
                             
                             NSLog(@"Logged in %@ %@", result.token.tokenString, result.token.userID);
                         }
                         
                     }];
                });
            }
        }];
    }
    else
    {
        
    }
}

- (void)signUpAction:(id)sender {
    
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameTextField resignFirstResponder];

    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmTextField resignFirstResponder];

    [self makeRegister];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) makeRegister{
    NSString *name = self.firstNameTextField.text;
    NSString *surname =  self.lastNameTextField.text;
    NSString *email = self.emailTextField.text;

    NSString *password = self.passwordTextField.text;
    NSString *confirmPass = self.confirmTextField.text;
    
    if (![Helper isValidNickName:name]) {
        [Helper showAlertViewWithText:NSLocalizedString(@"PLEASE SPECIFY VALID FIRST NAME", @"PLEASE SPECIFY VALID FIRST NAME") delegate:nil];

        return;
    }
    
    if (![Helper isValidNickName:surname]) {
        [Helper showAlertViewWithText:NSLocalizedString(@"PLEASE SPECIFY VALID LAST NAME", @"PLEASE SPECIFY VALID LAST NAME") delegate:nil];
        
        return;
    }
    
    if (![Helper isValidEmail:email]) {
        [Helper showAlertViewWithText:NSLocalizedString(@"PLEASE SPECIFY VALID EMAIL", @"PLEASE SPECIFY VALID EMAIL") delegate:nil];

        return;
    }
    
    if (![password isEqualToString:confirmPass]) {
        [Helper showAlertViewWithText:NSLocalizedString(@"PASSWORD MUST MATCH WITH CONFIRM PASSWORD", @"PASSWORD MUST MATCH WITH CONFIRM PASSWORD") delegate:nil];
 
        return;
    }
    
    if (![Helper isValidPassword:password]) {
        [Helper showAlertViewWithText:NSLocalizedString(@"PASSWORD CONTAIN ATLAST 6 SYMBOLS.", @"PASSWORD CONTAIN ATLAST 6 SYMBOLS.") delegate:nil];

        return;
    }
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceId = [defaults valueForKey:kDeviceToken];
    NSString *uuid = [Helper GetUUID];
    NSString *passwordMD5 = [password MD5];
    
    PortalSession * session = [PortalSession sharedInstance];
    session.delegate = self;
    [session registerWithName:name withSurname:surname withEmail:email withPassword:passwordMD5 withUUID:uuid andRegId:deviceId];
    [self startAnimation];
}

-(void) makeFacebookLogin:(NSDictionary *) dict{
    self.fbEmail = [dict objectForKey:@"email"];
    self.fbFirstName = [dict objectForKey:@"first_name"];
    self.fbLastName = [dict objectForKey:@"last_name"];
    self.fbId = [dict objectForKey:@"id"];
    
    [self makeSocialLogin];
}

-(void) makeSocialLogin{
    NSString *uuid = [Helper GetUUID];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceId = [defaults valueForKey:kDeviceToken];
    
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session socialLoginWitName:self.fbFirstName withSurname:self.fbLastName withEmail:self.fbEmail withFacbookId:self.fbId andGoogleId:nil withUUID:uuid andRegId:deviceId];
}

#pragma mark UITextFieldDelegate

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{

    if (self.firstNameTextField == textField || self.lastNameTextField == textField) {
        self.contentScrollView.contentOffset = [Helper getPointValue:CGPointMake(0, 60)];
    }
    
    if (self.emailTextField == textField || self.passwordTextField == textField  || self.confirmTextField == textField ) {
        self.contentScrollView.contentOffset = [Helper getPointValue:CGPointMake(0, 120)];
    }
    
//    if (self.passwordTextField == textField ) {
//        self.contentScrollView.contentOffset = [Helper getPointValue:CGPointMake(0, 230)];
//    }
//    
//    if (self.confirmTextField == textField ) {
//        self.contentScrollView.contentOffset = [Helper getPointValue:CGPointMake(0, 280)];
//    }
    
    self.contentScrollView.scrollEnabled = YES;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.firstNameTextField resignFirstResponder];
    [self.lastNameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.mobileTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmTextField resignFirstResponder];
    
    self.contentScrollView.contentOffset = [Helper getPointValue:CGPointMake(0, 0)];
    self.contentScrollView.scrollEnabled = NO;
    return YES;
}

#pragma mark PortalSessionDelegate

-(void) registerWithNickResponse:(NSDictionary *) dict{
    NSLog(@"registerWithNickResponse %@", dict);
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[dict objectForKey:kAccessToken] forKey:kAccessToken];
    [defaults setObject:[dict objectForKey:kAccessId] forKey:kAccessId];
    [defaults setObject:[dict objectForKey:kEmail] forKey:kEmail];
    [defaults setObject:self.passwordTextField.text forKey:kPassword];
    [defaults setObject:[dict objectForKey:kQBId] forKey:kQBId];
    [defaults setObject:[dict objectForKey:kQBPassword] forKey:kQBPassword];
    [defaults setObject:[dict objectForKey:kStreamId] forKey:kStreamId];
    [defaults setObject:[dict objectForKey:kNickName] forKey:kNickName];
    [defaults removeObjectForKey:kTranslatorId];
    [self stopAnimation];
    
    MFSideMenuContainerViewController *viewController = [[MFSideMenuContainerViewController alloc] init];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) failedToRegisterWithNick:(NSDictionary *) dict{
    NSLog(@"failedToRegisterWithNick %@", dict);
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    
    [self stopAnimation];
    
    if (errorCode == 2) {
        [Helper showAlertViewWithText:NSLocalizedString(@"EMAIL ALREADY EXIST", @"EMAIL ALREADY EXIST") delegate:nil];
        return;
    }
    
    if (errorCode == 503) {
        [Helper showAlertViewWithText:@"Sorry, we have technical problem. Try later" delegate:nil];
        return;
    }
}

-(void) timeoutToRegisterWithNick:(NSError *) error{
    NSLog(@"timeoutToRegisterWithNick");
    [self makeRegister];
}

-(void) socialLoginResponse:(NSDictionary *) dict{
    NSLog(@"socialLoginResponse %@", dict);
    
    NSString *trId = [dict objectForKey:kTranslatorId];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[dict objectForKey:kAccessToken] forKey:kAccessToken];
    [defaults setObject:[dict objectForKey:kAccessId] forKey:kAccessId];
    [defaults setObject:[dict objectForKey:kEmail] forKey:kEmail];
    [defaults setObject:[dict objectForKey:kNickName] forKey:kNickName];
    
    [defaults setObject:[dict objectForKey:kQBId] forKey:kQBId];
    [defaults setObject:[dict objectForKey:kQBPassword] forKey:kQBPassword];
    
    if (trId != nil) {  [defaults setObject:trId forKey:kTranslatorId]; }
    
    
    MFSideMenuContainerViewController *viewController = [[MFSideMenuContainerViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) failedToSocialLogin:(NSDictionary *) dict{
    
    NSLog(@"failedToSocialLogin  %@", dict);
    
  //  NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
}

-(void) timeoutToSocialLogin:(NSError *) error{
    NSLog(@"timeoutToSocialLogin");
    [self makeSocialLogin];
}


@end
