//
//  MenuTableViewCell.m
//  LingvoPal
//
//  Created by Artak on 2/15/16.
//  Copyright © 2016 SentzLab. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "Helper.h"

@implementation MenuTableViewCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        CGRect iconFrame = [Helper getRectValue:CGRectMake(10, 15, 15, 15)];
        CGRect nameFrame = [Helper getRectValue:CGRectMake(30, 12, 160, 20)];
     
       [self setBackgroundColor:[UIColor clearColor]];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:iconFrame];
        [self addSubview:self.iconImageView ];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:nameFrame];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [Helper fontWithSize:16];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLabel];
        
//        UIImageView *stripView1 = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"grey_menu_line"]];
//        stripView1.center = [Helper getPointValue:CGPointMake(123, 45)];
//        [self addSubview:stripView1];
        
        
//        UIImageView *stripView = [[UIImageView alloc] initWithImage:[Helper getImageByImageName:@"menu_arrow"]];
//        stripView.center = [Helper getPointValue:CGPointMake(180, 17)];
//        [self addSubview:stripView];
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
