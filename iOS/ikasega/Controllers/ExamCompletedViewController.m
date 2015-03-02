//
//  ExamCompletedViewController.m
//  ikasega
//
//  Created by Sergio Garcia on 27/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.

#import "ExamCompletedViewController.h"
#import "ProgressHelper.h"
#import "RankingHelper.h"
#import "ShareHelper.h"
#import "Math.h"
#import "UIColorIkasega.h"

@interface ExamCompletedViewController () <UIAlertViewDelegate> {
    
}

@end

@implementation ExamCompletedViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    [_resultView setValuesWithAnimDuration:nil
                                 textColor:[UIColor whiteColor]
                           backgroundColor:[UIColor ikasegaBlue]
                              successColor:[UIColor ikasegaGreen]
                                errorColor:[UIColor ikasegaRed]
                            outBorderWidth:[NSNumber numberWithInteger:1]
                             inBorderWidth:[NSNumber numberWithInteger:1]
                            outBorderColor:[UIColor ikasegaBlueDark]
                             inBorderColor:[UIColor ikasegaBlueDark]];
    [self setupUI];
}


- (void)setupUI {
    
    [self.view setBackgroundColor:[UIColor ikasegaBackground]];
    [self hideButtons:YES animated:NO];
    
    NSInteger topSpace, percentageTopSpace, widthHeight, dataHeight, dataTextSize;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        topSpace = 20;
        percentageTopSpace = 40;
        widthHeight = 200;
        dataHeight = 100;
        dataTextSize = 10;
    } else {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            // Portrait
            CGRect screenBound = [[UIScreen mainScreen] bounds];
            CGSize screenSize = screenBound.size;
            CGFloat screenWidth = screenSize.width;
            CGFloat screenHeight = screenSize.height;
             NSLog(@"Portrait!");
            if (screenHeight != 480) {
                //iPhone 5/6
                topSpace = 0;
                percentageTopSpace = 0;
                widthHeight = 0;
                dataHeight = 30;
                dataTextSize = 2;
            } else {
                //iPhone 4
                topSpace = 0;
                percentageTopSpace = 0;
                widthHeight = 0;
                dataHeight = 0;
                dataTextSize = 0;
            }
        } else {
            // Landscapte not allowed
            topSpace = 0;
            percentageTopSpace = 0;
            widthHeight = 0;
            dataHeight = 0;
            dataTextSize = 0;
        }
    }
    _topSpaceConstraint.constant = _topSpaceConstraint.constant + topSpace;
    _percentageTopSpaceConstraint.constant = _percentageTopSpaceConstraint.constant + percentageTopSpace;
    _percentageWidthConstraint.constant = _percentageWidthConstraint.constant + widthHeight;
    _percentageHeightConstraint.constant = _percentageHeightConstraint.constant + widthHeight;
    _dataViewHeightConstraint.constant = _dataViewHeightConstraint.constant + dataHeight;
    [_lblTotalQuestions setFont:[_lblTotalQuestions.font fontWithSize:_lblTotalQuestions.font.pointSize + dataTextSize]];
    [_lblRightAnswers setFont:[_lblRightAnswers.font fontWithSize:_lblRightAnswers.font.pointSize + dataTextSize]];
    [_lblWrongAnswers setFont:[_lblWrongAnswers.font fontWithSize:_lblWrongAnswers.font.pointSize + dataTextSize]];
    
    [_lblDateTitle setText:NSLocalizedString(@"When", nil)];
    [_lblDateTitle setTextColor:[UIColor ikasegaBlue]];
    [_lblDates setTextColor:[UIColor ikasegaGray4]];
    [_lblTimeTitle setText:NSLocalizedString(@"Time", nil)];
    [_lblTimeTitle setTextColor:[UIColor ikasegaBlue]];
    [_lblTime setTextColor:[UIColor ikasegaGray4]];
    
    [_lblTotalQuestions setTextColor:[UIColor ikasegaGray4]];
    [_lblRightAnswers setTextColor:[UIColor ikasegaGray4]];
    [_lblWrongAnswers setTextColor:[UIColor ikasegaGray4]];
    
    [_btnShare setTitle:NSLocalizedString(@"shareMessage", nil) forState:UIControlStateNormal];
    [_btnShare setBackgroundColor:[UIColor ikasegaBlue]];
    [_btnShare setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnShare setTitleColor:[UIColor ikasegaGray2] forState:UIControlStateHighlighted];
    
    CGRect imageFrame = _btnShare.imageView.frame;
    imageFrame.origin.x = _btnShare.frame.size.width - imageFrame.size.width - 16;
    
    UIImageView *shareImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share"]];
    [shareImageView setContentMode:UIViewContentModeScaleAspectFit];
    NSInteger margin = 14;
    CGFloat imageSize = _btnShare.frame.size.height - margin*2;
    [shareImageView setFrame:CGRectMake(_btnShare.frame.size.width - imageSize - margin, _btnShare.frame.size.height/2 - imageSize/2 , imageSize, imageSize)];
    [_btnShare addSubview:shareImageView];

    NSString *outputDateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy/MM/dd" options:0
                                                                  locale:[NSLocale currentLocale]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setLocale:[NSLocale currentLocale]];
