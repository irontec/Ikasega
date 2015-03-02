//
//  UIColorIkasega.m
//  ikasega
//
//  Created by Sergio Garcia on 31/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "UIColorIkasega.h"


@implementation UIColor (Ikasega)

+ (UIColor *)ikasegaHighlighted {
    
    return [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.000];
}

+ (UIColor *)ikasegaOrange4 {
    
    return [UIColor colorWithRed:233/255.0 green:95/255.0 blue:34/255.0 alpha:1.0f];
}

+ (UIColor *)ikasegaBlue {
    
    return [UIColor colorWithRed:26/255.0 green:170/255.0 blue:174/255.0 alpha:1.0f];
}

+ (UIColor *)ikasegaBlueDark {
    
    return [UIColor colorWithRed:21/255.0 green:125/255.0 blue:127/255.0 alpha:1.0f];
}

+ (UIColor *)ikasegaBackground {
    
    return [UIColor whiteColor];
}

+ (UIColor *)ikasegaGray1 {
    
    return [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0f];
}

+ (UIColor *)ikasegaGray2 {
    
    return [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1.0f];
}

+ (UIColor *)ikasegaGray3 {
    
    return [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:1.0f];
}

+ (UIColor *)ikasegaGray4 {
    
    return [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1.0f];
}


+ (UIColor *)ikasegaGreen {

    return [UIColor colorWithRed:76/255.0 green:217/255.0 blue:100/255.0 alpha:1.000];
}

+ (UIColor *)ikasegaRed {

    return [UIColor colorWithRed:255/255.0 green:59/255.0 blue:48/255.0 alpha:1.000];
}

+ (UIColor *)backgroundColorWithPercentage:(CGFloat)percentage {
    
    if (percentage == 0) {
        return [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.000];
    } else if (percentage <= 20) {
        return [UIColor colorWithRed:249/255.0 green:215/255.0 blue:200/255.0 alpha:1.000];
    } else if (percentage <= 50) {
        return [UIColor colorWithRed:244/255.0 green:175/255.0 blue:144/255.0 alpha:1.000];
    } else if (percentage <= 75) {
        return [UIColor colorWithRed:239/255.0 green:135/255.0 blue:89/255.0 alpha:1.000];
    } else {
        return [UIColor colorWithRed:233/255.0 green:95/255.0 blue:34/255.0 alpha:1.000];
    }
}

@end
