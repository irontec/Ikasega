//
//  Progress.h
//  ikasega
//
//  Created by Sergio Garcia on 10/11/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Question;

@interface Progress : NSManagedObject

@property (nonatomic, retain) NSString * idExam;
//@property (nonatomic, retain) NSNumber * totalAnweredQuestions;
@property (nonatomic, retain) NSNumber * totalRightAnswers;
@property (nonatomic, retain) NSNumber * totalWrongAnswers;
@property (nonatomic, retain) NSNumber * elapsedTime;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * finishDate;
@property (nonatomic, retain) NSSet *answeredQuestion;
@end

@interface Progress (CoreDataGeneratedAccessors)

- (void)addAnsweredQuestionObject:(Question *)value;
- (void)removeAnsweredQuestionObject:(Question *)value;
- (void)addAnsweredQuestion:(NSSet *)values;
- (void)removeAnsweredQuestion:(NSSet *)values;

@end