//    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:outputDateFormat];
    
    NSString *initString, *finishString, *elapsedString;
    NSString *totalQuestion, *rigthAnwers, *wrongAnswers;
    if (_progress) {
        // From exam
        [self setTitle:_examTitle];
        
        // Create button for close modal view
        [self addCloseButton];
        [self addResetButton];
        
        totalQuestion = [NSString stringWithFormat:NSLocalizedString(@"examFinishedQuestion", nil), (unsigned long)[_progress.totalRightAnswers integerValue] + [_progress.totalWrongAnswers integerValue]];
        rigthAnwers = [NSString stringWithFormat:NSLocalizedString(@"examFinishedRight", nil), (long)[_progress.totalRightAnswers integerValue]];
        wrongAnswers = [NSString stringWithFormat:NSLocalizedString(@"examFinishedWrong", nil), (long)[_progress.totalWrongAnswers integerValue]];
        
        initString = [dateFormatter stringFromDate:_progress.startDate];
        finishString = [dateFormatter stringFromDate:_progress.finishDate];
        elapsedString = [self updateElapsedTimeDisplay:_progress.elapsedTime];
        
    } else {
        // From ranking
        [self setTitle:_ranking.name];
        
        totalQuestion = [NSString stringWithFormat:NSLocalizedString(@"examFinishedQuestion", nil), (unsigned long)[_ranking.rightAnswers integerValue] + [_ranking.wrongAnswers integerValue]];
        rigthAnwers = [NSString stringWithFormat:NSLocalizedString(@"examFinishedRight", nil), (long)[_ranking.rightAnswers integerValue]];
        wrongAnswers = [NSString stringWithFormat:NSLocalizedString(@"examFinishedWrong", nil), (long)[_ranking.wrongAnswers integerValue]];

        initString = [dateFormatter stringFromDate:_ranking.startDate];
        finishString = [dateFormatter stringFromDate:_ranking.finishDate];
        elapsedString = [self updateElapsedTimeDisplay:_ranking.elapsedTime];
    }
    
    [_lblTotalQuestions setText:totalQuestion];
    [_lblRightAnswers setText:rigthAnwers];
    [_lblWrongAnswers setText:wrongAnswers];

    // Only start date
    [_lblDates setText:[NSString stringWithFormat:@"%@", initString]];
    /*
    if ([initString isEqualToString:finishString]) {
        [_lblDates setText:[NSString stringWithFormat:@"%@", initString]];
    } else {
        [_lblDates setText:[NSString stringWithFormat:@"%@ - %@", initString, finishString]];
    }
     */
    [_lblTime setText:elapsedString];
}

- (void)addCloseButton {
    
    UIImage *closeImage = [UIImage imageNamed:@"close"];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton addTarget:self action:@selector(btnCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat maxSize = 25;
    [closeButton setImage:closeImage forState:UIControlStateNormal];
    [closeButton setFrame:CGRectMake(0, 0, maxSize, maxSize)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
}

- (void)addResetButton {
    
    UIImage *resetImage = [UIImage imageNamed:@"reset"];
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetButton addTarget:self action:@selector(btnResetAction:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat maxSize = 25;
    [resetButton setImage:resetImage forState:UIControlStateNormal];
    [resetButton setFrame:CGRectMake(0, 0, maxSize, maxSize)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:resetButton];

}

- (void)viewDidAppear:(BOOL)animated {
    
    NSAssert(_ranking || _progress, @"You need to set ranking or progress to load correctly.");
    
    // Graphic
    NSInteger rigthAnswers ,totalQuestions;
    if (_progress) {
        // From exam
        rigthAnswers = [_progress.totalRightAnswers integerValue];
        totalQuestions = rigthAnswers + [_progress.totalWrongAnswers integerValue];

    } else {
        // From ranking
        rigthAnswers = [_ranking.rightAnswers integerValue];
        totalQuestions = rigthAnswers + [_ranking.wrongAnswers integerValue];
    }
    [_resultView setPercentage:[Math percentageWith:rigthAnswers
                                            ofTotal:totalQuestions]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideButtons:NO animated:YES];
    });
}

- (NSString *)updateElapsedTimeDisplay:(NSNumber *)time {
    
    NSTimeInterval elapsedTime = [time integerValue];
    
    // Divide the interval by 3600 and keep the quotient and remainder
    div_t h = div(elapsedTime, 3600);
    int hours = h.quot;
    // Divide the remainder by 60; the quotient is minutes, the remainder
    // is seconds.
    div_t m = div(h.rem, 60);
    int minutes = m.quot;
    int seconds = m.rem;
    
    NSString *result = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    return result;
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

-(void)hideButtons:(BOOL)hide animated:(BOOL)animated {
    
    CGFloat time = 0.3;
    _btnShare.enabled = !hide;
    if (animated) {
        [UIView animateWithDuration:time animations:^{
             _btnShare.alpha = (hide ? 0 : 1);
        } completion:nil];
    } else {
        _btnShare.alpha = (hide ? 0 : 1);
    }
}

- (IBAction)btnCloseAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)btnResetAction:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"restoreExamTitle", nil)
                                                    message:NSLocalizedString(@"restoreExamenMessage", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"No", nil)
                                          otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
    alert.tag = 0;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 0 && buttonIndex == 1) {
        [_progress resetProgress];
        [_progress.managedObjectContext save:nil];
        [self btnCloseAction:nil];
    }
}

- (IBAction)btnShareAction:(id)sender {
    
    NSString *title;
    NSInteger rightQuestions;
    if (_progress) {
        title = _examTitle;
        rightQuestions = [_progress.totalRightAnswers integerValue];
    } else {
        title = _ranking.name;
        rightQuestions = [_ranking.rightAnswers integerValue];
    }

    [ShareHelper shareText:[NSString stringWithFormat:NSLocalizedString(@"shareText", nil), title, rightQuestions]
                  andImage:nil
                    andUrl:[NSURL URLWithString:NSLocalizedString(@"shareURL", nil)]
              inController:self
                  animated:YES
                completion:^{
                    NSLog(@"Shared!");
                }];
}
@end
