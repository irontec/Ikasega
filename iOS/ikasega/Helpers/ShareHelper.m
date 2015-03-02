//
//  ShareHelper.m
//  ikasega
//
//  Created by Sergio Garcia on 6/11/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "ShareHelper.h"

@implementation ShareHelper

+ (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url inController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^)(void))completion
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    if (text) {
        [sharingItems addObject:text];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [controller presentViewController:activityController animated:animated completion:completion];}

@end
