//
//  AddCardViewController.m
//  LingvoPal
//
//  Created by Artak on 2/8/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "AddCardViewController.h"
#import "Helper.h"

@interface AddCardViewController ()
@property (nonatomic, strong) UITextField* cardTextField;
@property (nonatomic, strong) UITextField* cvvTextField;
@property (nonatomic, strong) UITextField* expirationYearTextField;
@property (nonatomic, strong) UITextField* expirationMonthTextField;

@end

@implementation AddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bkgImageView.image = [Helper getImageByImageName:@"gradient2"];
    // Do any additional setup after loading the view.
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[Helper getImageByImageName:@"back_icon"] forState:UIControlStateNormal];
    backButton.frame = [Helper getRectValue:CGRectMake(5, 20, 26, 42)];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UILabel *cardNumberLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 150, 200, 20)]];
    cardNumberLabel.text = @"CREDIT CARD NUMBER";
    cardNumberLabel.font =  [Helper fontWithSize:14];
    cardNumberLabel.textColor = [UIColor whiteColor];
    cardNumberLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    cardNumberLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:cardNumberLabel];
    
    UIImageView *cardNumberBKG = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"text_cell"]];
    cardNumberBKG.frame = [Helper getRectValue:CGRectMake(40, 170, 240, 30)];
    cardNumberBKG.userInteractionEnabled = YES;
    [self.view addSubview:cardNumberBKG];
    
    self.cardTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 7, 230, 16)]];
    self.cardTextField.placeholder = @"Credit Card Number";
    self.cardTextField.textColor = [UIColor colorWithRed:(122.0f/255.0f) green:(122.0f/255.0f) blue:(126.0f/255.0f) alpha:1.0f];
    self.cardTextField.font = [Helper fontWithSize:14];
    self.cardTextField.backgroundColor = [UIColor clearColor];
    [cardNumberBKG addSubview:self.cardTextField];
    
    UILabel *cvvNumberLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(40, 210, 100, 20)]];
    cvvNumberLabel.text = @"CVV";
    cvvNumberLabel.font =  [Helper fontWithSize:14];
    cvvNumberLabel.textColor = [UIColor whiteColor];
    cvvNumberLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    cvvNumberLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:cvvNumberLabel];
    
    UIImageView *cvvBKG = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"text_cell_half"]];
    cvvBKG.frame = [Helper getRectValue:CGRectMake(40, 230, 110, 30)];
    cvvBKG.userInteractionEnabled = YES;
    [self.view addSubview:cvvBKG];
    
    self.cvvTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 7, 100, 16)]];
    self.cvvTextField.placeholder = @"CVV";
    self.cvvTextField.textColor = [UIColor colorWithRed:(122.0f/255.0f) green:(122.0f/255.0f) blue:(126.0f/255.0f) alpha:1.0f];
    self.cvvTextField.font = [Helper fontWithSize:14];
    self.cvvTextField.backgroundColor = [UIColor clearColor];
    [cvvBKG addSubview:self.cvvTextField];

    
    UILabel *expDateLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(160, 210, 100, 20)]];
    expDateLabel.text = @"EXP. DATE";
    expDateLabel.font =  [Helper fontWithSize:14];
    expDateLabel.textColor = [UIColor whiteColor];
    expDateLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    expDateLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:expDateLabel];
    
    UIImageView *expirationMonthBKG = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"text_cell_quart"]];
    expirationMonthBKG.frame = [Helper getRectValue:CGRectMake(160, 230, 57, 30)];
    expirationMonthBKG.userInteractionEnabled = YES;
    [self.view addSubview:expirationMonthBKG];
    
    self.expirationMonthTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 7, 100, 16)]];
    self.expirationMonthTextField.placeholder = @"MM";
    self.expirationMonthTextField.textColor = [UIColor colorWithRed:(122.0f/255.0f) green:(122.0f/255.0f) blue:(126.0f/255.0f) alpha:1.0f];
    self.expirationMonthTextField.font = [Helper fontWithSize:14];
    self.expirationMonthTextField.backgroundColor = [UIColor clearColor];
    self.expirationMonthTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [expirationMonthBKG addSubview:self.expirationMonthTextField];
    
    
    UIImageView *expirationYearBKG = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"text_cell_quart"]];
    expirationYearBKG.frame = [Helper getRectValue:CGRectMake(223, 230, 57, 30)];
    expirationYearBKG.userInteractionEnabled = YES;
    [self.view addSubview:expirationYearBKG];
    
    self.expirationYearTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 7, 100, 16)]];
    self.expirationYearTextField.placeholder = @"YY";
    self.expirationYearTextField.textColor = [UIColor colorWithRed:(122.0f/255.0f) green:(122.0f/255.0f) blue:(126.0f/255.0f) alpha:1.0f];
    self.expirationYearTextField.font = [Helper fontWithSize:14];
    self.expirationYearTextField.backgroundColor = [UIColor clearColor];
    [expirationYearBKG addSubview:self.expirationYearTextField];
    
    UIButton * addCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addCardButton setBackgroundImage:[Helper getImageByImageName:@"add_card_cell"] forState:UIControlStateNormal];
    [addCardButton setTitle:@"ADD CARD" forState:UIControlStateNormal];
    addCardButton.titleLabel.font = [Helper fontWithSize:14];
    addCardButton.frame = [Helper getRectValue:CGRectMake(40, 290, 240, 30)];
    [addCardButton addTarget:self action:@selector(addCardAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addCardButton];

}

-(void) backAction:(UIButton *) button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) addCardAction:(UIButton *) button{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
