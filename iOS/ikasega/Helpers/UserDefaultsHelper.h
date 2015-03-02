//
//  UserDefaultsHelper.h
//  ikasega
//
//  Created by Sergio Garcia on 28/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Activity.h"

@interface UserDefaultsHelper : NSObject

+ (void)setDataVersion:(NSNumber *)version;
+ (NSNumber *)getDataVersion;

+ (void)setUserActivity:(Activity *)activity;
+ (Activity *)getUserActivity;
@end
