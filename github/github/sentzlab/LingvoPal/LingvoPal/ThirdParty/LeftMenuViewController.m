//
//  LeftMenuViewController.m
//  LingvoPal
//
//  Created by Artak on 2/15/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "MFSideMenu.h"
#import "MenuTableViewCell.h"
#import "Helper.h"
#import "Constants.h"
//#import "OrderViewController.h"
#import "FindInterpreterViewController.h"

#import "MyOrdersViewController.h"

#import "PortalSession.h"

#import "BecomeTranslatorViewController.h"
#import "UIImage+Resize.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface LeftMenuViewController () <PortalSessionDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIView *transView;
@property (strong, nonatomic) UIView *clientView;

@property (strong, nonatomic) UITableView *clientTableView;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UILabel *clientAmountLabel;
@property (strong, nonatomic) UIButton *editButton;
@property (strong, nonatomic) UIButton *editPhoto;

@property (strong, nonatomic)  UILabel *pushLabel;

@property (strong, nonatomic) UILabel *emailLabel;

@property (strong, nonatomic) UIImageView *profileImageView;
@property (strong, nonatomic) UILabel *translatorNameLabel;
@property (strong, nonatomic) UILabel *proLabel;
@property (strong, nonatomic) UILabel *nativeLabel;
@property (strong, nonatomic) UILabel *amountLabel;

@property (strong, nonatomic) UITableView *translatorTableView;

@property (strong, nonatomic) UISwitch *statusSwitch;
@property (strong, nonatomic) UIView *rateView;
@property (strong, nonatomic) UITextView *languagesTextView;

//@property (strong, nonatomic) NSString *otherLang;
//@property (strong, nonatomic) UIActionSheet *langActionSheet;


@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isTranlator = NO;
    self.view.backgroundColor = [UIColor whiteColor];
        
    self.clientView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 197, [Helper isiPhone4] ? 410 : 498)]];
    self.clientView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.clientView];
    
    
    UIView *clientHatView =  [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 197, 112)]];
    clientHatView.backgroundColor = [UIColor colorWithRed:(32.0f/255.0f) green:(32.0f/255.0f) blue:(32.0f/255.0f) alpha:1.0f];
    [self.clientView addSubview:clientHatView];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 35, 177, 25)]];
    self.nameTextField.backgroundColor = [UIColor clearColor];
    self.nameTextField.textColor = [UIColor whiteColor];
    self.nameTextField.font = [Helper fontWithSize:22];
    self.nameTextField.textAlignment = NSTextAlignmentCenter;
    self.nameTextField.userInteractionEnabled = NO;
    
    [self.clientView addSubview:self.nameTextField];
    
