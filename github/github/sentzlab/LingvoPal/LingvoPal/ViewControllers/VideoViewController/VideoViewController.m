//
//  VideoViewController.m
//  LingvoPal
//
//  Created by Artak on 2/17/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "VideoViewController.h"
#import "Helper.h"
#import "PortalSession.h"

@interface VideoViewController () <PortalSessionDelegate>
@property (nonatomic, strong) UIButton *okButton;


@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bkgImageView.image = [Helper getImageByImageName:@"translater_profile_gradient"];
    
    UILabel *successLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(30, 60, 260, 50)]];
    successLabel.text = @"SUCCESS";
    successLabel.font = [Helper fontWithSize:40];
    successLabel.textColor = [UIColor whiteColor];
    successLabel.textAlignment = NSTextAlignmentCenter;
    successLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    successLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:successLabel];

    UILabel *streamLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(30, 160, 260, 35)]];
    streamLabel.text = [NSString stringWithFormat:@"streamId : %@", self.streamId];
    streamLabel.font = [Helper fontWithSize:30];
    streamLabel.textColor = [UIColor whiteColor];
    streamLabel.textAlignment = NSTextAlignmentCenter;
    streamLabel.shadowColor = [UIColor colorWithWhite:.0 alpha:.3];
    streamLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:streamLabel];
    
    self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.okButton setBackgroundImage:[Helper getImageByImageName:@"other_translater_cell"] forState:UIControlStateNormal];
    [self.okButton setTitle:@"OK" forState:UIControlStateNormal];
    self.okButton.titleLabel.font = [Helper fontWithSize:18];
    self.okButton.frame = [Helper getRectValue:CGRectMake(40, [Helper isiPhone4] ? 420 : 508, 240, 30)];
    [self.okButton addTarget:self action:@selector(okAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.okButton];
    
}

-(void) okAction:(UIButton *) button{
    [self setHistory];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void) setHistory{
    PortalSession *session = [PortalSession sharedInstance];
    session.delegate = self;
    [session setHistoryWithStreamId:self.streamId] ;
    [self startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setHistoryResponse:(NSDictionary *) dict{
    NSLog(@"setHistoryResponse %@", dict);
    [self stopAnimation];
    
}

-(void) failedToSetHIstory:(NSDictionary *) dict{
    NSLog(@"failedToSetHIstory  %@", dict);
    [self stopAnimation];
    
    NSInteger errorCode = [[dict objectForKey:@"status"] integerValue];
    if (errorCode == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) timeoutToSetHistory:(NSError *)error{
    NSLog(@"timeoutToSetHistory");
    [self setHistory];
}


@end
