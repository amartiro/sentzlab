//
//  LoginViewController.h
//
//  Created by Artak on 04.12.15.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

#import "PortalSession.h"
#import "Helper.h"
#import "Constants.h"

#import "RegisterViewController.h"
#import "MFSideMenuContainerViewController.h"
#import <CoreText/CoreText.h>
#import "ForgotPasswordViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "NSString+MD5.h"

#import <Google/SignIn.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>


@interface LoginViewController() <PortalSessionDelegate, UITextFieldDelegate, GIDSignInUIDelegate>

@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIButton *googlePlusButton;
@property (strong, nonatomic) UIButton *facebookButton;

@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *signUpButton;

@property (nonatomic, strong) NSString *fbId;
@property (nonatomic, strong) NSString *fbLastName;
@property (nonatomic, strong) NSString *fbFirstName;
@property (nonatomic, strong) NSString *fbEmail;



@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.bkgImageView.image = [Helper getImageByImageName:@"gradient1"];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[Helper getImageByImageName:@"back_icon"] forState:UIControlStateNormal];
    backButton.frame = [Helper getRectValue:CGRectMake(5, 20, 26, 42)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];

    [GIDSignIn sharedInstance].uiDelegate = self;

    self.googlePlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.googlePlusButton setBackgroundImage:[Helper getImageByImageName:@"google_cell"] forState:UIControlStateNormal];
    self.googlePlusButton.frame = [Helper getRectValue:CGRectMake(24, 85, 126, 37)];
    [self.googlePlusButton addTarget:self action:@selector(googlePlusAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.googlePlusButton];
    
    self.facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.facebookButton setBackgroundImage:[Helper getImageByImageName:@"facebook_cell"] forState:UIControlStateNormal];
    self.facebookButton.frame = [Helper getRectValue:CGRectMake(170, 85, 126, 37)];
    [self.facebookButton addTarget:self action:@selector(facebookAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.facebookButton];
    
    UIView *halflineView1 = [Helper getWhiteViewWithLength:126];
    halflineView1.center = [Helper getPointValue:CGPointMake(88, 150)];
    [self.view addSubview:halflineView1];
    
    UIView *halflineView2 = [Helper getWhiteViewWithLength:126];
    halflineView2.center = [Helper getPointValue:CGPointMake(232, 150)];
    [self.view addSubview:halflineView2];
    
    UILabel *orLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(150, 143, 20, 14)]];
    orLabel.textAlignment = NSTextAlignmentCenter;
    orLabel.text = @"or";
    orLabel.textColor = [UIColor whiteColor];
    orLabel.font = [Helper fontWithSize:12];
