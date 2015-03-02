//
//  AnswerTableViewCell.m
//  ikasega
//
//  Created by Sergio Garcia on 23/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "AnswerTableViewCell.h"

@implementation AnswerTableViewCell {
    
    CGPoint lastPoint;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *aTouch = [touches anyObject];
    lastPoint = [aTouch locationInView:self];
    [super touchesBegan:touches withEvent:event];
}

- (CGPoint)getLastTouchPoint {

    return lastPoint;
}
@end
