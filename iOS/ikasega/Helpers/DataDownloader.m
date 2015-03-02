//
//  DataDownloader.m
//  ikasega
//
//  Created by Sergio Garcia on 28/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "DataDownloader.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "UserDefaultsHelper.h"
#import "Exam.h"
#import "ExamHelper.h"
#import "FileManagerHelper.h"
#import "SVProgressHUD.h"
#import "Progress.h"
#import "ProgressHelper.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "UIFontIkasega.h"

#define BASE_URL @"http://ikastek.net/Ikasega/latest/"
#define EXAMS_JSON @"ikasega.json"
#define EXAMS_VERSION @"ikasega.version.json"

@implementation DataDownloader {
    
    AFHTTPSessionManager *_manager;
    NSManagedObjectContext *_managedObjectContext;
    NSMutableArray *_mp3List;
    NSInteger _actualMp3Index;
    BOOL _mp3DownloadError;
}

- (id)init {
    
    self = [super init];
    if (self) {
        [SVProgressHUD setFont:[UIFont ikasegaRegularWithSize:17.0f]];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [_managedObjectContext setPersistentStoreCoordinator:appDelegate.managedObjectContext.persistentStoreCoordinator];
    }
    return self;
}

#pragma mark - Loading view

- (void)showLoading {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD show];
    });
    NSLog(@"SHOW LOADING DATA...");
}

- (void)hideLoading {
    
    if ([SVProgressHUD isVisible]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
    NSLog(@"HIDE LOADING DATA...");
}

- (void)resetProgress {
    
    if ([SVProgressHUD isVisible]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD setStatus:[NSString stringWithFormat:@"%d/%lu", (_actualMp3Index + 1), (unsigned long)[_mp3List count]]];
        });
    }
}

- (void)updateProgressWith:(long long)downloaded fromTotalData:(long long)total {
    
    /*
    if ([SVProgressHUD isVisible]) {
        CGFloat value = (CGFloat)downloaded / (CGFloat)total;
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:value
                                 status:[NSString stringWithFormat:@"%d/%lu", (_actualMp3Index + 1), (unsigned long)[_mp3List count]]];
        });
    }
     */
}

#pragma mark - Data control

- (void)checkDataOnCompletion:(void(^)(BOOL success, BOOL dataAvalaible))completion {
    
    [_manager GET:EXAMS_VERSION parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *version = responseObject[@"version"];
        if ([version longValue] > [[UserDefaultsHelper getDataVersion] longValue]) {
            NSLog(@"NEW DATA AVALAIBLE");
            completion(YES, YES);
        } else {
            NSLog(@"DATA HAS THE LAST VERSION");
            completion(YES, NO);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"==================================================================================================================================");
        NSLog(@"task: %@", task);
        NSLog(@"error: %@", error);
        NSLog(@"==================================================================================================================================");
        
        completion(NO, YES);
    }];
}

- (void)updateData:(void (^)(NSError *error))completion {
    
    [self showLoading];
    [self test];
    [_manager GET:EXAMS_JSON parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self deserializeTask:task
           withResponseObject:responseObject
             forceMP3Download:YES
                    competion:^(BOOL deserializeError) {
                        NSError *error;
                        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                        if (deserializeError || _mp3DownloadError) {
                            if (deserializeError) {
                                [userInfo setValue:[NSNumber numberWithBool:deserializeError] forKey:@"deserializeError"];
                                [userInfo setValue:@"Error on data deserializer" forKey:@"deserializeErrorData"];
                            }
                            if (_mp3DownloadError) {
                                [userInfo setValue:[NSNumber numberWithBool:_mp3DownloadError] forKey:@"mp3DownloadError"];
                                [userInfo setValue:@"Error downloading in mp3 files" forKey:@"deserializeErrorData"];
                            }
                            error = [[NSError alloc] initWithDomain:@"updateData error" code:-9999 userInfo:userInfo];
                        }
                        
                        completion(error);
                    }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"==================================================================================================================================");
        NSLog(@"task: %@", task);
        NSLog(@"error: %@", error);
        NSLog(@"==================================================================================================================================");
        
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setValue:[NSNumber numberWithBool:YES] forKey:@"downloadError"];
        [userInfo setValue:@"Error downloading exams data" forKey:@"deserializeErrorData"];
        NSError *uError = [[NSError alloc] initWithDomain:@"updateData error" code:-8888 userInfo:userInfo];
        completion(uError);
        [self hideLoading];
    }];
}

