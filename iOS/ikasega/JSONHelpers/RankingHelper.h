//
//  RankingHelper.h
//  ikasega
//
//  Created by Sergio Garcia on 27/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ranking.h"

@interface Ranking (RankingHelper)

- (void)generateWithExam:(NSString *)examName withPercentage:(NSNumber *)percentage rightAnswers:(NSNumber *)rightAnswers wrongAnswers:(NSNumber *)wrongAnswer
               startDate:(NSDate *)starDate finishDate:(NSDate *)finishDate elpasedTime:(NSNumber *)elapsedTime;

@end
