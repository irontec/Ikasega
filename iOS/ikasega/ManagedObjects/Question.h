//
//  Question.h
//  ikasega
//
//  Created by Sergio Garcia on 28/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Answer, Exam;

@interface Question : NSManagedObject

@property (nonatomic, retain) NSString * idQuestion;
@property (nonatomic, retain) NSNumber * customOrder;
@property (nonatomic, retain) NSString * questionHtml;
@property (nonatomic, retain) NSString * questionText;
@property (nonatomic, retain) NSSet *answers;
@property (nonatomic, retain) Exam *exam;
@end

@interface Question (CoreDataGeneratedAccessors)

- (void)addAnswersObject:(Answer *)value;
- (void)removeAnswersObject:(Answer *)value;
- (void)addAnswers:(NSSet *)values;
- (void)removeAnswers:(NSSet *)values;

@end
