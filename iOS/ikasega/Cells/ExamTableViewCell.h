//
//  ExamTableViewCell.h
//  ikasega
//
//  Created by Sergio Garcia on 23/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblRightTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblRight;
@property (weak, nonatomic) IBOutlet UILabel *lblWrongTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblWrong;
@property (weak, nonatomic) IBOutlet UILabel *lblQuestionsTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblQuestions;
@property (weak, nonatomic) IBOutlet UILabel *lblPercentage;
@end
