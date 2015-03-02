//
//  ExamTableViewCell.m
//  ikasega
//
//  Created by Sergio Garcia on 23/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "ExamTableViewCell.h"
#import "UIColorIkasega.h"

@implementation ExamTableViewCell


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    UIColor *percentageLabelColor = self.lblPercentage.backgroundColor;
    [super setHighlighted:highlighted
                 animated:animated];
    if (highlighted) {
        [self setBackgroundColor:[UIColor ikasegaHighlighted]];
    } else {
        [self setBackgroundColor:[UIColor ikasegaBackground]];
    }
    [self.lblPercentage setBackgroundColor:percentageLabelColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    UIColor *percentageLabelColor = self.lblPercentage.backgroundColor;
    [super setSelected:selected
              animated:animated];
    if (selected) {
        [self setBackgroundColor:[UIColor ikasegaHighlighted]];
    } else {
        [self setBackgroundColor:[UIColor ikasegaBackground]];
    }
    [self.lblPercentage setBackgroundColor:percentageLabelColor];
}

@end
