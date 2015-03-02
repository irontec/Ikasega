//
//  AnswerHelper.m
//  ikasega
//
//  Created by Sergio Garcia on 22/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "AnswerHelper.h"

@implementation Answer (AnswerHelper)

- (void)generateWithDict:(NSDictionary *)data {
    
    self.answ = data[@"answ"];
    self.valid = data[@"valid"];
    self.idAnswer = [data[@"id"] stringValue];
}

@end
