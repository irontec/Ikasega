//
//  UserDefaultsHelper.m
//  ikasega
//
//  Created by Sergio Garcia on 28/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "UserDefaultsHelper.h"


#define DATA_VERSION @"data_version"
#define USER_ACTIVITY @"user_activity"

@implementation UserDefaultsHelper

+ (void)setDataVersion:(NSNumber *)version {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:version forKey:DATA_VERSION];
    [defaults synchronize];
}

+ (NSNumber *)getDataVersion {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:DATA_VERSION];
}

+ (void)setUserActivity:(Activity *)activity {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedActivity = [NSKeyedArchiver archivedDataWithRootObject:activity];
    [defaults setObject:encodedActivity forKey:USER_ACTIVITY];
    [defaults synchronize];
}

+ (Activity *)getUserActivity {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedActivity = [defaults objectForKey:USER_ACTIVITY];
    Activity *activity = [NSKeyedUnarchiver unarchiveObjectWithData:encodedActivity];
    if (!activity) {
        activity = [[Activity alloc] init];
        [activity resetValues];
    }
    return activity;
}

@end
