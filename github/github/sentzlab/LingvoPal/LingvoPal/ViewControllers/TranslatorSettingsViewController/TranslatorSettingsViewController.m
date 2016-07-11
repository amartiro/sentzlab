//
//  TranslatorSettingsViewController.m
//  LingvoPal
//
//  Created by Artak on 2/29/16.
//  Copyright © 2016 QuickBlox Team. All rights reserved.
//

#import "TranslatorSettingsViewController.h"
#import "Helper.h"
#import "AppDelegate.h"
#import "MFSideMenuContainerViewController.h"
#import "UIImage+Resize.h"
#import "PortalSession.h"
#import "Constants.h"

#import "BecomeTranslatorPhoneViewController.h"
#import "TranslatorReviewViewController.h"
#import "CustomPopupView.h"
#import "NSString+MD5.h"
#import "ForgotPasswordViewController.h"


@interface TranslatorSettingsViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PortalSessionDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *profileImageView;
@property (strong, nonatomic) UITextField *translatorNameTextField;
@property (strong, nonatomic) UITextField *translatorSurNameTextField;
@property (strong, nonatomic) UITextField *translatorEmailTextField;
@property (strong, nonatomic) UITextField *translatorPhoneTextField;
@property (strong, nonatomic) UIButton *editPhoto;
@property (strong, nonatomic) UIButton *addLanguage;
@property (strong, nonatomic) UITextView *languagesTextView;

@property (strong, nonatomic) UILabel *nativeLabel;

@property (strong, nonatomic) UILabel *lang1Label;
@property (strong, nonatomic) UILabel *lang2Label;

@property (nonatomic, strong) UIActionSheet *lang1ActionSheet;
@property (nonatomic, strong) UIActionSheet *lang2ActionSheet;

@property (strong, nonatomic) NSString *lang1String;
@property (strong, nonatomic) NSString *lang2String;

@property (strong, nonatomic) UIView *addLangsView;

@property (strong, nonatomic) UIButton *addPhoneButton;

@property (strong, nonatomic) UIButton *editButton;

@property (strong, nonatomic) CustomPopupView *popupView;
@property (strong, nonatomic) NSString *password;



@end

