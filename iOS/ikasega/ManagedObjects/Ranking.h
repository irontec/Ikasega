//
//  Ranking.h
//  ikasega
//
//  Created by Sergio Garcia on 10/11/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Ranking : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * percentage;
@property (nonatomic, retain) NSNumber * rightAnswers;
@property (nonatomic, retain) NSNumber * wrongAnswers;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * finishDate;
@property (nonatomic, retain) NSNumber * elapsedTime;

@end
