//
//  BecomeTranslatorViewController.m
//  LingvoPal
//
//  Created by Artak on 2/4/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "BecomeTranslatorViewController.h"
#import "Helper.h"
#import <CoreText/CoreText.h>
#import "MoreInfoViewController.h"
#import "PortalSession.h"

@interface BecomeTranslatorViewController () <UIActionSheetDelegate, PortalSessionDelegate>

@property (strong, nonatomic) UIImageView *bkgImageView;
@property (strong, nonatomic) UILabel *nativeLangLabel;
@property (strong, nonatomic) UILabel *lang1Label;
@property (strong, nonatomic) UILabel *lang2Label;

@property (nonatomic, strong) UIActionSheet *nativeActionSheet;
@property (nonatomic, strong) UIActionSheet *lang1ActionSheet;
@property (nonatomic, strong) UIActionSheet *lang2ActionSheet;

@property (strong, nonatomic) NSString *nativeLangString;
@property (strong, nonatomic) NSString *lang1String;
@property (strong, nonatomic) NSString *lang2String;


@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation BecomeTranslatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bkgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.bkgImageView.image = [Helper getImageByImageName:@"gradient1"];
    [self.view addSubview:self.bkgImageView];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[Helper getImageByImageName:@"back_icon"] forState:UIControlStateNormal];
    backButton.frame = [Helper getRectValue:CGRectMake(5, 20, 26, 42)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 30, 290, 50)]];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [Helper fontWithSize:22];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"BECOME AN\nINTERPRETER YOURSELF";
    titleLabel.numberOfLines = 2;
    
    [self.view addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 80, 300, 50)]];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = [Helper fontWithSize:15];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = @"Become a lingvo pal and make up to $42/hour,\nif you know languages well enough to help\nothers.";
    contentLabel.numberOfLines = 3;
    [self.view addSubview:contentLabel];
  
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"infographic"]];
    logoImageView.center = [Helper getPointValue:CGPointMake(160, 220)];
    [self.view addSubview:logoImageView];
    
    
    UILabel *nativeLang = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 300, 290, 14)]];
    nativeLang.text = @"PLEASE CHOOSE NATIVE LANGUAGE";
    nativeLang.font = [Helper fontWithSize:12];
    nativeLang.textColor = [UIColor whiteColor];
    nativeLang.textAlignment = NSTextAlignmentLeft;
    nativeLang.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    nativeLang.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:nativeLang];
    
    UIImageView *nativeLangBKG = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"text_cell"]];
    nativeLangBKG.frame = [Helper getRectValue:CGRectMake(40, 315, 240, 30)];
    nativeLangBKG.userInteractionEnabled = YES;
    [self.view addSubview:nativeLangBKG];

    self.nativeLangLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 5, 200, 20)]];
    self.nativeLangLabel.text = @"options";
    self.nativeLangLabel.textColor = [UIColor colorWithRed:(122.0f/255.0f) green:(122.0f/255.0f) blue:(126.0f/255.0f) alpha:1.0f];
    self.nativeLangLabel.font = [Helper fontWithSize:14];
    self.nativeLangLabel.backgroundColor = [UIColor clearColor];
    [nativeLangBKG addSubview:self.nativeLangLabel];
    
    UIButton* nativeLangButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nativeLangButton setBackgroundImage:[Helper getImageByImageName:@"choose_language_arrow_cell"] forState:UIControlStateNormal];
    nativeLangButton.frame = [Helper getRectValue:CGRectMake(210, 0, 30, 30)];
    [nativeLangButton addTarget:self action:@selector(nativeLangAction:) forControlEvents:UIControlEventTouchUpInside];
    [nativeLangBKG addSubview:nativeLangButton];
    
    UILabel *otherLang = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 350, 220, 14)]];
    otherLang.text = @"PLEASE CHOOSE OTHER LANGUAGES";
    otherLang.font = [Helper fontWithSize:12];
    otherLang.textColor = [UIColor whiteColor];
    otherLang.textAlignment = NSTextAlignmentLeft;
    otherLang.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    otherLang.shadowOffset = CGSizeMake(1, 1);
    
    [self.view addSubview:otherLang];

    UIImageView *lang1BKG = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"text_cell_half"]];
    lang1BKG.frame = [Helper getRectValue:CGRectMake(40, 365, 115,30)];
    lang1BKG.userInteractionEnabled = YES;
    [self.view addSubview:lang1BKG];

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
    arrowImageView.center = [Helper getPointValue:CGPointMake(160, 380)];
    [self.view addSubview:arrowImageView];
    
    UIImageView *lang2BKG = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"text_cell_half"]];
    lang2BKG.frame = [Helper getRectValue:CGRectMake(165, 365, 115,30)];
    lang2BKG.userInteractionEnabled = YES;
    [self.view addSubview:lang2BKG];
    
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
    
    
    UIButton * sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setBackgroundImage:[Helper getImageByImageName:@"send_request_cell"] forState:UIControlStateNormal];
    [sendButton setTitle:@"SEND REQUEST" forState:UIControlStateNormal];
    sendButton.titleLabel.font = [Helper fontWithSize:14];
    sendButton.frame = [Helper getRectValue:CGRectMake(40, 480, 240, 30)];
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
  
    UILabel *testLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 420, 290, 40)]];
    testLabel.textColor = [UIColor whiteColor];
    testLabel.font = [Helper fontWithSize:15];
    testLabel.textAlignment = NSTextAlignmentCenter;
    testLabel.text = @"TO BECOME AN INTERPRETER\nYOU MUST PASS THE TEST";
    testLabel.numberOfLines = 2;
    [self.view addSubview:testLabel];

    UILabel *instructionLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 520, 290, 40)]];
    instructionLabel.textColor = [UIColor whiteColor];
    instructionLabel.font = [Helper fontWithSize:15];
    instructionLabel.textAlignment = NSTextAlignmentCenter;
    instructionLabel.text = @"you will get all instuction on your\n email or                               .";
    instructionLabel.numberOfLines = 2;
    [self.view addSubview:instructionLabel];
    
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
    
    
    self.nativeActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please specify language:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *lang in [Helper getLangsArray]) {
        [self.nativeActionSheet addButtonWithTitle:[Helper getLanguageFromABRV:lang]];
    }
    
    self.lang1ActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please specify language:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *lang in [Helper getLangsArray]) {
        [self.lang1ActionSheet addButtonWithTitle:[Helper getLanguageFromABRV:lang]];
    }
    
    self.lang2ActionSheet = [[UIActionSheet alloc] initWithTitle:@"Please specify language:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (NSString *lang in [Helper getLangsArray]) {
        [self.lang2ActionSheet addButtonWithTitle:[Helper getLanguageFromABRV:lang]];
    }
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:[Helper getRectValue:CGRectMake(100, 100, 120, 120)]];
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:self.activityIndicator];

 }