@implementation TranslatorSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIImageView *trHatImageView = [[UIImageView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 320, 80)]];
//    trHatImageView.image = [Helper getImageByImageName:@"settings_hat"];
//    
//    [self.view addSubview:trHatImageView];
    self.bkgImageView.image = [Helper getImageByImageName:@"gradient"];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 80, 320, 488)]];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];

    
    UIButton * menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[Helper getImageByImageName:@"burger"] forState:UIControlStateNormal];
    menuButton.frame = [Helper getRectValue:CGRectMake(5, 20, 41, 34)];
    [menuButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(50, 26, 260, 22)]];
    titleLabel.text = @"Settings";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [Helper fontWithSize:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:titleLabel];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [self.editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.editButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.editButton setTitleShadowColor:[UIColor colorWithWhite:.0 alpha:.3] forState:UIControlStateNormal];
    self.editButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    self.editButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    self.editButton.titleLabel.font = [Helper fontWithSize:16];
    self.editButton.frame = [Helper getRectValue:CGRectMake(230, 15 , 70, 44)];
    [self.editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editButton];
    
    
    self.profileImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"profile_cell"]];
    self.profileImageView.frame = [Helper getRectValue:CGRectMake(10, 90, 100, 100)];
    self.profileImageView.userInteractionEnabled = YES;
    self.profileImageView.layer.cornerRadius = [Helper getValue:50];
    self.profileImageView.clipsToBounds = YES;
    [self.view addSubview:self.profileImageView];
    
    self.editPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editPhoto.frame = [Helper getRectValue:CGRectMake(35, 155, 50, 50)];
    [self.editPhoto setImage:[Helper getImageByImageName:@"photo_icon"] forState:UIControlStateNormal];
    [self.editPhoto addTarget:self action:@selector(editProfilePicAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editPhoto];
    
    
    
    UIImageView *line1View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"grey_settings_line"]];
    line1View.center = [Helper getPointValue:CGPointMake(160, 200)];
    [self.view addSubview:line1View];
    
    UIImageView *nameIconView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"profile_icon"]];
    nameIconView.center = [Helper getPointValue:CGPointMake(20, 221)];
    [self.view addSubview:nameIconView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(35, 212, 100, 16)]];
    nameLabel.text = @"First Name";
    nameLabel.font = [Helper fontWithSize:14];
    [self.view addSubview:nameLabel];
    
    
    self.translatorNameTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(145, 212, 165, 16)]];
    self.translatorNameTextField.backgroundColor = [UIColor clearColor];
    self.translatorNameTextField.textColor = [UIColor colorWithRed:(151.0f/255.0f) green:(151.0f/255.0f) blue:(151.0f/255.0f) alpha:1.0f];
    self.translatorNameTextField.font = [Helper fontWithSize:16];
    self.translatorNameTextField.textAlignment = NSTextAlignmentRight;
    self.translatorNameTextField.userInteractionEnabled = NO;
    self.translatorNameTextField.delegate = self;
    [self.view addSubview:self.translatorNameTextField];

    
    
    UIImageView *line2View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"grey_settings_line"]];
    line2View.center = [Helper getPointValue:CGPointMake(160, 240)];
    [self.view addSubview:line2View];
    
    UIImageView *surnameIconView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"profile_icon"]];
    surnameIconView.center = [Helper getPointValue:CGPointMake(20, 261)];
    [self.view addSubview:surnameIconView];
    
    UILabel *surnameLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(35, 252, 100, 16)]];
    surnameLabel.text = @"Last Name";
    surnameLabel.font = [Helper fontWithSize:14];
    [self.view addSubview:surnameLabel];
    
    self.translatorSurNameTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(145, 252, 165, 16)]];
    self.translatorSurNameTextField.backgroundColor = [UIColor clearColor];
    self.translatorSurNameTextField.textColor = [UIColor colorWithRed:(151.0f/255.0f) green:(151.0f/255.0f) blue:(151.0f/255.0f) alpha:1.0f];
    self.translatorSurNameTextField.font = [Helper fontWithSize:16];
    self.translatorSurNameTextField.textAlignment = NSTextAlignmentRight;
    self.translatorSurNameTextField.userInteractionEnabled = NO;
    self.translatorSurNameTextField.delegate = self;
    [self.view addSubview:self.translatorSurNameTextField];
    
    
    
    UIImageView *reviewIconView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"reviews_icon"]];
    reviewIconView.center = [Helper getPointValue:CGPointMake(20, 300)];
    [self.view addSubview:reviewIconView];
    
    UIButton *reviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reviewButton setTitle:@"Reviews" forState:UIControlStateNormal];
    [reviewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    reviewButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    reviewButton.titleLabel.font = [Helper fontWithSize:14];
    reviewButton.frame = [Helper getRectValue:CGRectMake(35, 292 , 275, 16)];
    [reviewButton addTarget:self action:@selector(reviewAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reviewButton];
    
    
    UIImageView *line3View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"grey_settings_line"]];
    line3View.center = [Helper getPointValue:CGPointMake(160, 280)];
    [self.view addSubview:line3View];
 
    
    UIImageView *emailIconView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"email_iconl"]];
    emailIconView.center = [Helper getPointValue:CGPointMake(20, 340)];
    [self.view addSubview:emailIconView];
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(35, 332, 100, 16)]];
    emailLabel.text = @"Email Address";
    emailLabel.font = [Helper fontWithSize:14];
    [self.view addSubview:emailLabel];
    
    self.translatorEmailTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(145, 332, 165, 16)]];
    self.translatorEmailTextField.backgroundColor = [UIColor clearColor];
    self.translatorEmailTextField.textColor = [UIColor colorWithRed:(151.0f/255.0f) green:(151.0f/255.0f) blue:(151.0f/255.0f) alpha:1.0f];
    self.translatorEmailTextField.font = [Helper fontWithSize:16];
    self.translatorEmailTextField.textAlignment = NSTextAlignmentRight;
    self.translatorEmailTextField.userInteractionEnabled = NO;
    [self.view addSubview:self.translatorEmailTextField];
    
    UIImageView *line4View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"grey_settings_line"]];
    line4View.center = [Helper getPointValue:CGPointMake(160, 320)];
    [self.view addSubview:line4View];
    
    
    UIImageView *phoneIconView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"phone_icon"]];
    phoneIconView.center = [Helper getPointValue:CGPointMake(20, 380)];
    [self.view addSubview:phoneIconView];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(35, 372, 100, 16)]];
    phoneLabel.text = @"Phone Number";
    phoneLabel.font = [Helper fontWithSize:14];
    [self.view addSubview:phoneLabel];
    
    self.translatorPhoneTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(145, 332, 165, 16)]];
    self.translatorPhoneTextField.backgroundColor = [UIColor clearColor];
    self.translatorPhoneTextField.textColor = [UIColor colorWithRed:(151.0f/255.0f) green:(151.0f/255.0f) blue:(151.0f/255.0f) alpha:1.0f];
    self.translatorPhoneTextField.font = [Helper fontWithSize:16];
    self.translatorPhoneTextField.textAlignment = NSTextAlignmentRight;
    self.translatorPhoneTextField.text = @"+7525415689511";
    self.translatorPhoneTextField.userInteractionEnabled = NO;
   // [self.view addSubview:self.translatorPhoneTextField];
    
    self.addPhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addPhoneButton setBackgroundImage:[Helper getImageByImageName:@"add_number_cell"]  forState:UIControlStateNormal];
    [self.addPhoneButton setTitle:@"ADD NUMBER" forState:UIControlStateNormal];
    self.addPhoneButton.titleLabel.font = [Helper fontWithSize:14];
    self.addPhoneButton.frame = [Helper getRectValue:CGRectMake(175, 365 , 135, 30)];
    [self.addPhoneButton addTarget:self action:@selector(addPhoneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addPhoneButton];
    
    
    UIImageView *line5View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"grey_settings_line"]];
    line5View.center = [Helper getPointValue:CGPointMake(160, 360)];
    [self.view addSubview:line5View];
    
    
    UIImageView *line6View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"grey_settings_line"]];
    line6View.center = [Helper getPointValue:CGPointMake(160, 400)];
    [self.view addSubview:line6View];
    
    UIImageView *langIconView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"language_icon"]];
    langIconView.center = [Helper getPointValue:CGPointMake(20, 420)];
    [self.view addSubview:langIconView];

    UILabel *langLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(35, 412, 100, 16)]];
    langLabel.text = @"Language(s)";
    langLabel.font = [Helper fontWithSize:14];
    [self.view addSubview:langLabel];
    
    self.nativeLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(150, 412, 160, 15)]];
    
    self.nativeLabel.font = [Helper fontWithSize:12];
    self.nativeLabel.textAlignment = NSTextAlignmentRight;
    self.nativeLabel.textColor = [UIColor colorWithRed:(151.0f/255.0f) green:(151.0f/255.0f) blue:(151.0f/255.0f) alpha:1.0f];
    [self.view addSubview:self.nativeLabel];
    
    self.languagesTextView = [[UITextView alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 430, 300, 130)]];
    self.languagesTextView.font = [Helper fontWithSize:12];
    self.languagesTextView.textAlignment = NSTextAlignmentLeft;
    self.languagesTextView.textColor = [UIColor colorWithRed:(151.0f/255.0f) green:(151.0f/255.0f) blue:(151.0f/255.0f) alpha:1.0f];
    self.languagesTextView.backgroundColor = [UIColor clearColor];
    self.languagesTextView.editable = NO;
    self.languagesTextView.selectable = NO;
    [self.view addSubview:self.languagesTextView];
    

    self.addLangsView = [[UIView alloc] initWithFrame:CGRectMake(0, [Helper isiPhone4] ? 387 : 475, 320, 30)];
    self.addLangsView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.addLangsView];
    
    UIImageView *lang1BKG = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"text_bordered_cell_half"]];
    lang1BKG.frame = [Helper getRectValue:CGRectMake(40, 0, 115,30)];
    lang1BKG.userInteractionEnabled = YES;
    [self.addLangsView addSubview:lang1BKG];
    
    self.lang1Label = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 5, 105, 20)]];
    self.lang1Label.text = @"options";
    self.lang1Label.backgroundColor = [UIColor clearColor];
    self.lang1Label.textColor = [UIColor colorWithRed:(122.0f/255.0f) green:(122.0f/255.0f) blue:(126.0f/255.0f) alpha:1.0f];
    self.lang1Label.font = [Helper fontWithSize:14];
    [lang1BKG addSubview:self.lang1Label];
    
    UIButton* lang1Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [lang1Button setBackgroundImage:[Helper getImageByImageName:@"choose_language_arrow_cell"] forState:UIControlStateNormal];
    lang1Button.frame = [Helper getRectValue:CGRectMake(85, 0, 30, 30)];
    [lang1Button addTarget:self action:@selector(lang1Action:) forControlEvents:UIControlEventTouchUpInside];
    [lang1BKG addSubview:lang1Button];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"language_white_arrow"]];
    arrowImageView.center = [Helper getPointValue:CGPointMake(160, 15)];
    [self.addLangsView addSubview:arrowImageView];
    self.addLangsView.hidden = YES;
    
    UIImageView *lang2BKG = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"text_bordered_cell_half"]];
    lang2BKG.frame = [Helper getRectValue:CGRectMake(165, 0, 115,30)];
    lang2BKG.userInteractionEnabled = YES;
    [self.addLangsView addSubview:lang2BKG];
    
    self.lang2Label = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 5, 105, 20)]];
    self.lang2Label.text = @"options";
    self.lang2Label.backgroundColor = [UIColor clearColor];
    self.lang2Label.textColor = [UIColor colorWithRed:(122.0f/255.0f) green:(122.0f/255.0f) blue:(126.0f/255.0f) alpha:1.0f];
    self.lang2Label.font = [Helper fontWithSize:14];
    [lang2BKG addSubview:self.lang2Label];
    
    UIButton* lang2Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [lang2Button setBackgroundImage:[Helper getImageByImageName:@"choose_language_arrow_cell"] forState:UIControlStateNormal];
    lang2Button.frame = [Helper getRectValue:CGRectMake(85, 0, 30, 30)];
    [lang2Button addTarget:self action:@selector(lang2Action:) forControlEvents:UIControlEventTouchUpInside];
    [lang2BKG addSubview:lang2Button];
    
    self.addLanguage = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addLanguage setBackgroundImage:[Helper getImageByImageName:@"add_language_cell"]  forState:UIControlStateNormal];
    [self.addLanguage setTitle:@"ADD LANGUAGE" forState:UIControlStateNormal];
    self.addLanguage.titleLabel.font = [Helper fontWithSize:14];
    self.addLanguage.frame = [Helper getRectValue:CGRectMake(40, [Helper isiPhone4] ? 452 : 520, 240, 30)];
    [self.addLanguage addTarget:self action:@selector(addLanguageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addLanguage];
    
    self.lang1ActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please specify language:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *lang in [Helper getLangsArray]) {
        [self.lang1ActionSheet addButtonWithTitle:[Helper getLanguageFromABRV:lang]];
    }
    
    self.lang2ActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please specify language:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *lang in [Helper getLangsArray]) {
        [self.lang2ActionSheet addButtonWithTitle:[Helper getLanguageFromABRV:lang]];
    }

   
    [self getTransInfo];
}