- (void)deserializeTask:(NSURLSessionDataTask *)task withResponseObject:(id)responseObject forceMP3Download:(BOOL)forceMP3 competion:(void (^)(BOOL deserializeError))completion {
    
    if ([self checkMainThread:@"desserializeTask"]) {
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self deserializeTask:task
               withResponseObject:responseObject
                 forceMP3Download:forceMP3
                        competion:completion];
        });
        return;
    }
    
    NSNumber *version = responseObject[@"version"];
    if ([version longValue] <= [[UserDefaultsHelper getDataVersion] longValue]) {
        [self hideLoading];
        completion(NO);
        NSLog(@"DATA HAS THE LAST VERSION");
        return;
    }
    
    _mp3List = [[NSMutableArray alloc] init];
    NSMutableArray *examList = [[NSMutableArray alloc] init];
    examList = responseObject[@"exams"];
    
    NSMutableArray *actualIds = [[NSMutableArray alloc] init];
    for (NSInteger x = 0; x < [examList count]; x++) {
        
        NSDictionary *item = [examList objectAtIndex:x];
        [actualIds addObject:[item[@"id"] stringValue]];
        
        Exam *exam = [Exam getExamIfExistWithVersion:item[@"id"] inManagedObjectContext:_managedObjectContext];
        if (exam && item[@"version"] && [item[@"version"] longValue] <= [exam.version longValue]) {
            NSLog(@"EXAM WITH ID:%@ HAS THE LAST VERSION", exam.idExam);
            continue;
        }
        
        if (exam) {
            [Exam deleteAllExamData:exam
                    andSaveProgress:YES];
            [_managedObjectContext deleteObject:exam];
        }
        
        exam = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Exam class])
                                             inManagedObjectContext:_managedObjectContext];
        [exam generateWithDict:item];
        
        Progress *progress = [Progress getProgressIfExistWithExamId:exam.idExam
                                             inManagedObjectContext:_managedObjectContext];
        if (!progress) {
            progress = [NSEntityDescription
                        insertNewObjectForEntityForName:NSStringFromClass([Progress class])
                        inManagedObjectContext:_managedObjectContext];
            progress.idExam = exam.idExam;
            [progress resetProgress];
        }
        
        NSString *audio = [FileManagerHelper getAudioNameFromExam:exam];
        NSString *audioFilePath = [FileManagerHelper getAudioPathFromExam:exam];
        //Download if file not exist or if is forced
        if (audio && (!audioFilePath || forceMP3)) {
            //Exam has audio
            [_mp3List addObject:audio];
        }
    }
    [self deleteOldExams:actualIds];
    
    if ([self saveContext]) {
        [UserDefaultsHelper setDataVersion:version];
    }
    [self test];
    
    if ([_mp3List count] == 0) {
        [self hideLoading];
        completion(NO);
    } else {
        _mp3DownloadError = NO;
        [self downloadMP3sWithCompetion:^() {
            completion(NO);
        }];
    }
}

- (void)deleteOldExams:(NSArray *)actualExams {
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Exam class])
                                              inManagedObjectContext:_managedObjectContext];
    
    [fetch setEntity: entity];
    
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"NOT (idExam IN %@)", actualExams];
    
    [fetch setPredicate:predicate];
    NSArray * oldExams = [_managedObjectContext executeFetchRequest:fetch
                                                             error:nil];
    for (Exam *e in oldExams) {
        [Exam deleteAllExamData:e andSaveProgress:NO];
        [_managedObjectContext deleteObject:e];
    }
    NSLog(@"Old exams deleted (Total: %lu)", (unsigned long)[oldExams count]);
}

