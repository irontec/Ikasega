//
//  CirclePercentage.h
//  ikasega
//
//  Created by Sergio Garcia on 10/11/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CirclePercentage : UIView

- (void)setValuesWithAnimDuration:(NSNumber *)newDuration textColor:(UIColor *)newTextColor backgroundColor:(UIColor *)newBackgroundColor successColor:(UIColor *)newSuccessColor errorColor:(UIColor *)newErrorColor outBorderWidth:(NSNumber *)newOutBorderWidth inBorderWidth:(NSNumber *)newInBorderWidth outBorderColor:(UIColor *)newOutBorderColor inBorderColor:(UIColor *)newInBorderColor;
- (void)setPercentage:(CGFloat)newPercentage;
@end
