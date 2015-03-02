//
//  UIFontIkasega.m
//  ikasega
//
//  Created by Sergio Garcia on 28/1/15.
//  Copyright (c) 2015 Sergio Garcia. All rights reserved.
//

#import "UIFontIkasega.h"

@implementation UIFont (Ikasega)

+ (UIFont *)ikasegaRegularWithSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"Cabin-Regular" size:size];
}

+ (UIFont *)ikasegaBoldWithSize:(CGFloat)size {
    
    return [UIFont fontWithName:@"Cabin-Bold" size:size];
}

@end
