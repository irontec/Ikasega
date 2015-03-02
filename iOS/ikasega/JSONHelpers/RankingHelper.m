//
//  RankingHelper.m
//  ikasega
//
//  Created by Sergio Garcia on 27/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "RankingHelper.h"

@implementation Ranking (RankingHelper)

- (void)generateWithExam:(NSString *)examName withPercentage:(NSNumber *)percentage rightAnswers:(NSNumber *)rightAnswers wrongAnswers:(NSNumber *)wrongAnswer
               startDate:(NSDate *)starDate finishDate:(NSDate *)finishDate elpasedTime:(NSNumber *)elapsedTime {
    
    self.name = examName;
    self.percentage = percentage;
    self.rightAnswers = rightAnswers;
    self.wrongAnswers = wrongAnswer;
    
    self.startDate = starDate;
    self.finishDate = finishDate;
    self.elapsedTime = elapsedTime;
}
@end
