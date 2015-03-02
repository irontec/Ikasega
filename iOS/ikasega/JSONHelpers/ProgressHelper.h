//
//  ProgressHelper.h
//  ikasega
//
//  Created by Sergio Garcia on 28/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Progress.h"

@interface Progress (ProgressHelper)

+ (Progress *)getProgressIfExistWithExamId:(NSString *)idExam inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (void)resetProgress;

@end
