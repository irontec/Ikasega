//
//  PointsViewController.m
//  ikasega
//
//  Created by Sergio Garcia on 3/12/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "PointsViewController.h"
#import "UserActivityHeaderTableViewCell.h"
#import "UserActivityDataTableViewCell.h"
#import "UIColorIkasega.h"
#import "Activity.h"
#import "UserDefaultsHelper.h"
#import "Math.h"
#import "NSNumber+Ikasega.h"

@interface PointsViewController () {
    
    Activity *userActivity;
}

@end

@implementation PointsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    [self setTitle:NSLocalizedString(@"titlePoints", nil)];
    [self.view setBackgroundColor:[UIColor ikasegaBackground]];
    userActivity = [UserDefaultsHelper getUserActivity];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setAllowsSelection:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 135;
    } else {
        return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        // Header
        UserActivityHeaderTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"userActivityHeaderTableViewCell" forIndexPath:indexPath];
        [cell.lblPoints setTextColor:[UIColor ikasegaBlue]];
        [cell.lblTitle setTextColor:[UIColor ikasegaGray4]];
        [cell.lblTitle setText:NSLocalizedString(@"POINTS", nil)];
        NSNumber *totalPoints = [NSNumber numberWithInteger:[userActivity getTotalPoints]];
        [cell.lblPoints setText:[totalPoints stringWithCustomFormat]];
        return cell;
    } else {
        UserActivityDataTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"userActivityDataTableViewCell" forIndexPath:indexPath];
        [cell.dataView.layer setBorderColor:[UIColor ikasegaBlue].CGColor];
        [cell.dataView.layer setCornerRadius:8.0f];
        [cell.dataView.layer setBorderWidth:1.0f];
        
        [cell.lblData setTextColor:[UIColor ikasegaBlueDark]];
        [cell.lblTitle setTextColor:[UIColor ikasegaGray4]];
        switch (indexPath.row) {
            case 1:
                [cell.lblTitle setText:NSLocalizedString(@"totalFinishedExams", nil)];
                [cell.lblData setText:[NSString stringWithFormat:@"%ld", (long)[userActivity getTotalExams]]];
                break;
            case 2:
                [cell.lblTitle setText:NSLocalizedString(@"totalRightQuestions", nil)];
                [cell.lblData setText:[NSString stringWithFormat:@"%ld", (long)[userActivity getTotalRightAnswers]]];
                break;
            case 3:
                [cell.lblTitle setText:NSLocalizedString(@"totalWrongQuestions", nil)];
                [cell.lblData setText:[NSString stringWithFormat:@"%ld", (long)[userActivity getTotalWrongAnswers]]];
                break;
            case 4:
                [cell.lblTitle setText:NSLocalizedString(@"totalPercentage", nil)];
                NSInteger totalAnswers = [userActivity getTotalRightAnswers] + [userActivity getTotalWrongAnswers];
                [cell.lblData setText:[NSString stringWithFormat:@"%.0f%%", [Math percentageWith:[userActivity getTotalRightAnswers] ofTotal:totalAnswers]]];
                break;
            default:
                break;
        }
        return cell;
    }
}

@end
