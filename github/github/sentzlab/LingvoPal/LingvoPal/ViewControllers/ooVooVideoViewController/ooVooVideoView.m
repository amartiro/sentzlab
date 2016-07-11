//
//  ooVooVideoView.m
//  LingvoPal
//
//  Created by Artak Martirosyan on 6/30/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "ooVooVideoView.h"
#import "Helper.h"

@implementation ooVooVideoView

-(instancetype) initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.videoView = [[UIView alloc] initWithFrame:self.bounds];
        self.videoView.backgroundColor = [UIColor blueColor];
        [self addSubview:self.videoView];

        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,  [Helper getValue:24])];
        self.statusLabel.backgroundColor = [UIColor colorWithRed:0.9441 green:0.9441 blue:0.9441 alpha:0.350031672297297];
        self.statusLabel.text = @"";
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.statusLabel];

        self.roleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height -  [Helper getValue:24], frame.size.width,  [Helper getValue:24])];
        self.roleLabel.backgroundColor = [UIColor colorWithRed:0.9441 green:0.9441 blue:0.9441 alpha:0.350031672297297];
        self.roleLabel.text = @"";
        self.roleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.roleLabel];
    }

    return self;
}

- (void)setVideoView:(UIView *)videoView {

    if (_videoView != videoView) {

        [_videoView removeFromSuperview];
        _videoView = videoView;
        _videoView.frame = self.bounds;
        [self addSubview:self.videoView];
        [self sendSubviewToBack:self.videoView];
    }
}

- (void)layoutSubviews {

    [super layoutSubviews];

    if (CGRectEqualToRect(_videoView.bounds, self.bounds)) {

        return;
    }
    self.videoView.frame = self.bounds;

    self.statusLabel.frame = CGRectMake(0, 0, self.bounds.size.width,  [Helper getValue:24]);
    self.roleLabel.frame = CGRectMake(0, self.bounds.size.height -  [Helper getValue:24], self.bounds.size.width,  [Helper getValue:24]);
}

-(void) didVideoRenderStart
{
    NSLog(@"Panel - didVideoRenderStart - SHOW AVATAR = NO");
    
    [self showAvatar:NO] ;
}
-(void) didVideoRenderStop
{
    NSLog(@"Panel - didVideoRenderStop - SHOW AVATAR = YES");
    [self showAvatar:YES] ;
}

- (void)setAvatarImage{
    
    if (!imgView) {
        NSLog(@"Panel - setAvatarImage");
        
        imgView = [[UIImageView alloc] init];
        imgView.backgroundColor = [UIColor clearColor];
        
        //[imgView setImage:[UIImage imageNamed:@"profile"]];
        [self addSubview:imgView];
        [self setConstarinsTo:imgView];
    }
    
}

-(void)setConstarinsTo:(UIImageView*)imgView1{
    
    [self addConstraint:[self constraintToTopFor:imgView1]];
    [self addConstraint:[self constraintToBottomFor:imgView1]];
    [self addConstraint:[self constraintToLeftFor:imgView1]];
    [self addConstraint:[self constraintToRightFor:imgView1]];
    [imgView1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    
}

-(void)setImageVideoView{
    
    //    if (!self.img) {
    //        self.img = [[UIImageView alloc]init];
    //        [self addSubview:self.img];
    //       // self.backgroundColor=[UIColor greenColor];
    //        [self setConstarinsTo:self.img];
    //
    //    }
    
    
}

- (void)setLabelVideoAlert{
    [self setAvatarImage];
    
    if (!lblVideoAlert) {
        NSLog(@"Panel - setLabelVideoAlert");
        lblVideoAlert = [[UILabel alloc] init];
        [imgView addSubview:lblVideoAlert];
        lblVideoAlert.backgroundColor=[UIColor clearColor];
        lblVideoAlert.text=@"Video cannot be viewed";
        lblVideoAlert.textAlignment=NSTextAlignmentCenter;
        [lblVideoAlert setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
        lblVideoAlert.adjustsFontSizeToFitWidth=YES;
        [self addConstraint:[self constraintImageToTopFor:lblVideoAlert]];
        [self addConstraint:[self constraintImageToBottomFor:lblVideoAlert]];
        [self addConstraint:[self constraintImageToLeftFor:lblVideoAlert]];
        [self addConstraint:[self constraintImageToRightFor:lblVideoAlert]];
        [lblVideoAlert setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
}

-(void)showVideoAlert:(bool)show{
    NSLog(@"Panel - showVideoAlert %d",show);
    [self setLabelVideoAlert];
    lblVideoAlert.hidden=!show;
    [self showAvatar:show];
}

-(void)showAvatar:(bool)show{
    
    NSLog(@"Panel - showAvatar %d",show);
    
    [self setAvatarImage];
    
    imgView.hidden=!show;
    
    if (imgView.hidden)
        self.backgroundColor=[UIColor clearColor];
    else
        self.backgroundColor=[UIColor whiteColor];
}

#pragma mark - Constraint

-(NSLayoutConstraint*)constraintToTopFor:(UIView*)someView{
    
    return  [NSLayoutConstraint constraintWithItem:someView
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                         attribute:NSLayoutAttributeTop
                                        multiplier:1.0
                                          constant:0];
    
}

-(NSLayoutConstraint*)constraintToBottomFor:(UIView*)someView{
    
    return  [NSLayoutConstraint constraintWithItem:someView
                                         attribute:NSLayoutAttributeBottom
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                         attribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                          constant:0];
    
}
-(NSLayoutConstraint*)constraintToLeftFor:(UIView*)someView{
    
    return [NSLayoutConstraint constraintWithItem:someView
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:NSLayoutAttributeLeading
                                       multiplier:1.0
                                         constant:0];
}

-(NSLayoutConstraint*)constraintToRightFor:(UIView*)someView{
    
    return [NSLayoutConstraint constraintWithItem:someView
                                        attribute:NSLayoutAttributeTrailing
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self
                                        attribute:NSLayoutAttributeTrailing
                                       multiplier:1.0
                                         constant:0];
}


-(NSLayoutConstraint*)constraintImageToTopFor:(UIView*)someView{
    
    return  [NSLayoutConstraint constraintWithItem:someView
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:imgView
                                         attribute:NSLayoutAttributeTop
                                        multiplier:1.0
                                          constant:0];
    
}

-(NSLayoutConstraint*)constraintImageToBottomFor:(UIView*)someView{
    
    return  [NSLayoutConstraint constraintWithItem:someView
                                         attribute:NSLayoutAttributeBottom
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:imgView
                                         attribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                          constant:0];
    
}
-(NSLayoutConstraint*)constraintImageToLeftFor:(UIView*)someView{
    
    return [NSLayoutConstraint constraintWithItem:someView
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:imgView
                                        attribute:NSLayoutAttributeLeading
                                       multiplier:1.0
                                         constant:0];
}

-(NSLayoutConstraint*)constraintImageToRightFor:(UIView*)someView{
    
    return [NSLayoutConstraint constraintWithItem:someView
                                        attribute:NSLayoutAttributeTrailing
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:imgView
                                        attribute:NSLayoutAttributeTrailing
                                       multiplier:1.0
                                         constant:0];
}


-(void)animateImageFrame:(CGRect)frame{
    [UIView animateWithDuration:0.5 animations:^{
        imgView.frame = frame;
    }];
}


@end