-(void) addPhoneAction:(UIButton *) button{
    
    BecomeTranslatorPhoneViewController *viewController = [[BecomeTranslatorPhoneViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}


-(void) editAction:(UIButton *) button{
    if (self.translatorNameTextField.userInteractionEnabled) {
        [self updateAccountInfo];
    } else {
        [self showPasswordView];
    }
}

-(void) showPasswordView{
    if (self.popupView == nil) {
        self.popupView = [[CustomPopupView alloc] initWithNativeLang:@"Armenian"];
        self.popupView.titelLabel.text = @"Please enter your password to edit profile";
        [self.popupView.okButton addTarget:self action:@selector(passwordOKAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.popupView.cancelButton addTarget:self action:@selector(passwordCancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.popupView.forgotPasswordButton addTarget:self action:@selector(forgotPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    self.popupView.fieldTextField.text = @"";
    [self.view addSubview:self.popupView];
}

-(void) updateAccountInfo{
    NSString *email = self.translatorEmailTextField.text;
    NSString *name = self.translatorNameTextField.text;
    NSString *surname = self.translatorSurNameTextField.text;
    
    
    if (![Helper isValidNickName:name]) {
        [Helper showAlertViewWithText:NSLocalizedString(@"PLEASE SPECIFY VALID NAME", @"PLEASE SPECIFY VALID NAME") delegate:nil];
        
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
    
    
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session changeUserName:name andSurname:surname andEmail:email];
}

-(void) passwordOKAction:(UIButton *) button{
    [self.popupView.fieldTextField resignFirstResponder];
    self.password = self.popupView.fieldTextField.text;
   
    
    [self checkPassword];

}

-(void) passwordCancelAction:(UIButton *) button{
    [self.popupView.fieldTextField resignFirstResponder];
    [self.popupView removeFromSuperview];
}

-(void) forgotPasswordAction:(UIButton *) button{
    [self.popupView removeFromSuperview];
    ForgotPasswordViewController * viewController = [[ForgotPasswordViewController alloc] init];

    [self.navigationController pushViewController:viewController animated:YES];
}


-(void) addLanguageAction:(UIButton *) button{

    self.addLangsView.hidden = !self.addLangsView.hidden;
    if (!self.addLangsView.hidden) {
        [self.addLanguage setTitle:@"SEND REQUEST" forState:UIControlStateNormal];
  //      self.languagesTextView.frame = [Helper getRectValue:CGRectMake(10, 350, 300, 70)];
    } else {
        [self.addLanguage setTitle:@"ADD LANGUAGE" forState:UIControlStateNormal];
 //       self.languagesTextView.frame = [Helper getRectValue:CGRectMake(10, 350, 300, 130)];
        [self setLanguage];
    }
}

-(void) lang1Action:(UIButton *) button{
    [self.lang1ActionSheet showInView:self.view];
}

-(void) lang2Action:(UIButton *) button{
    [self.lang2ActionSheet showInView:self.view];
}

-(void) menuAction:(UIButton *) button{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.menuViewController toggleLeftSideMenuCompletion:^{
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.translatorNameTextField resignFirstResponder];
    [self.translatorSurNameTextField resignFirstResponder];
    return YES;
}

-(void) reviewAction:(UIButton *) button{
    TranslatorReviewViewController *translatorReviewViewController = [[TranslatorReviewViewController alloc] init];
    [self.navigationController pushViewController:translatorReviewViewController animated:YES];
}

-(void) editProfilePicAction:(UIButton *) button{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"CHOOSE FROM", @"CHOOSE FROM") delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"CANCEL") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"CAMERA", @"CAMERA"), NSLocalizedString(@"PHOTOS", @"PHOTOS"), nil];
    [actionSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"buttonIndex %ld", (long)buttonIndex);
    if (actionSheet == self.lang1ActionSheet) {
        if (buttonIndex != 0){
            self.lang1String = [[Helper getLangsArray] objectAtIndex:(buttonIndex - 1)];
            self.lang1Label.text = [Helper getLanguageFromABRV:self.lang1String];
        }
        return;
    }
    
    if (actionSheet == self.lang2ActionSheet) {
        if (buttonIndex != 0){
            self.lang2String = [[Helper getLangsArray] objectAtIndex:(buttonIndex - 1)];
            self.lang2Label.text = [Helper getLanguageFromABRV:self.lang2String];
        }
        return;
    }
    
    switch (buttonIndex) {
        case 0:
            [self cameraAction];
            break;
        case 1:
            [self libraryAction];
            break;
        default:
            break;
    }
}

-(void) cameraAction{
    if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc ] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void) libraryAction{
    if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc ] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    UIImage *resizedImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                                        bounds:CGSizeMake(120, 120)
                                          interpolationQuality:kCGInterpolationHigh];
    
    self.profileImageView.image = resizedImage;
    
    [self setImage];
}


