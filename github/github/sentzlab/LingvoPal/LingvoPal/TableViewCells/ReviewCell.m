//
//  ReviewCell.m
//  LingvoPal
//
//  Created by Artak on 12/24/15.
//  Copyright © 2015 SentzLab. All rights reserved.
//

#import "ReviewCell.h"
#import "Helper.h"

@interface ReviewCell()

@property (strong, nonatomic) UIImageView *star1View;
@property (strong, nonatomic) UIImageView *star2View;
@property (strong, nonatomic) UIImageView *star3View;
@property (strong, nonatomic) UIImageView *star4View;
@property (strong, nonatomic) UIImageView *star5View;

@end

@implementation ReviewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bkgView = [[UIView alloc] initWithFrame:[Helper getRectValue:CGRectMake(0, 0, 320, 60)]];
        bkgView.backgroundColor = [UIColor whiteColor];
        bkgView.layer.cornerRadius = [Helper getValue:3];
        [self addSubview:bkgView];

        
        self.nameLabel= [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 5, 100, 15)]];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [Helper fontWithSize:14];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.nameLabel];
        
        
        self.contentLabel = [[UILabel alloc] initWithFrame:[Helper getRectValue:CGRectMake(5, 22, 230, 38)]];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = [Helper fontWithSize:8];
        self.contentLabel.numberOfLines = 4;
        self.contentLabel.textColor = [UIColor blackColor];
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.contentLabel];
        
        UIImageView *lineView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"white_reviews_line"]];
        lineView.center = [Helper getPointValue:CGPointMake(120, 59)];
        [self addSubview:lineView];
        
        
        self.star1View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"empty_rate_star"]];
        self.star1View.frame = [Helper getRectValue:CGRectMake(140, 3, 16, 16)];
        [self addSubview:self.star1View];
        
        self.star2View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"empty_rate_star"]];
        self.star2View.frame = [Helper getRectValue:CGRectMake(160, 3, 16, 16)];
        [self addSubview:self.star2View];
        
        self.star3View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"empty_rate_star"]];
        self.star3View.frame = [Helper getRectValue:CGRectMake(180, 3, 16, 16)];
        [self addSubview:self.star3View];
        
        self.star4View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"empty_rate_star"]];
        self.star4View.frame = [Helper getRectValue:CGRectMake(200, 3, 16, 16)];
        [self addSubview:self.star4View];
        
        self.star5View = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"empty_rate_star"]];
        self.star5View.frame = [Helper getRectValue:CGRectMake(220, 3, 16, 16)];
        [self addSubview:self.star5View];
        
    }
    
    return self;
}

-(void) setRate:(NSInteger)rate{
    
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

}


@end
