//
//  RankingTableViewCell.m
//  ikasega
//
//  Created by Sergio Garcia on 27/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "ActivityTableViewCell.h"
#import "UIColorIkasega.h"

@implementation ActivityTableViewCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    UIColor *percentageLabelColor = self.lblPercentage.backgroundColor;
    [super setHighlighted:highlighted
                 animated:animated];
    [self.lblPercentage setBackgroundColor:percentageLabelColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    UIColor *percentageLabelColor = self.lblPercentage.backgroundColor;
    [super setSelected:selected
              animated:animated];
    [self.lblPercentage setBackgroundColor:percentageLabelColor];
}

@end
