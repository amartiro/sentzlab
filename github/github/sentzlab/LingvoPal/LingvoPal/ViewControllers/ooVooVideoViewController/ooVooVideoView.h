//
//  ooVooVideoView.h
//  LingvoPal
//
//  Created by Artak Martirosyan on 6/30/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import <ooVooSDK/ooVooSDK.h>

@interface ooVooVideoView :  ooVooVideoPanel{
    UILabel *lblUserName;
    UIImageView *imgView;
    UILabel *lblVideoAlert;
}


@property (strong, nonatomic) UIView *videoView;
@property (strong, nonatomic) UILabel *roleLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@property (nonatomic, strong) NSString *strUserId;


-(instancetype) initWithFrame:(CGRect)frame;

-(void)showAvatar:(bool)show;
-(void)showVideoAlert:(bool)show;
-(void)animateImageFrame:(CGRect)frame;

@end
