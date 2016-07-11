//
//  CardsCell.m
//  LingvoPal
//
//  Created by Artak on 1/8/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "CardsCell.h"
#import "Helper.h"

@interface CardsCell()



@end

@implementation CardsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bkgView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 320, 52)]];
        bkgView.backgroundColor = [UIColor whiteColor];
        bkgView.layer.cornerRadius = [Helper getValue:3];
        [self addSubview:bkgView];
        
        
        self.cardImage= [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"visa_card"]];
        self.cardImage.center =  [Helper getPointValue:CGPointMake(35, 26)];
        [self addSubview:self.cardImage];
        
        self.cardNumberLabel= [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(70, 15, 100, 22)]];
        self.cardNumberLabel.backgroundColor = [UIColor clearColor];
        self.cardNumberLabel.font = [Helper fontWithSize:16];
        self.cardNumberLabel.textColor = [UIColor blackColor];
        self.cardNumberLabel.textAlignment = NSTextAlignmentLeft;
        self.cardNumberLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.cardNumberLabel];
        
        self.premiumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.premiumButton.frame = [Helper getRectValue:CGRectMake(230, 14, 83, 25)];
        self.premiumButton.titleLabel.font = [Helper fontWithSize:11];
        [self.premiumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.premiumButton setBackgroundImage:[Helper getImageByImageName:@"make_premium_cell"] forState:UIControlStateNormal];
        [self.premiumButton setTitle:@"Make Premium" forState:UIControlStateNormal];
        [self addSubview:self.premiumButton];
        
//        UIView *lineView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 51, 320, 1)]];
//        lineView.backgroundColor = [UIColor grayColor];
//        [self addSubview:lineView];
    }
    
    return self;
}


@end