//    UIView *yellowView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(13, 70, 80, 27)]];
//    yellowView.layer.cornerRadius = [Helper getValue:4.0f];
//    yellowView.clipsToBounds = YES;
//    yellowView.backgroundColor = [UIColor colorWithRed:(234.0f/255.0f) green:(163.0f/255.0f) blue:(23.0f/255.0f) alpha:1.0f];
//    [self.clientView addSubview:yellowView];
//    
//    UILabel *amountLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(2, 2, 40, 25)]];
//    
//    amountLabel.font = [Helper fontWithSize:10];
//    amountLabel.textAlignment = NSTextAlignmentLeft;
//    amountLabel.textColor = [UIColor whiteColor];
//    amountLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
//    amountLabel.shadowOffset = CGSizeMake(1, 1);
//    amountLabel.numberOfLines = 2;
//    amountLabel.text = @"Available\nfunds";
//    [yellowView addSubview:amountLabel];
//    
//    
//    
//    self.clientAmountLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(45, 4, 35, 19)]];
//    self.clientAmountLabel.font = [Helper fontWithSize:16];
//    self.clientAmountLabel.text = @"$200";
//    self.clientAmountLabel.textAlignment = NSTextAlignmentCenter;
//    self.clientAmountLabel.textColor = [UIColor whiteColor];
//    [yellowView addSubview:self.clientAmountLabel];
//
//    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.editButton.frame = [Helper getRectValue:CGRectMake(190, 15, 50, 50)];
//    [self.editButton setImage:[Helper getImageByImageName:@"edit_icon"] forState:UIControlStateNormal];
//    [self.editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.clientView addSubview:self.editButton];
    
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 115, 180, 20)]];
    emailLabel.text = @"Email address";
    emailLabel.font = [Helper fontWithSize:14];
    emailLabel.textColor = [UIColor lightGrayColor];
    [self.clientView addSubview:emailLabel];
    
    self.emailLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 140, 180, 15)]];
    self.emailLabel.font = [Helper fontWithSize:12];
    self.emailLabel.textAlignment = NSTextAlignmentLeft;
    self.emailLabel.textColor = [UIColor blackColor];
    [self.clientView addSubview:self.emailLabel];
    
    UIImageView *stripView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"grey_menu_line"]];
    stripView.center = [Helper getPointValue:CGPointMake(123, 158)];
    [self.clientView addSubview:stripView];
    
    
    self.clientTableView = [[UITableView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 158, 197, 184)]];
    self.clientTableView.backgroundColor = [UIColor clearColor];
    self.clientTableView.scrollEnabled = NO;
    self.clientTableView.delegate = self;
    self.clientTableView.dataSource = self;
    self.clientTableView.separatorColor = [UIColor clearColor];
    [self.clientView addSubview:self.clientTableView];
    
    
    UIButton *becomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    becomeButton.frame = [Helper getRectValue:CGRectMake(10, [Helper isiPhone4] ? 377 : 465, 173, 30)];
    [becomeButton setBackgroundImage:[Helper getImageByImageName:@"become_an_interpreter_cell"] forState:UIControlStateNormal];
    [becomeButton setTitle:@"BECOME AN INTERPRETER" forState:UIControlStateNormal];
    becomeButton.titleLabel.font = [Helper fontWithSize:14];
    [becomeButton addTarget:self action:@selector(becomeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.clientView addSubview:becomeButton];
    
    
    self.transView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 197, [Helper isiPhone4] ? 410 : 498)]];
    self.transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.transView];
    
    UIView *trHatView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 197, 112)]];
    trHatView.backgroundColor = [UIColor colorWithRed:(32.0f/255.0f) green:(32.0f/255.0f) blue:(32.0f/255.0f) alpha:1.0f];
    [self.transView addSubview:trHatView];
    
    UITapGestureRecognizer *transHatTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transHatTapGesture:)];
    [trHatView addGestureRecognizer:transHatTapGesture];
    
    self.profileImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"profile_cell"]];
    self.profileImageView.frame = [Helper getRectValue:CGRectMake(10, 30, 60, 60)];
    self.profileImageView.userInteractionEnabled = YES;
    self.profileImageView.layer.cornerRadius = [Helper getValue:30];
    self.profileImageView.clipsToBounds = YES;
    [self.transView addSubview:self.profileImageView];
    
    self.editPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editPhoto.frame = [Helper getRectValue:CGRectMake(10, 30, 60, 60)];
    [self.editPhoto setImage:[Helper getImageByImageName:@"photo_icon1"] forState:UIControlStateNormal];
    [self.editPhoto addTarget:self action:@selector(editProfilePicAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.transView addSubview:self.editPhoto];
    
    
    self.translatorNameLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(80, 30, 100, 35)]];
    self.translatorNameLabel.backgroundColor = [UIColor clearColor];
    self.translatorNameLabel.textColor = [UIColor whiteColor];
    self.translatorNameLabel.font = [Helper fontWithSize:16];
    self.translatorNameLabel.textAlignment = NSTextAlignmentLeft;
    self.translatorNameLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    self.translatorNameLabel.shadowOffset = CGSizeMake(1, 1);[self.transView addSubview:self.translatorNameLabel];
    
    UILabel *onlineLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 401, 120, 15)]];
    onlineLabel.text = @"Request notifications";
    onlineLabel.font = [Helper fontWithSize:13];
    onlineLabel.textAlignment = NSTextAlignmentLeft;
    onlineLabel.textColor = [UIColor blackColor];
    [self.transView addSubview:onlineLabel];
    
    self.pushLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 436, 170, 10)]];
    self.pushLabel.text = @"You will receive notification on new orders";
    self.pushLabel.backgroundColor = [UIColor clearColor];
    self.pushLabel.font = [Helper fontWithSize:9];
    self.pushLabel.textColor = [UIColor lightGrayColor];
    self.pushLabel.textAlignment = NSTextAlignmentLeft;
    self.pushLabel.adjustsFontSizeToFitWidth = YES;
    [self.transView addSubview:self.pushLabel];

    self.statusSwitch = [[UISwitch alloc] initWithFrame:[Helper getRectValue:CGRectMake(140, 396, 40, 20)]];
    [self.statusSwitch addTarget:self action:@selector(statusSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [self.transView addSubview:self.statusSwitch];
    
    self.translatorTableView = [[UITableView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0,  112, 197, 230)]];
    self.translatorTableView.backgroundColor = [UIColor clearColor];
    self.translatorTableView.scrollEnabled = NO;
    self.translatorTableView.delegate = self;
    self.translatorTableView.dataSource = self;
   // self.translatorTableView.separatorColor = [UIColor clearColor];
    [self.transView addSubview:self.translatorTableView];

    UIImageView *stripView1 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"grey_menu_line"]];
    stripView1.center = [Helper getPointValue:CGPointMake(123, [Helper isiPhone4] ? 442 : 530)];
    [self.view addSubview:stripView1];
    
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.frame = [Helper getRectValue:CGRectMake(0, [Helper isiPhone4] ? 442 : 530, 50, 36)];
    [logoutButton setImage:[Helper getImageByImageName:@"logout_icon"] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutButton];
    
    UILabel *logoutLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(36, [Helper isiPhone4] ? 450 : 538, 100, 20)]];
    logoutLabel.text = @"Log out";
    logoutLabel.font = [Helper fontWithSize:14];
    logoutLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:logoutLabel];

    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *transId =  [defaults objectForKey:kTranslatorId];
    self.isTranlator = (transId != nil && ![transId isEqualToString:@"-1"]);

}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateContent];
}

