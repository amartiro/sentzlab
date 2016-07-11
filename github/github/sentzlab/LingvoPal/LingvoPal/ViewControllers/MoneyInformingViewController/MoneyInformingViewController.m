//
//  MoneyInformingViewController.m
//  LingvoPal
//
//  Created by Artak on 4/26/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "MoneyInformingViewController.h"
#import "Helper.h"

@interface MoneyInformingViewController ()

@end

@implementation MoneyInformingViewController

- (void)dealloc {
    
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bkgImageView.image = [Helper getImageByImageName:@"gradient2_short"];
    
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[Helper getImageByImageName:@"close1_icon"] forState:UIControlStateNormal];
    closeButton.frame = [Helper getRectValue:CGRectMake(0, 20, 60, 60)];
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    UILabel* contentLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 45, 290, 100)]];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.font = [Helper fontWithSize:15];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.numberOfLines = 4;
    contentLabel.text = self.content;
    [self.view addSubview:contentLabel];
    
    
    UILabel* callDurationLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 315, 290, 15)]];
    callDurationLabel.textColor = [UIColor whiteColor];
    callDurationLabel.font = [Helper fontWithSize:12];
    callDurationLabel.textAlignment = NSTextAlignmentCenter;
    callDurationLabel.text = @"CALL DURATION";
    [self.view addSubview:callDurationLabel];
    
    self.durationLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 335, 290, 35)]];
    self.durationLabel.textColor = [UIColor whiteColor];
    self.durationLabel.font = [Helper fontWithSize:32];
    self.durationLabel.textAlignment = NSTextAlignmentCenter;
    self.durationLabel.text = @"45 min";
    [self.view addSubview:self.durationLabel];
    
    UILabel* earnedLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 383, 290, 15)]];
    earnedLabel.textColor = [UIColor whiteColor];
    earnedLabel.font = [Helper fontWithSize:12];
    earnedLabel.textAlignment = NSTextAlignmentCenter;
    earnedLabel.text = @"EARNED MONEY";
    [self.view addSubview:earnedLabel];
    
    UIImageView *earnedImageView = [[UIImageView alloc] initWithFrame:[Helper getRectValue:CGRectMake(85, 400, 150, 41)]];
    earnedImageView.image = [Helper getImageByImageName:@"spent_money_user_cell"];
    [self.view addSubview:earnedImageView];
    
    self.spentLabel  = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(15, 405, 290, 30)]];
    self.spentLabel.textColor = [UIColor whiteColor];
    self.spentLabel.font = [Helper fontWithSize:28];
    self.spentLabel.textAlignment = NSTextAlignmentCenter;
    self.spentLabel.text = @"30 $";
    [self.view addSubview:self.spentLabel];

}

-(void) closeAction:(UIButton *) button{
    [self.navigationController popViewControllerAnimated:YES];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
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