-(void) nativeLangAction:(UIButton *) button{
    [self.nativeActionSheet showInView:self.view];
}

-(void) lang1Action:(UIButton *) button{
    [self.lang1ActionSheet showInView:self.view];
}

-(void) lang2Action:(UIButton *) button{
    [self.lang2ActionSheet showInView:self.view];
}

-(void) moreInfoAction:(UIButton *) button{
    MoreInfoViewController *moreInfoViewController = [[MoreInfoViewController alloc] init];
    [self.navigationController pushViewController:moreInfoViewController animated:YES];
}

-(void) sendAction:(UIButton *) button{
    if ((self.nativeLangString == nil) || [self.nativeLangString isEqualToString:@""] ||
        (self.lang1String == nil) || [self.lang1String isEqualToString:@""] ||
        (self.lang2String == nil) || [self.lang2String isEqualToString:@""] ) {
        
        [Helper showAlertViewWithText:@"Please choose languages." delegate:nil];
        return; //TODO::ARTAK show alert
    }
    
    if ([self.lang1String isEqualToString:self.lang2String]) {
        [Helper showAlertViewWithText:@"Please choose different languages." delegate:nil];
        return;
    }
    
    [self sendRequest];
}

-(void) backAction:(UIButton *) button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != 0) {
    
        if (actionSheet == self.nativeActionSheet) {
            self.nativeLangString = [[Helper getLangsArray] objectAtIndex:(buttonIndex - 1)];
            self.nativeLangLabel.text = [Helper getLanguageFromABRV:self.nativeLangString];
        }
        
        if (actionSheet == self.lang1ActionSheet) {
            self.lang1String = [[Helper getLangsArray] objectAtIndex:(buttonIndex - 1)];
            self.lang1Label.text = [Helper getLanguageFromABRV:self.lang1String];
        }
        
        if (actionSheet == self.lang2ActionSheet) {
            self.lang2String = [[Helper getLangsArray] objectAtIndex:(buttonIndex - 1)];
            self.lang2Label.text = [Helper getLanguageFromABRV:self.lang2String];
        }
    }
}

-(void) sendRequest{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session becomeTranslator:self.nativeLangString withLang1:self.lang1String withLang2:self.lang2String];
    [self.activityIndicator startAnimating];
}

-(void) becomeTranslatorResponse:(NSDictionary *) dict{
    NSLog(@"becomeTranslatorResponse %@", dict);

    [self.activityIndicator stopAnimating];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) failedToBecomeTranslator:(NSDictionary *) dict{
    NSLog(@"failedToBecomeTranslator  %@", dict);
    [self.activityIndicator stopAnimating];
}

-(void) timeoutToBecomeTranslator:(NSError *) error{
    NSLog(@"timeoutToBecomeTranslator");
    [self sendRequest];
}


@end