-(void) statusSwitchAction:(UISwitch *) sw{
    if (sw.isOn){
        self.pushLabel.text = @"You will receive notification on new orders";
    } else {
        self.pushLabel.text = @"You won't receive notification on new orders";
    }
    
    [self sendPush];
}

-(void) updateContent{
    
    if (self.isTranlator) {
    //    [self.menuContainerViewController setCenterViewController:self.myOrdersViewController];
        [self getTransInfo];
        self.transView.hidden = NO;
        self.clientView.hidden = YES;
        [self.translatorTableView reloadData];
    } else {
     //   [self.menuContainerViewController setCenterViewController:self.orderViewController];
        [self getProfile];
        self.transView.hidden = YES;
        self.clientView.hidden = NO;
        [self.clientTableView reloadData];
    }
}

//-(void) editAction:(UIButton*) button{
//    if (self.nameTextField.userInteractionEnabled) {
//        [self.editButton setImage:[Helper getImageByImageName:@"edit_icon"] forState:UIControlStateNormal];
//        self.nameTextField.userInteractionEnabled = NO;
//        [self changeUserName];
//    } else {
//        [self.editButton setImage:[Helper getImageByImageName:@"save_icon"] forState:UIControlStateNormal];
//        self.nameTextField.userInteractionEnabled = YES;
//        [self.nameTextField becomeFirstResponder];
//    }
//}

//-(void) addLanguageAction:(UIButton*) button{
//    [self settingsAction:button];
//    // [self.langActionSheet showInView:self.view];
//}
//
//-(void) settingsAction:(UIButton*) button{
//    if (self.isTranlator) {
//        [self.menuContainerViewController setCenterViewController:self.translatorSettingsViewController];
//        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
//    }
//}

-(void) logoutAction:(UIButton*) button{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you realy want to logout?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView show];
}

-(void) becomeAction:(UIButton*) button{

    BecomeTranslatorViewController *becomeTranslatorViewController = [[BecomeTranslatorViewController alloc] init];
    [self.menuContainerViewController.navigationController pushViewController:becomeTranslatorViewController animated:YES];

}

-(void) editProfilePicAction:(UIButton *) button{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"CHOOSE FROM", @"CHOOSE FROM") delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"CANCEL") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"CAMERA", @"CAMERA"), NSLocalizedString(@"PHOTOS", @"PHOTOS"), nil];
    [actionSheet showInView:self.view];
}

-(void) transHatTapGesture:(UITapGestureRecognizer *) gesture{
    [self.menuContainerViewController setCenterViewController:self.translatorSettingsViewController];
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

-(void) makeLogout{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session logout];
}

-(void) getProfile{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session getProfile];
}

-(void) getTransInfo{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *transId =  [defaults objectForKey:kTranslatorId];
    
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session getTransInfo:transId];
}

