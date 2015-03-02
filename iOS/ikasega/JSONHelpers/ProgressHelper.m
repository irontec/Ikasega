//
//  ProgressHelper.m
//  ikasega
//
//  Created by Sergio Garcia on 28/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "ProgressHelper.h"

@implementation Progress (ProgressHelper)

- (void)resetProgress {
    
    self.totalRightAnswers = 0;
    self.totalWrongAnswers = 0;
    self.answeredQuestion = nil;
    
    self.startDate = nil;
    self.finishDate = nil;
    self.elapsedTime = 0;
}

+ (Progress *)getProgressIfExistWithExamId:(NSString *)idExam inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([Progress class])
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

@end
