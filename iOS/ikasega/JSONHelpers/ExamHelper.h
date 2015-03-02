//
//  ExamHelper.h
//  ikasega
//
//  Created by Sergio Garcia on 22/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Exam.h"

@interface Exam (ExamHelper)

+ (void)deleteAllExamData:(Exam *)exam;
+ (void)deleteAllExamData:(Exam *)exam andSaveProgress:(BOOL)save;
+ (Exam *)getExamIfExistWithVersion:(NSString *)idExam inManagedObjectContext:(NSManagedObjectContext *)managedObjectContex;

- (void)generateWithDict:(NSDictionary *)data;

@end
