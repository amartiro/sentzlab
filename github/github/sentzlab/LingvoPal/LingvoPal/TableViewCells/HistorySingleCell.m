//
//  HistorySigleCell.m
//  LingvoPal
//
//  Created by Artak Martirosyan on 5/27/16.
//  Copyright © 2016 SentzLab Inc. All rights reserved.
//

#import "HistorySingleCell.h"
#import "Helper.h"

@implementation HistorySingleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bkgView.frame = [Helper getRectValue:CGRectMake(1, 0, 318, 208)];
        self.bkgView.image = [Helper getImageByImageName:@"history_cell"];
    }
    
    return self;
}
@end
