//
//  TranslatorReviewCell.m
//  LingvoPal
//
//  Created by Artak on 2/1/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "TranslatorReviewCell.h"
#import "Helper.h"

@interface TranslatorReviewCell()

@property (strong, nonatomic) UIImageView *star1View;
@property (strong, nonatomic) UIImageView *star2View;
@property (strong, nonatomic) UIImageView *star3View;
@property (strong, nonatomic) UIImageView *star4View;
@property (strong, nonatomic) UIImageView *star5View;
@property (strong, nonatomic) UIView *bkgView;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation TranslatorReviewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        self.bkgView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 320, 88)]];
        self.bkgView.backgroundColor = [UIColor whiteColor];
        self.bkgView.layer.cornerRadius = [Helper getValue:3];
        [self addSubview:self.bkgView];
        
        self.nameLabel= [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 6, 160, 15)]];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [Helper fontWithSize:14];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.nameLabel];
        
        
        self.contentLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 81, 300, 0)]];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = [Helper fontWithSize:12];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textColor = [UIColor blackColor];
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
       // self.contentLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.contentLabel];
        
        self.lineView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 75, 300, 1)]];
        self.lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.lineView];
        
        UILabel *ratedYou = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(160, 7, 55, 15)]];
        ratedYou.text = @"rated you";
        ratedYou.textAlignment = NSTextAlignmentLeft;
        ratedYou.font  = [Helper fontWithSize:12];
        ratedYou.textColor = [UIColor grayColor];
        [self addSubview:ratedYou];
        
        
        self.star1View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"empty_rate_star"]];
        self.star1View.frame = [Helper getRectValue:CGRectMake(218, 5, 16, 16)];
        [self addSubview:self.star1View];
        
        self.star2View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"empty_rate_star"]];
        self.star2View.frame = [Helper getRectValue:CGRectMake(236, 5, 16, 16)];
        [self addSubview:self.star2View];
        
        self.star3View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"empty_rate_star"]];
        self.star3View.frame = [Helper getRectValue:CGRectMake(254, 5, 16, 16)];
        [self addSubview:self.star3View];
        
        self.star4View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"empty_rate_star"]];
        self.star4View.frame = [Helper getRectValue:CGRectMake(272, 5, 16, 16)];
        [self addSubview:self.star4View];
        
        self.star5View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"empty_rate_star"]];
        self.star5View.frame = [Helper getRectValue:CGRectMake(294, 5, 16, 16)];
        [self addSubview:self.star5View];
        
        UIColor *textColor = [UIColor grayColor];

        UILabel *dateLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 30, 140, 12)]];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [Helper fontWithSize:10];
        dateLabel.textColor = [UIColor blackColor];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        dateLabel.text = @"Order date";
        [self addSubview:dateLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(150, 30, 160, 12)]];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.font = [Helper fontWithSize:12];
        self.dateLabel.textColor = textColor;
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.dateLabel];

        
        UILabel *langLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 45, 140, 12)]];
        langLabel.backgroundColor = [UIColor clearColor];
        langLabel.font = [Helper fontWithSize:10];
        langLabel.textColor = [UIColor blackColor];
        langLabel.textAlignment = NSTextAlignmentLeft;
        langLabel.text = @"Language";
        [self addSubview:langLabel];
        
        self.langLabel= [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(150, 45, 160, 12)]];
        self.langLabel.backgroundColor = [UIColor clearColor];
        self.langLabel.font = [Helper fontWithSize:10];
        self.langLabel.textColor = textColor;
        self.langLabel.textAlignment = NSTextAlignmentRight;
        self.langLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.langLabel];
        
        
        UILabel *callTypeLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(10, 60, 140, 12)]];
        callTypeLabel.backgroundColor = [UIColor clearColor];
        callTypeLabel.font = [Helper fontWithSize:10];
        callTypeLabel.textColor = [UIColor blackColor];
        callTypeLabel.textAlignment = NSTextAlignmentLeft;
        callTypeLabel.text = @"Conference type";
        [self addSubview:callTypeLabel];
        
        self.callTypeLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(150, 60, 160, 12)]];
        self.callTypeLabel.textColor = textColor;
        self.callTypeLabel.font = [Helper fontWithSize:10];
        self.callTypeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.callTypeLabel];
    }
    
    return self;
}

-(void) setRate:(NSInteger) rate andReviewText:(NSString *) reviewText{
    
    if(rate >= 1){
        self.star1View.image = [Helper getImageByImageName:@"full_rate_star"];
    } else {
        self.star1View.image = [Helper getImageByImageName:@"empty_rate_star"];
    }
    
    if(rate >= 2){
        self.star2View.image = [Helper getImageByImageName:@"full_rate_star"];
    } else {
        self.star2View.image = [Helper getImageByImageName:@"empty_rate_star"];
    }
    
    if(rate >= 3){
        self.star3View.image = [Helper getImageByImageName:@"full_rate_star"];
    } else {
        self.star3View.image = [Helper getImageByImageName:@"empty_rate_star"];
    }
    
    if(rate >= 4){
        self.star4View.image = [Helper getImageByImageName:@"full_rate_star"];
    } else {
        self.star4View.image = [Helper getImageByImageName:@"empty_rate_star"];
    }
    
    if(rate >= 5){
        self.star5View.image = [Helper getImageByImageName:@"full_rate_star"];
    } else {
        self.star5View.image = [Helper getImageByImageName:@"empty_rate_star"];
    }
    
    if ([reviewText length] > 0) {
        CGSize size = [Helper getTextHeight:reviewText withFont:[Helper fontWithSize:12] andWidth:300];
        
        self.bkgView.frame = [Helper getRectValue:CGRectMake(0, 0, 320, 88 + size.height)];
        self.contentLabel.frame = [Helper getRectValue:CGRectMake(10, 81, 300, size.height)];
        self.contentLabel.text = reviewText;
        self.lineView.hidden = NO;
    } else {
        self.lineView.hidden = YES;
        self.contentLabel.hidden = YES;
        self.bkgView.frame = [Helper getRectValue:CGRectMake(0, 0, 320, 88)];
        self.lineView.hidden = YES;
        
    }
   
    
    
}

@end