- (void)deleteAllExams {
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Exam class])
                                              inManagedObjectContext:_managedObjectContext];
    
    [fetch setEntity: entity];
    NSArray * result = [_managedObjectContext executeFetchRequest:fetch
                                                           error:nil];
    for (Exam *e in result) {
        [Exam deleteAllExamData:e andSaveProgress:YES];
        [_managedObjectContext deleteObject:e];
    }
    NSLog(@"All exams deleted");
}

#pragma mark - mp3 download

- (void)downloadMP3sWithCompetion:(void (^)(void))completion {
    
    if ([_mp3List objectAtIndex:_actualMp3Index]) {
        NSString *fileName = [_mp3List objectAtIndex:_actualMp3Index];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/mp3low/%@", BASE_URL, fileName]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSLog(@"filename: %@ url: %@", fileName, url);
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        NSString *fullPath = [[FileManagerHelper getMp3FolderPath] stringByAppendingPathComponent:fileName];
        
        [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
        
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            [self updateProgressWith:totalBytesRead
                       fromTotalData:totalBytesExpectedToRead];
            //            NSLog(@"bytesRead: %lu, totalBytesRead: %lld, totalBytesExpectedToRead: %lld", (unsigned long)bytesRead, totalBytesRead, totalBytesExpectedToRead);
        }];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"RES: %@", [[[operation response] allHeaderFields] description]);
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSError *error;
                NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath
                                                                                                error:&error];
                if (error) {
                    NSLog(@"ERR: %@ file:%@", [error description], fullPath);
                } else {
                    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
                    long long fileSize = [fileSizeNumber longLongValue];
                    NSLog(@"CORRECT - fileSize: %lld", fileSize);
                }
            });
            [self mp3Complete:YES andCompetion:completion];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"ERR: %@", [error description]);
            [self mp3Complete:NO andCompetion:completion];
        }];
        [operation start];
    }
}

- (void)downloadMP3:(NSString *)mp3FileName withCompletion:(void (^)(NSError *error))completion {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/mp3low/%@", BASE_URL, mp3FileName]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"mp3FileName: %@ url: %@", mp3FileName, url);

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSString *fullPath = [[FileManagerHelper getMp3FolderPath] stringByAppendingPathComponent:mp3FileName];
    
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
    
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        [self updateProgressWith:totalBytesRead
//                   fromTotalData:totalBytesExpectedToRead];
//    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@"RES: %@", [[[operation response] allHeaderFields] description]);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error;
            NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath
                                                                                            error:&error];
            if (error) {
                NSLog(@"ERR: %@ file:%@", [error description], fullPath);
            } else {
                NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
                long long fileSize = [fileSizeNumber longLongValue];
                NSLog(@"CORRECT - fileSize: %lld", fileSize);
            }
        });
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error);
    }];
    [operation start];
}

- (void)mp3Complete:(BOOL)result andCompetion:(void (^)(void))completion {
    
    if (!result) {
        _mp3DownloadError = YES;
    }
    
    _actualMp3Index++;
    if (_actualMp3Index == [_mp3List count]) {
        [self hideLoading];
        completion();
    } else {
        [self resetProgress];
        [self downloadMP3sWithCompetion:completion];
    }
}

- (void)test {
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:NSStringFromClass([Exam class])
                                              inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *array = [_managedObjectContext executeFetchRequest:request
                                                         error:&error];
    NSLog(@"Total exams: %lu", (unsigned long)[array count]);
}

- (BOOL)checkMainThread:(NSString *)log {
    
    if ([NSThread isMainThread]) {
        NSLog(@"MAIN - %@", log);
        return YES;
    } else {
        NSLog(@"NO MAIN - %@", log);
        return NO;
    }
}

- (BOOL)saveContext {
    
    if (_managedObjectContext != nil) {
        NSError *error = nil;
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            return NO;
        } else {
            NSLog(@"Context saved correctly.");
            return YES;
        }
    }
    return NO;
}

@end
