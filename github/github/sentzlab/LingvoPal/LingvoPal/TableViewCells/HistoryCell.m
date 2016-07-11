//
//  HistoryCell.m
//  LingvoPal
//
//  Created by Artak on 12/18/15.
//  Copyright © 2015 SentzLab. All rights reserved.
//

#import "HistoryCell.h"
#import "Helper.h"

@implementation HistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bkgView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 320, 56)]];
        bkgView.backgroundColor = [UIColor whiteColor];
        bkgView.layer.cornerRadius = [Helper getValue:3];
        [self addSubview:bkgView];
        
        self.profileImageView= [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"profile_cell"]];
        self.profileImageView.frame = [Helper getRectValue:CGRectMake(5, 5, 37, 37)];
        [self addSubview:self.profileImageView];
        
        
        
        self.transNameLabel= [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(50, 5, 100, 20)]];
        self.transNameLabel.backgroundColor = [UIColor clearColor];
        self.transNameLabel.font = [Helper fontWithSize:18];
        self.transNameLabel.textColor = [UIColor blackColor];
        self.transNameLabel.textAlignment = NSTextAlignmentLeft;
        self.transNameLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.transNameLabel];
        
        
        self.langLabel= [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(50, 25, 100, 14)]];
        self.langLabel.backgroundColor = [UIColor clearColor];
        self.langLabel.font = [Helper fontWithSize:12];
        self.langLabel.textColor = [UIColor blackColor];
        self.langLabel.textAlignment = NSTextAlignmentLeft;
        self.langLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.langLabel];
        
        
        self.dateLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(50, 40, 100, 15)]];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.font = [Helper fontWithSize:12];
        self.dateLabel.textColor = [UIColor blackColor];
        self.dateLabel.textAlignment = NSTextAlignmentLeft;
        self.dateLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.dateLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(165, 40, 100, 15)]];
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.font = [Helper fontWithSize:12];
        self.priceLabel.textColor = [UIColor orangeColor];
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        self.priceLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.priceLabel];
      
        self.futureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.futureButton.frame = [Helper getRectValue:CGRectMake(203, 12, 52, 30)];
        self.futureButton.titleLabel.font = [Helper fontWithSize:10];
        [self.futureButton setBackgroundImage:[Helper getImageByImageName:@"for_future_cell"] forState:UIControlStateNormal];
        [self.futureButton setTitle:@"For Future" forState:UIControlStateNormal];
     //   [self addSubview:self.futureButton];
        
        self.rateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rateButton.frame = [Helper getRectValue:CGRectMake(263, 12, 52, 30)];
        self.rateButton.titleLabel.font = [Helper fontWithSize:10];
        [self.rateButton setBackgroundImage:[Helper getImageByImageName:@"rate_cell"] forState:UIControlStateNormal];
        [self.rateButton setTitle:@"Rate" forState:UIControlStateNormal];
        [self addSubview:self.rateButton];
        
//        UIView *lineView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 55, 320, 1)]];
//        lineView.backgroundColor = [UIColor grayColor];
//        [self addSubview:lineView];
    }
    
    return self;
}

@end
