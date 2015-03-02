//
//  NSNumber+Ikasega.m
//  ikasega
//
//  Created by Sergio Garcia on 3/12/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "NSNumber+Ikasega.h"

@implementation NSNumber (GoPlay)

- (NSString *)stringWithCustomFormat {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *convertNumber = [formatter stringForObjectValue:self];
    return convertNumber;
}

@end
