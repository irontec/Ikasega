//
//  QuestionHelper.m
//  ikasega
//
//  Created by Sergio Garcia on 22/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "QuestionHelper.h"
#import "Answer.h"
#import "AnswerHelper.h"

@implementation Question (QuestionHelper)

- (void)generateWithDict:(NSDictionary *)data {
    
    self.questionHtml = data[@"questionHtml"];
    self.questionText = data[@"questionText"];
    self.idQuestion =  [data[@"id"] stringValue];
    
    for (NSDictionary *answerData in data[@"answers"]) {
        Answer *answer = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Answer class])
                                                       inManagedObjectContext:self.managedObjectContext];
        [answer generateWithDict:answerData];
        [self addAnswersObject:answer];
    }
}

@end
