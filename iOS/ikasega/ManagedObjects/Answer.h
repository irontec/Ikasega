//
//  Answer.h
//  ikasega
//
//  Created by Sergio Garcia on 28/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Question;

@interface Answer : NSManagedObject

@property (nonatomic, retain) NSString * answ;
@property (nonatomic, retain) NSNumber * valid;
@property (nonatomic, retain) NSString * idAnswer;
@property (nonatomic, retain) Question *question;

@end
