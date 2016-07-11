//
//  CustomPopupView.m
//  LingvoPal
//
//  Created by Artak on 1/22/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "CustomPopupView.h"
#import "Helper.h"
#import <CoreText/CoreText.h>

@interface CustomPopupView() <UITextFieldDelegate>

@property (nonatomic, strong) UIView * middleView;

@property (nonatomic, strong) UILabel *langLabel;

@end

@implementation CustomPopupView

-(instancetype) initWithNativeLang:(NSString *) lang{
    self = [super init];
    if (self) {
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        
        self.middleView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(13, 150, 294, 200)]];
        self.middleView.layer.cornerRadius = 5;
        self.middleView.backgroundColor = [UIColor colorWithRed:(244.0f/255.0f) green:(242.0f/255.0f) blue:(243.0f/255.0f) alpha:1.0f];
        [self addSubview:self.middleView];
        
        self.titelLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 15, 260, 35)]];
        self.titelLabel.backgroundColor = [UIColor clearColor];
        self.titelLabel.font = [Helper fontWithSize:16];
        self.titelLabel.textAlignment = NSTextAlignmentCenter;
        self.titelLabel.textColor = [UIColor grayColor];
        self.titelLabel.numberOfLines = 2;
        [self.middleView addSubview:self.titelLabel];
        
//        UIImageView *stripView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"grey_menu_line"]];
//        stripView.center = [Helper getPointValue:CGPointMake(147, 45)];
//        [self.middleView addSubview:stripView];
        
        self.fieldTextField = [[UITextField alloc] initWithFrame:[Helper getRectValue:CGRectMake(20, 65, 250, 35)]];
        self.fieldTextField.textColor = [UIColor colorWithRed:(122.0f/255.0f) green:(122.0f/255.0f) blue:(126.0f/255.0f) alpha:1.0f];
        self.fieldTextField.font = [Helper fontWithSize:26];
        self.fieldTextField.backgroundColor = [UIColor clearColor];
        self.fieldTextField.layer.cornerRadius = 3;
        self.fieldTextField.layer.borderWidth = 1;
        self.fieldTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.fieldTextField.secureTextEntry = YES;
        self.fieldTextField.delegate = self;
        [self.middleView addSubview:self.fieldTextField];
       
        
        self.forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.forgotPasswordButton.titleLabel.font = [Helper fontWithSize:15];
        self.forgotPasswordButton.frame = [Helper getRectValue:CGRectMake(45, 110, 200, 20)];
        [self.forgotPasswordButton setTitle:NSLocalizedString(@"FORGOT PASSWORD?", @"FORGOT PASSWORD?") forState:UIControlStateNormal];
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FORGOT PASSWORD?", @"FORGOT PASSWORD?")];
        [attString addAttribute:(NSString*)kCTUnderlineStyleAttributeName
                          value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                          range:(NSRange){0,[attString length]}];
        self.forgotPasswordButton.titleLabel.attributedText = attString;
        [self.forgotPasswordButton setTitleColor:[UIColor colorWithRed:(0.0f/255.0f) green:(204.0f/255.0f) blue:(205.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
        [self.middleView addSubview:self.forgotPasswordButton];

        self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.okButton.frame = [Helper getRectValue:CGRectMake(55, 160, 78, 30)];
        self.okButton.titleLabel.font = [Helper fontWithSize:10];
        [self.okButton setBackgroundImage:[Helper getImageByImageName:@"ok_cell"] forState:UIControlStateNormal];
        [self.okButton setTitle:@"OK" forState:UIControlStateNormal];
        [self.middleView addSubview:self.okButton];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = [Helper getRectValue:CGRectMake(159, 160, 78, 30)];
        self.cancelButton.titleLabel.font = [Helper fontWithSize:10];
        [self.cancelButton setBackgroundImage:[Helper getImageByImageName:@"cancel_cell"] forState:UIControlStateNormal];
        [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.middleView addSubview:self.cancelButton];
    }
    
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.fieldTextField resignFirstResponder];
    return YES;
}


@end
