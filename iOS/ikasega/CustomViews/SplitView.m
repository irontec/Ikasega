
//
//  SplitView.m
//  ikasega
//
//  Created by Sergio Garcia on 26/1/15.
//  Copyright (c) 2015 Sergio Garcia. All rights reserved.
//

#import "SplitView.h"
#import "UIColorIkasega.h"

NSInteger const lineWidth = 20;

@implementation SplitView {
    CAShapeLayer *shapeLayer;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.clipsToBounds = YES;
        [self setContentMode:UIViewContentModeRedraw];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    CGRect myRect = rect;
    myRect.size.width = myRect.size.width - 2;
    myRect.size.height = myRect.size.height - 2;
    myRect.origin.x = myRect.origin.x + 1;
    myRect.origin.y = myRect.origin.y + 1;
    
    [shapeLayer removeFromSuperlayer];
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPoint point = CGPointMake(0, 1);
    CGPathMoveToPoint(path, nil, point.x, point.y); // Top left -move
    
    point.x = rect.size.width/2 - lineWidth;
    point.y = 1;
    CGPathAddLineToPoint(path, nil, point.x, point.y); // Top center-left -draw
    
    point.x = rect.size.width/2;
    point.y = lineWidth + 1;
    CGPathAddLineToPoint(path, nil, point.x, point.y); // Top center -draw
    
    point.x = rect.size.width/2 + lineWidth;
    point.y = 1;
    CGPathAddLineToPoint(path, nil, point.x, point.y); // Top center-right -draw
    
    point.x = rect.size.width;
    point.y = 1;
    CGPathAddLineToPoint(path, nil, point.x, point.y); // Top right -draw
    
    point.x = rect.size.width/2;
    point.y = lineWidth + 1;
    CGPathMoveToPoint(path, nil, point.x, point.y); // Top center -move
    
    point.x = rect.size.width/2;
    point.y = rect.size.height - 1;
    CGPathAddLineToPoint(path, nil, point.x, point.y); // Top center-bottom -draw
    
    point.x = 0;
    point.y = rect.size.height - 1;
    CGPathMoveToPoint(path, nil, point.x, point.y); // Top center -move
    
    point.x = rect.size.width;
    point.y = rect.size.height - 1;
    CGPathAddLineToPoint(path, nil, point.x, point.y); // Top center-bottom -draw
    
    
    shapeLayer = [CAShapeLayer layer];
    
    [shapeLayer setPath:path];
    [shapeLayer setFillColor:[[UIColor whiteColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor ikasegaBlueDark] CGColor]];
    
    [[self layer] addSublayer:shapeLayer];
    CGPathRelease(path);
}


@end
