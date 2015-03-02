//
//  CirclePercentage.m
//  ikasega
//
//  Created by Sergio Garcia on 10/11/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "CirclePercentage.h"
#import "UIFontIkasega.h"


@implementation CirclePercentage {
    
    CGFloat outBorderWidth;
    CGFloat inBorderWidth;
    CGFloat progressLineWidth;
    CGFloat percentage;
    UIColor *successColor;
    UIColor *errorColor;
    UIColor *backgroundColor;
    UIColor *textColor;
    CGFloat labelPercentagePadding;
    UIColor *outBorderColor;
    UIColor *inBorderColor;
    CGFloat duration;
    
    
    UILabel *percentageLabel;
    CAShapeLayer *successRing;
    CAShapeLayer *errorRing;
    
}

#pragma mark - Default values

- (void)setupDefaultValues {
    
    // No editables
    outBorderWidth         = 1;
    inBorderWidth          = 1;
    labelPercentagePadding = 10;

    // User editables
    percentage             = 0.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        progressLineWidth      = 44;
    } else {
        progressLineWidth      = 22;
    }
    duration               = 2;

    // Main colors
    textColor              = [UIColor whiteColor];
    backgroundColor        = self.backgroundColor;
    [self updateBackgroundColor];
    successColor           = [UIColor colorWithRed:0.211 green:0.767 blue:0.332 alpha:1.000];
    errorColor             = [UIColor colorWithRed:0.801 green:0.106 blue:0.067 alpha:1.000];

    // Border colors
    outBorderColor         = [UIColor colorWithWhite:1.000 alpha:0.750];
    inBorderColor          = [UIColor colorWithWhite:1.000 alpha:0.750];
}


#pragma mark
#pragma mark - Configuration

-(id)init {
    
    self = [super init];
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat radius           = MIN(self.frame.size.width, self.frame.size.height) / 2;

    [self.layer setBorderWidth:outBorderWidth];
    [self.layer setBorderColor:outBorderColor.CGColor];
    self.layer.masksToBounds = YES;
    [self.layer setCornerRadius:radius];

    CGRect bezierFrame       = CGRectMake(outBorderWidth, outBorderWidth, self.frame.size.width - (2 * outBorderWidth), self.frame.size.height - (2 * outBorderWidth));
    CGFloat inset            = (progressLineWidth / 2);

    successRing              = [CAShapeLayer layer];
    successRing.path         = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(bezierFrame, inset, inset)
                                                          cornerRadius:radius-inset].CGPath;

    successRing.fillColor    = [UIColor clearColor].CGColor;
    successRing.strokeColor  = successColor.CGColor;
    successRing.lineWidth    = progressLineWidth;
    successRing.strokeStart  = 0.0f;
    successRing.strokeEnd    = 0.0f;

    errorRing                = [CAShapeLayer layer];
    errorRing.path           = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(bezierFrame, inset, inset)
                                                          cornerRadius:radius-inset].CGPath;
    errorRing.fillColor      = [UIColor clearColor].CGColor;
    errorRing.strokeColor    = errorColor.CGColor;
    errorRing.lineWidth      = progressLineWidth;
    errorRing.strokeStart    = successRing.strokeEnd;
    errorRing.strokeEnd      = successRing.strokeEnd;
    
    [self.layer addSublayer:successRing];
    [self.layer addSublayer:errorRing];
    
    [self createPercentageLabel];
}

- (void)createProgressView {
    
}

- (void)createPercentageLabel {
    
    CGFloat viewMaxSize = MAX(self.frame.size.width, self.frame.size.height) - (progressLineWidth * 2) - (outBorderWidth * 2);
    
    CGFloat position = outBorderWidth + progressLineWidth;
    CGRect viewFrame = CGRectMake(position, position, viewMaxSize, viewMaxSize);

    UIView *percentageView = [[UIView alloc] initWithFrame:viewFrame];
    [percentageView setBackgroundColor:[UIColor clearColor]];
    [percentageView.layer setMasksToBounds:YES];
    [percentageView.layer setCornerRadius:viewMaxSize / 2];
    [percentageView.layer setBorderWidth:inBorderWidth];
    [percentageView.layer setBorderColor:inBorderColor.CGColor];
    
    
    CGFloat maxSize = MIN(viewFrame.size.width, viewFrame.size.height) - (labelPercentagePadding * 2);
    CGRect frame = CGRectMake(labelPercentagePadding, labelPercentagePadding, maxSize, maxSize);
    percentageLabel = [[UILabel alloc] initWithFrame:frame];
    [percentageLabel setFont:[UIFont ikasegaBoldWithSize:150.0f]];
    
    [percentageLabel.layer setMasksToBounds:YES];
    [percentageLabel.layer setCornerRadius:maxSize / 2];
    
    [percentageLabel setMinimumScaleFactor:0.1];
    [percentageLabel setAdjustsFontSizeToFitWidth:YES];
    [percentageLabel setNumberOfLines:1];
    [percentageLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    
    [percentageLabel setBackgroundColor:[UIColor clearColor]];
    [percentageLabel setAlpha:0];
    [percentageLabel setTextColor:textColor];
    [percentageLabel setTextAlignment:NSTextAlignmentCenter];
    
    [percentageView addSubview:percentageLabel];
    [self addSubview:percentageView];
}

#pragma mark
#pragma mark - Animate percentaje label

- (void)setPercetageLabelAnimated {
    
    [UIView animateWithDuration:0.2 animations:^{
        [percentageLabel setAlpha:0];
        percentageLabel.transform = CGAffineTransformMakeScale(0.3, 0.3);
    } completion:^(BOOL finished) {
        CGFloat scaleFactor       = 0.6;
        percentageLabel.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
                                CGFloat scaleFactor       = 1.15;
                                percentageLabel.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
                                [percentageLabel setAlpha:0.8];
                            } completion:^(BOOL finished) {
                                [UIView animateWithDuration:0.25
                                                      delay:0.0
                                                    options:UIViewAnimationOptionCurveEaseOut animations:^{
                                                        CGFloat scaleFactor       = 1.0;
                                                        percentageLabel.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
                                                        [percentageLabel setAlpha:1];
                                                    } completion:nil];
                            }];
    }];
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    
    if([[theAnimation valueForKey:@"id"] isEqual:@"successAnimation"]) {
        // Change the model layer's property first.
        errorRing.strokeEnd              = 1.0f;
        
        // Then apply the animation.
        CABasicAnimation *errorAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        errorAnimation.duration          = duration * (1  - (CGFloat)(percentage / 100));
        errorAnimation.fromValue         = [NSNumber numberWithFloat:errorRing.strokeStart];
        errorAnimation.toValue           = [NSNumber numberWithFloat:errorRing.strokeEnd];
        errorAnimation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [errorRing addAnimation:errorAnimation forKey:@"drawCircleAnimation"];
    }
}

