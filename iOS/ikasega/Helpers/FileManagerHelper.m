//
//  FileManagerHelper.m
//  ikasega
//
//  Created by Sergio Garcia on 27/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "FileManagerHelper.h"
#import "Exam.h"

@implementation FileManagerHelper

+ (NSString *)getLibraryCacheDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    return libraryDirectory;
}

+ (NSString *)getMp3FolderPath {
    
    NSString *libraryDirectory = [self getLibraryCacheDirectory];
    NSString *mp3Directory = [libraryDirectory stringByAppendingPathComponent:@"mp3"];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL isDir = YES;
    BOOL dirExists = [fileManager fileExistsAtPath:mp3Directory
                                       isDirectory:&isDir];
    if (!dirExists) {
        [fileManager createDirectoryAtPath:mp3Directory
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    return mp3Directory;
}

+ (NSString *)getAudioNameFromExam:(Exam *)exam {
    
    if (exam.file && ![exam.file isEqualToString:@""]) {
        return [exam.file stringByAppendingPathExtension:@"mp3"];
    }
    return nil;
}

+ (NSString *)getAudioPathFromExam:(Exam *)exam {
    
    NSString *audio = [FileManagerHelper getAudioNameFromExam:exam];
    if (audio) {
        NSString *filePath = [[FileManagerHelper getMp3FolderPath] stringByAppendingPathComponent:audio];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        BOOL isDir = NO;
        BOOL fileExists = [fileManager fileExistsAtPath:filePath
                                            isDirectory:&isDir];
        if (fileExists) {
            return filePath;
        }
    }
    return nil;
}

+ (void)deleteAudioFile:(Exam *)exam {
    
    NSString *audio = [FileManagerHelper getAudioNameFromExam:exam];
    if (audio) {
        NSString *filePath = [[FileManagerHelper getMp3FolderPath] stringByAppendingPathComponent:audio];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSError *error;
        [fileManager removeItemAtPath:filePath
                                error:&error];
        if (error) {
            NSLog(@"ERROR:%@\nFile:%@",[error description], filePath);
        } else {
            NSLog(@"%@ deleted", filePath);
        }
    }
}

@end
