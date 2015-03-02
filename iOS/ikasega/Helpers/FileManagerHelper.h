//
//  FileManagerHelper.h
//  ikasega
//
//  Created by Sergio Garcia on 27/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Exam;

@interface FileManagerHelper : NSObject

+ (NSString *)getMp3FolderPath;
+ (NSString *)getAudioNameFromExam:(Exam *)exam;
+ (NSString *)getAudioPathFromExam:(Exam *)exam;
+ (void)deleteAudioFile:(Exam *)exam;

@end
