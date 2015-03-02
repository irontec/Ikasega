//
//  Exam.h
//  ikasega
//
//  Created by Sergio Garcia on 28/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Question;

@interface Exam : NSManagedObject

@property (nonatomic, retain) NSString * created;
@property (nonatomic, retain) NSString * file;
@property (nonatomic, retain) NSString * hashExam;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * realFile;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSString * versionCode;
@property (nonatomic, retain) NSString * idExam;
@property (nonatomic, retain) NSSet *questions;
@end

@interface Exam (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(Question *)value;
- (void)removeQuestionsObject:(Question *)value;
- (void)addQuestions:(NSSet *)values;
- (void)removeQuestions:(NSSet *)values;

@end
