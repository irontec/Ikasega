//
//  ShareHelper.h
//  ikasega
//
//  Created by Sergio Garcia on 6/11/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface ShareHelper : NSObject

+ (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url inController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^)(void))completion;
@end
