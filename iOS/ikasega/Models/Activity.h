//
//  Activity.h
//  ikasega
//
//  Created by Sergio Garcia on 3/12/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject

- (void)resetValues;

- (void)addExam;
- (void)addRightAnswer;
- (void)addWrongAnswer;

- (NSInteger)getTotalPoints;
- (NSInteger)getTotalExams;
- (NSInteger)getTotalRightAnswers;
- (NSInteger)getTotalWrongAnswers;
@end