-(void) setImage{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session setImage:self.profileImageView.image];
    
}

-(void) getTransInfo{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *transId =  [defaults objectForKey:kTranslatorId];
    
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session getTransInfo:transId];
}


-(void) setLanguage{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *transId =  [defaults objectForKey:kTranslatorId];
    
    if([self.lang1String length] && [self.lang2String length]){
        PortalSession *session = [PortalSession sharedInstance];
        session.delegate = self;
        [session setLanguage:self.lang1String andLang2:self.lang2String forTransId:transId];
    }
}

-(void) checkPassword{
    NSString *passwordMD5 = [self.password MD5];
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session checkPassword:passwordMD5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark PortalSessionDelegate

-(void) getTransInfoResponse:(NSDictionary *)dict{
    NSLog(@"getTransInfoResponse %@", dict);
    
    NSString *name = [dict objectForKey:@"name"];
    NSString *surname = [dict objectForKey:@"surname"];
    
    NSDictionary *langDict = [dict objectForKey:@"langs"];
    
    NSMutableString *langString = [[NSMutableString alloc] init];
    if ([langDict isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in [langDict allKeys]) {
            NSDictionary *langSingleDict = [langDict objectForKey:key];
            NSString *lang1 = [langSingleDict objectForKey:@"lang1"];
            NSString *lang2 = [langSingleDict objectForKey:@"lang2"];
            [langString appendFormat:@"%@⇆%@\n", [Helper getLanguageFromABRV:lang1], [Helper getLanguageFromABRV:lang2]];
            
        }
    }
    
    self.languagesTextView.text = langString;
    
    self.nativeLabel.text = [NSString stringWithFormat:@"%@(native)", [Helper getLanguageFromABRV:[dict objectForKey:@"native"]]];
    self.translatorNameTextField.text = name;
    self.translatorSurNameTextField.text = surname;
    self.translatorEmailTextField.text = [dict objectForKey:@"email"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"img"]]];
    if ([imageData length] > 0) {
        self.profileImageView.image = [UIImage imageWithData:imageData];
    }
    
  //  self.proLabel.text = [[dict objectForKey:@"pro"] isEqualToString:@"1"] ? @"Lingvo Pro" : @"Lingovo Pal";
}

