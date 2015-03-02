//
//  Math.m
//  ikasega
//
//  Created by Sergio Garcia on 14/11/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "Math.h"

@implementation Math

+ (CGFloat)percentageWith:(CGFloat)value ofTotal:(CGFloat)total {

    if (value == 0) {
        return 0;
    }
    
    CGFloat percentage = value * 100 / total;
    if (percentage > 100) {
        percentage = 100;
    }
    return percentage;
}

@end
