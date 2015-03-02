//
//  ExamHelper.m
//  ikasega
//
//  Created by Sergio Garcia on 22/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "ExamHelper.h"
#import "Question.h"
#import "QuestionHelper.h"
#import "Progress.h"
#import "ProgressHelper.h"
#import "FileManagerHelper.h"

@implementation Exam (ExamHelper)

+ (void)deleteAllExamData:(Exam *)exam {
    
    [self deleteAllExamData:exam andSaveProgress:NO];
}

+ (void)deleteAllExamData:(Exam *)exam andSaveProgress:(BOOL)save {
    
    [FileManagerHelper deleteAudioFile:exam];
    if (!save) {
        Progress *progress = [Progress getProgressIfExistWithExamId:exam.idExam
                                             inManagedObjectContext:exam.managedObjectContext];
        [exam.managedObjectContext deleteObject:progress];
    }
}

+ (Exam *)getExamIfExistWithVersion:(NSString *)idExam inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:NSStringFromClass([Exam class])
                                              inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idExam == %@", idExam];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [managedObjectContext executeFetchRequest:request
                                                         error:&error];
    if (array && [array count] > 0) {
        return [array objectAtIndex:0];
    } else {
        return nil;
    }
}

- (void)generateWithDict:(NSDictionary *)data {
    
    self.name = data[@"name"];
    self.file = data[@"file"];
    self.realFile = data[@"realFile"];
    self.version = data[@"version"];
    self.versionCode = data[@"versionCode"];
    self.hashExam = data[@"hash"];
    self.created = data[@"created"];
    self.idExam = [data[@"id"] stringValue];
    
    for (NSInteger x = 0; x < [data[@"questions"] count] ; x++) {
        Question *question = [NSEntityDescription
                              insertNewObjectForEntityForName:NSStringFromClass([Question class])
                              inManagedObjectContext:self.managedObjectContext];
        
        [question generateWithDict:[data[@"questions"] objectAtIndex:x]];
        question.customOrder = [NSNumber numberWithInteger:x];
        
        [self addQuestionsObject:question];
    }
}



@end
