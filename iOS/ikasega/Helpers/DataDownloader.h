//
//  DataDownloader.h
//  ikasega
//
//  Created by Sergio Garcia on 28/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataDownloader : NSObject

- (void)checkDataOnCompletion:(void(^)(BOOL success, BOOL dataAvalaible))completion;
- (void)updateData:(void (^)(NSError *error))completion;

- (void)downloadMP3:(NSString *)mp3FileName withCompletion:(void (^)(NSError *error))completion;

@end