-(void) changeUserName{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session changeUserName:self.nameTextField.text andSurname:@"" andEmail:self.emailLabel.text];
}

-(void) sendPush{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *transId =  [defaults objectForKey:kTranslatorId];
    
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session setPushForTransId:transId andEnable:self.statusSwitch.on];
}

-(void) setImage{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session setImage:self.profileImageView.image];
    
}

//-(void) setLanguage{
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    NSString *transId =  [defaults objectForKey:kTranslatorId];
//    
//    PortalSession *session = [PortalSession sharedInstance];
//    session.delegate = self;
//    [session setLanguage:self.otherLang forTransId:transId];
//}


#pragma mark PortalSessionDelegate

-(void) getTransInfoResponse:(NSDictionary *)dict{
    NSLog(@"getTransInfoResponse %@", dict);
    
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
    [self.rateView removeFromSuperview];
    self.rateView = [Helper getRateView:[[dict objectForKey:@"rating"] integerValue]];
    self.rateView.center = [Helper getPointValue:CGPointMake(120, 65)];
    [self.transView addSubview:self.rateView];
    self.statusSwitch.on = ([[dict objectForKey:@"push"] integerValue] == 1);
    self.nativeLabel.text = [NSString stringWithFormat:@"%@(native)", [Helper getLanguageFromABRV:[dict objectForKey:@"native"]]];
    self.translatorNameLabel.text = [dict objectForKey:@"name"];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dict objectForKey:@"img"]]];
    if ([imageData length] > 0) {
        self.profileImageView.image = [UIImage imageWithData:imageData];
    }
    
    self.proLabel.text = [[dict objectForKey:@"pro"] isEqualToString:@"1"] ? @"Lingvo Pro" : @"Lingovo Pal";
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

-(void) getProfileResponse:(NSDictionary *) dict{
    NSLog(@"getProfileResponse %@", dict);
    //    self.phoneLabel.text = [dict objectForKey:@"phone"];
    self.emailLabel.text = [dict objectForKey:@"email"];
    self.nameTextField.text = [dict objectForKey:@"nickname"];
}

