//
//  ExamCompletedViewController.h
//  ikasega
//
//  Created by Sergio Garcia on 27/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ranking.h"
#import "Progress.h"
#import "CirclePercentage.h"

@interface ExamCompletedViewController : UIViewController

@property (strong, nonatomic) NSString *examTitle;
@property (strong, nonatomic) Progress *progress;
@property (strong, nonatomic) Ranking *ranking;

@property (weak, nonatomic) IBOutlet CirclePercentage *resultView;

@property (weak, nonatomic) IBOutlet UIView *viewDateTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDates;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalQuestions;
@property (weak, nonatomic) IBOutlet UILabel *lblRightAnswers;
@property (weak, nonatomic) IBOutlet UILabel *lblWrongAnswers;

@property (weak, nonatomic) IBOutlet UIButton *btnShare;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *percentageTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *percentageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *percentageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dataViewHeightConstraint;


- (IBAction)btnShareAction:(id)sender;
@end
