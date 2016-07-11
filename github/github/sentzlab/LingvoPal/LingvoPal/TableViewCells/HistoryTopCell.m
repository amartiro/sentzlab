//
//  HistoryTopCell.m
//  LingvoPal
//
//  Created by Artak Martirosyan on 5/23/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "HistoryTopCell.h"
#import "Helper.h"

@implementation HistoryTopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bkgView.frame = [Helper getRectValue:CGRectMake(1, 0, 318, 201)];
        self.bkgView.image = [Helper getImageByImageName:@"history_top_cell"];
        
    }
    
    return self;
}

@end