-(void) failedToGetProfile:(NSDictionary *) dict{
    NSLog(@"failedToGetProfile  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) timeoutToGetProfile:(NSError *) error{
    NSLog(@"timeoutToGetProfile");
    [self getProfile];
}

-(void) changeUserNameResponse:(NSDictionary *) dict{
    NSLog(@"changeUserNameResponse %@", dict);
}

-(void) failedToChangeUserName:(NSDictionary *) dict{
    NSLog(@"failedToChangeUserName  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) timeoutToChangeUserName:(NSError *) error{
    NSLog(@"timeoutToChangeUserName");
    [self changeUserName];
}

-(void) logoutResponse:(NSDictionary *) dict{
    NSLog(@"logoutResponse %@", dict);
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) failedToLogout:(NSDictionary *) dict{
    NSLog(@"failedToLogout  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) timeoutToLogout:(NSError *) error{
    NSLog(@"timeoutToLogout");
    [self logoutAction:nil];
}

-(void) setPushResponse:(NSDictionary *) dict{
    NSLog(@"setPushResponse %@", dict);
 
}


-(void) failedToSetPush:(NSDictionary *) dict{
    NSLog(@"failedToSetPush  %@", dict);
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


-(void) timeoutToSetPush:(NSError *) error{
    NSLog(@"timeoutToSetPush");
    [self sendPush];
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


//-(void) setLanguageResponse:(NSDictionary *) dict{
//    NSLog(@"setLanguageResponse %@", dict);
//    [self getTransInfo];
//}
//
//
//
//-(void) failedToSetLanguage:(NSDictionary *) dict{
//    NSLog(@"failedToSetLanguage  %@", dict);
//    
//    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
//    if (errorCode == 1) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    
//    if (errorCode == 100) {
//        [Helper showAlertViewWithText:@"You already specified this language, please select other one." delegate:nil];
//        return;
//    }
//}
//
//-(void) timeoutToSetLanguage:(NSError *) error{
//    NSLog(@"timeoutToSetLanguage");
//    [self setLanguage];
//}
//
-(void) leftMenuOpened{
    [self updateContent];
    [self.findInterpreterViewController leftMenuOpened];
}

-(void) leftMenuClosed{
    [self.findInterpreterViewController leftMenuClosed];
}

-(void) openOrders{
    [self.menuContainerViewController setCenterViewController:self.myOrdersViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isTranlator) {
        return 5;
    } else {
        return 4;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Helper getValue:46];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   
    if (self.isTranlator) {
        switch (indexPath.row) {
            case 0:{
                cell.titleLabel.text = NSLocalizedString(@"Active requests", @"Active requests");
                cell.iconImageView.image = [Helper getImageByImageName:@"orders_icon"];
            }
                break;
                
            case 1:{
                cell.titleLabel.text = NSLocalizedString(@"History", @"History");
                cell.iconImageView.image = [Helper getImageByImageName:@"history_icon"];
            }
                break;
                
//            case 2:{
//                cell.titleLabel.text = NSLocalizedString(@"Reviews", @"Reviews");
//                cell.iconImageView.image = [Helper getImageByImageName:@"reviews_icon"];
//            }
//                break;
            case 2:{
                cell.titleLabel.text = NSLocalizedString(@"Payments", @"Payments");
                cell.iconImageView.image = [Helper getImageByImageName:@"payments_icon"];
            }
                break;
            case 3:{
                cell.titleLabel.text = NSLocalizedString(@"Find interpreter", @"Find interpreter");
                cell.iconImageView.image = [Helper getImageByImageName:@"find_interpreter_icon"];
            }
                break;
            case 4:{
                cell.titleLabel.text = NSLocalizedString(@"Settings", @"Settings");
                cell.iconImageView.image = [Helper getImageByImageName:@"settings_icon"];
            }
                break;
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:{
                cell.titleLabel.text = NSLocalizedString(@"Find interpreter", @"Find interpreter");
                cell.iconImageView.image = [Helper getImageByImageName:@"find_interpreter_icon"];
            }
                break;
            case 1:{
                cell.titleLabel.text = NSLocalizedString(@"History", @"History");
                cell.iconImageView.image = [Helper getImageByImageName:@"history_icon"];
            }
                break;
            case 2:{
                cell.titleLabel.text = NSLocalizedString(@"Payments", @"Payments");
                cell.iconImageView.image = [Helper getImageByImageName:@"payments_icon"];
            }
                break;
            case 3:{
                cell.titleLabel.text = NSLocalizedString(@"Settings", @"Settings");
                cell.iconImageView.image = [Helper getImageByImageName:@"settings_icon"];
            }
                break;
                
            default:
                break;
        }
    }
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isTranlator) {
        switch (indexPath.row) {
            case 0:
            {
                [self.menuContainerViewController setCenterViewController:self.myOrdersViewController];
            }
                break;
            case 1:
            {
                [self.menuContainerViewController setCenterViewController:self.translatorHistoryViewController];
            }
                break;
//            case 2:
//            {
//                [self.menuContainerViewController setCenterViewController:self.translatorReviewViewController];
//            }
//                break;
            case 2:
            {
                [self.menuContainerViewController setCenterViewController:self.paymentViewConytoller];
            }
                break;
            case 3:
            {
                [self.menuContainerViewController setCenterViewController:self.findInterpreterViewController];
            }
                break;
            case 4:
            {
                [self.menuContainerViewController setCenterViewController:self.translatorSettingsViewController];
            }
                break;

            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
            {
                [self.menuContainerViewController setCenterViewController:self.findInterpreterViewController];
            }
                break;
            case 1:
            {
                [self.menuContainerViewController setCenterViewController:self.historyViewController];
            }
                break;
            case 2:
            {
                [self.menuContainerViewController setCenterViewController:self.paymentViewConytoller];
            }
                break;
            case 3:
            {
                // [self.menuContainerViewController setCenterViewController:self.paymentViewConytoller];
            }
                break;
            default:
                break;
        }
    }
  
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

#pragma UIAlertViewController
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self makeLogout];
    }
}


#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"buttonIndex %ld", (long)buttonIndex);
//    if (actionSheet == self.langActionSheet) {
//        if (buttonIndex != 0){
//            self.otherLang = [[Helper getLangsArray] objectAtIndex:(buttonIndex - 1)];
//            [self setLanguage];
//        }
//        return;
//    }
    
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
                                                        bounds:CGSizeMake(200, 200)
                                          interpolationQuality:kCGInterpolationHigh];
    
    self.profileImageView.image = resizedImage;
    
    [self setImage];
}

@end