//    orLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
//    orLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:orLabel];
    
    
    UIFont *labelFont = [Helper fontWithSize:14];
    self.emailTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(25, 180, 270, 30)]];
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
    lineView1.center = [Helper getPointValue:CGPointMake(160, 210)];
    [self.view addSubview:lineView1];

    self.passwordTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(25, 235, 270, 30)]];
    self.passwordTextField.backgroundColor = [UIColor clearColor];
    self.passwordTextField.textColor = [UIColor whiteColor];
    self.passwordTextField.font = labelFont;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"PASSWORD", @"PASSWORD") attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];//[UIColor colorWithRed:(120.0f/255.0f) green:(120.0f/255.0f) blue:(120.0f/255.0f) alpha:1.0f]
    self.passwordTextField.alpha = 0.8f;
    self.passwordTextField.delegate = self;
    [self.view addSubview:self.passwordTextField];
    
    
    UIView *lineView2 = [Helper getWhiteViewWithLength:270];
    lineView2.center = [Helper getPointValue:CGPointMake(160, 265)];
    [self.view addSubview:lineView2];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setBackgroundImage:[Helper getImageByImageName:@"login_cell"] forState:UIControlStateNormal];
    [self.loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [Helper fontWithSize:18];
    self.loginButton.frame = [Helper getRectValue:CGRectMake(25, 284, 271, 34)];
    [self.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    UIButton *forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgotPasswordButton.titleLabel.font = [Helper fontWithSize:15];
    forgotPasswordButton.frame = [Helper getRectValue:CGRectMake(60, 330, 200, 20)];
    [forgotPasswordButton setTitle:NSLocalizedString(@"FORGOT PASSWORD?", @"FORGOT PASSWORD?") forState:UIControlStateNormal];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FORGOT PASSWORD?", @"FORGOT PASSWORD?")];
    [attString addAttribute:(NSString*)kCTUnderlineStyleAttributeName
                      value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                      range:(NSRange){0,[attString length]}];
    forgotPasswordButton.titleLabel.attributedText = attString;
    [forgotPasswordButton setTitleColor:[UIColor colorWithRed:(0.0f/255.0f) green:(204.0f/255.0f) blue:(205.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    [forgotPasswordButton addTarget:self action:@selector(forgotAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotPasswordButton];

    
    
    UILabel *notAMemberLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, [Helper isiPhone4] ? 360 : 448, 240, 18)]];
    notAMemberLabel.textAlignment = NSTextAlignmentCenter;
    notAMemberLabel.text = @"NOT A MEMBER YET?";
    notAMemberLabel.textColor = [UIColor whiteColor];
    notAMemberLabel.font = [Helper fontWithSize:16];
    notAMemberLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    notAMemberLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:notAMemberLabel];
  
    self.signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.signUpButton setBackgroundImage:[Helper getImageByImageName:@"register_cell"] forState:UIControlStateNormal];
    [self.signUpButton setTitle:@"REGISTER" forState:UIControlStateNormal];
    self.signUpButton.titleLabel.font = [Helper fontWithSize:18];
    self.signUpButton.frame = [Helper getRectValue:CGRectMake(25, [Helper isiPhone4] ? 385 : 473, 271, 34)];
    [self.signUpButton addTarget:self action:@selector(signUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signUpButton];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void) googlePlusAction:(UIButton *) button{
    [[GIDSignIn sharedInstance] signIn];

}

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

-(void) forgotAction:(UIButton *) button{
    ForgotPasswordViewController * viewController = [[ForgotPasswordViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)loginAction:(id)sender {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    [self makeLogin];
}

- (void)signUpAction:(id)sender {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    RegisterViewController *viewController = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

-(void) makeLogin{
    NSString *uuid = [Helper GetUUID];
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (![Helper isValidEmail:email]) {
        
        [Helper showAlertViewWithText:NSLocalizedString(@"INCORRECT EMAIL. PLEASE TRY AGAIN.", @"INCORRECT EMAIL. PLEASE TRY AGAIN.") delegate:nil];
        return;
    }
    
    if (![Helper isValidPassword:password]) {
        [Helper showAlertViewWithText:NSLocalizedString(@"PASSWORD CONTAIN ATLAST 6 SYMBOLS.", @"PASSWORD CONTAIN ATLAST 6 SYMBOLS.") delegate:nil];
        return;
    }
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceId = [defaults valueForKey:kDeviceToken];
    NSString *streamId = [defaults valueForKey:kStreamId];
    NSString *passwordMD5 = [password MD5];
    
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session loginWithEmail:email andPassword:passwordMD5 andUUID:uuid andRegId:deviceId andStreamId:streamId];
    [self startAnimation];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    return YES;
}

#pragma mark PortalSessionDelegate

-(void) loginWithEmailResponse:(NSDictionary *) dict{
    NSLog(@"loginWithEmailResponse %@", dict);
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[dict objectForKey:kAccessToken] forKey:kAccessToken];
    [defaults setObject:[dict objectForKey:kAccessId] forKey:kAccessId];
    [defaults setObject:[dict objectForKey:kTranslatorId] forKey:kTranslatorId];
    [defaults setObject:[dict objectForKey:kEmail] forKey:kEmail];
    [defaults setObject:self.passwordTextField.text forKey:kPassword];
    [defaults setObject:[dict objectForKey:kNickName] forKey:kNickName];
    
    [defaults setObject:[dict objectForKey:kQBId] forKey:kQBId];
    [defaults setObject:[dict objectForKey:kQBPassword] forKey:kQBPassword];
    [defaults setObject:[dict objectForKey:kStreamId] forKey:kStreamId];
    
    [self stopAnimation];
    
    MFSideMenuContainerViewController *viewController = [[MFSideMenuContainerViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) failedToLoginWithEmail:(NSDictionary *) dict{
    
    NSLog(@"failedToLoginWithEmail  %@", dict);
    [self stopAnimation];
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 404) {
        [Helper showAlertViewWithText:NSLocalizedString(@"INVALID EMAIL/ PASSWORD", @"INVALID EMAIL/ PASSWORD") delegate:nil];
        return;
    }
}

-(void) timeoutToLoginWithEmail:(NSError *) error{
    NSLog(@"timeoutToLoginWithEmail");
    [self makeLogin];
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
