//
//  CustomPopupView.h
//  LingvoPal
//
//  Created by Artak on 1/22/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPopupView : UIView

@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *forgotPasswordButton;
@property (nonatomic, strong) UITextField *fieldTextField;
@property (nonatomic, strong) UILabel * titelLabel;

-(instancetype) initWithNativeLang:(NSString *) lang;

@end