-(void) failedToGetTransInfo:(NSDictionary *)dict{
    NSLog(@"failedToGetTransInfo  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    //TODO::ARTAK 100 -> no have translators,
}

-(void) timeoutToGetTransInfo:(NSError *)error{
    NSLog(@"timeoutToGetTransInfo");
    [self getTransInfo];
}

-(void) setImageResponse:(NSDictionary *) dict{
    NSLog(@"setImageResponse %@", dict);
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"img"]]];
    if ([imageData length] > 0) {
        self.profileImageView.image = [UIImage imageWithData:imageData];
    }
}

-(void) failedToSetImage:(NSDictionary *) dict{
    NSLog(@"failedToSetImage  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) timeoutToSetImage:(NSError *) error{
    NSLog(@"timeoutToSetImage");
    [self setImage];
}

-(void) setLanguageResponse:(NSDictionary *) dict{
    NSLog(@"setLanguageResponse %@", dict);
    [self getTransInfo];
}



-(void) failedToSetLanguage:(NSDictionary *) dict{
    NSLog(@"failedToSetLanguage  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (errorCode == 100) {
        [Helper showAlertViewWithText:@"You already specified this language, please select other one." delegate:nil];
        return;
    }
}

-(void) timeoutToSetLanguage:(NSError *) error{
    NSLog(@"timeoutToSetLanguage");
    [self setLanguage];
}


-(void) checkPasswordResponse:(NSDictionary *) dict{
    NSLog(@"checkPasswordResponse %@", dict);
    [self.popupView removeFromSuperview];
    
    [self.editButton setTitle:@"Save" forState:UIControlStateNormal];
    self.translatorNameTextField.userInteractionEnabled = YES;
    self.translatorSurNameTextField.userInteractionEnabled = YES;
    self.translatorPhoneTextField.userInteractionEnabled = YES;
    self.translatorEmailTextField.userInteractionEnabled = YES;
    [self.translatorNameTextField becomeFirstResponder];
}

-(void) failedToCheckPassword:(NSDictionary *) dict{
    NSLog(@"failedToCheckPassword  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 404) {
        [Helper showAlertViewWithText:@"Invalid password specified." delegate:nil];
    }
    
    [self.popupView.fieldTextField resignFirstResponder];
}

-(void) timeoutToCheckPassword:(NSError *) error{
    NSLog(@"timeoutToCheckPassword");
    [self checkPassword];
}

-(void) changeUserNameResponse:(NSDictionary *) dict{
    NSLog(@"changeUserNameResponse %@", dict);
    
    [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    self.translatorNameTextField.userInteractionEnabled = NO;
    self.translatorSurNameTextField.userInteractionEnabled = NO;
    self.translatorPhoneTextField.userInteractionEnabled = NO;
    self.translatorEmailTextField.userInteractionEnabled = NO;
}

-(void) failedToChangeUserName:(NSDictionary *) dict{
    NSLog(@"failedToChangeUserName  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if (errorCode == 404) {
        [Helper showAlertViewWithText:@"New email already exists in database." delegate:nil];
    }
    
}

-(void) timeoutToChangeUserName:(NSError *) error{
    NSLog(@"timeoutToChangeUserName");
    [self updateAccountInfo];
}

@end