#pragma mark
#pragma mark - Default values management

- (void)setValuesWithAnimDuration:(NSNumber *)newDuration textColor:(UIColor *)newTextColor backgroundColor:(UIColor *)newBackgroundColor successColor:(UIColor *)newSuccessColor errorColor:(UIColor *)newErrorColor outBorderWidth:(NSNumber *)newOutBorderWidth inBorderWidth:(NSNumber *)newInBorderWidth outBorderColor:(UIColor *)newOutBorderColor inBorderColor:(UIColor *)newInBorderColor {
    
    if (newDuration) {
        duration = [newDuration floatValue];
    }
//    if (newLineWidth) {
//        progressLineWidth = [newLineWidth floatValue];
//    }
    if (newTextColor) {
        textColor = newTextColor;
        [self updateTextColor];
    }
    if (newBackgroundColor) {
        backgroundColor = newBackgroundColor;
        [self updateBackgroundColor];
    }
    if (newSuccessColor) {
        successColor = newSuccessColor;
        [self updateSuccessColor];
    }
    if (newErrorColor) {
        errorColor = newErrorColor;
        [self updateErrorColor];
    }
    if (newOutBorderWidth) {
        outBorderWidth = [newOutBorderWidth floatValue];
        [self updateOutBorderWidth];
    }
    if (newInBorderColor) {
        inBorderWidth = [newInBorderWidth floatValue];
        [self updateInBorderWidth];
    }
    if (newOutBorderColor) {
        outBorderColor = newOutBorderColor;
        [self updateOutBorderColor];
    }
    if (newInBorderColor) {
        inBorderColor = newInBorderColor;
        [self updateInBorderColor];
    }
}

- (void)updateTextColor {
    
    [percentageLabel setTextColor:textColor];
}

- (void)updateSuccessColor {
    
    [successRing setStrokeColor:successColor.CGColor];
}

- (void)updateErrorColor {
    
     [errorRing setStrokeColor:errorColor.CGColor];
}

- (void)updateBackgroundColor {
    
    [self setBackgroundColor:backgroundColor];
}

- (void)updateOutBorderWidth {
    
   [self.layer setBorderWidth:outBorderWidth];
}

- (void)updateInBorderWidth {
    
    [percentageLabel.layer setBorderWidth:inBorderWidth];
}

- (void)updateOutBorderColor {
    
    [self.layer setBorderColor:outBorderColor.CGColor];
}

- (void)updateInBorderColor {
    
    [percentageLabel.layer setBorderColor:outBorderColor.CGColor];
}
#pragma mark

#pragma mark - Public use

- (void)setPercentage:(CGFloat)newPercentage {
    
    percentage                         = newPercentage;
    
    [percentageLabel setText:[NSString stringWithFormat:@"%.0f%%", percentage]];
    
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
    
    // Change the model layer's property first.
    successRing.strokeEnd              = (CGFloat)(percentage / 100);
    
    // Then apply the animation.
    CABasicAnimation *successAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [successAnimation setValue:@"successAnimation" forKey:@"id"];
    successAnimation.duration          = duration * (CGFloat)(percentage / 100);
    successAnimation.fromValue         = [NSNumber numberWithFloat:successRing.strokeStart];
    successAnimation.toValue           = [NSNumber numberWithFloat:successRing.strokeEnd];
    successAnimation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    successAnimation.delegate          = self;
    
    [successRing addAnimation:successAnimation forKey:@"drawCircleAnimation"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setPercetageLabelAnimated];
    });
    
    errorRing.strokeStart              = successRing.strokeEnd;
    errorRing.strokeEnd                = successRing.strokeEnd;
}
#pragma mark
@end
