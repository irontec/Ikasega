//
//  Activity.m
//  ikasega
//
//  Created by Sergio Garcia on 3/12/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "Activity.h"

NSInteger const PointPerRightAnswer = 213;
NSInteger const PointPerFinishExamn = 5000;

@interface Activity()

@property (nonatomic) NSInteger totalPoints;
@property (nonatomic) NSInteger totalExams;
@property (nonatomic) NSInteger rightAnswers;
@property (nonatomic) NSInteger wrongAnswers;

@end

@implementation Activity

- (void)resetValues {
    
    _totalPoints = 0;
    _totalExams = 0;
    _rightAnswers = 0;
    _wrongAnswers = 0;
}

#pragma mark - Getters / Setters

- (void)addExam {
    
    _totalExams++;
    [self addFinishExamPoints];
}

- (void)addRightAnswer {
    
    _rightAnswers++;
    [self addRightCuestionPoints];
}

- (void)addWrongAnswer {
    
    _wrongAnswers++;
}

- (NSInteger)getTotalPoints {
    
    return _totalPoints;
}

- (NSInteger)getTotalExams {
    
    return _totalExams;
}

- (NSInteger)getTotalRightAnswers {
    
    return _rightAnswers;
}

- (NSInteger)getTotalWrongAnswers {
    
    return _wrongAnswers;
}

#pragma mark - Private

- (void)addFinishExamPoints {
    
    _totalPoints += PointPerFinishExamn;
}

- (void)addRightCuestionPoints {
    
    _totalPoints += PointPerRightAnswer;
}

#pragma mark - Encode / Decode

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeInteger:_totalPoints forKey:@"totalPoints"];
    [coder encodeInteger:_totalExams forKey:@"totalExams"];
    [coder encodeInteger:_rightAnswers forKey:@"rightAnswers"];
    [coder encodeInteger:_wrongAnswers forKey:@"wrongAnswers"];
}

- (id)initWithCoder:(NSCoder *)coder {
    
    self = [super init];
    if (self) {
        _totalPoints = [coder decodeIntegerForKey:@"totalPoints"];
        _totalExams = [coder decodeIntegerForKey:@"totalExams"];
        _rightAnswers = [coder decodeIntegerForKey:@"rightAnswers"];
        _wrongAnswers = [coder decodeIntegerForKey:@"wrongAnswers"];
    }
    return self;
}

@end
