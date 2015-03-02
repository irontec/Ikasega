//
//  RankingTableViewCell.h
//  ikasega
//
//  Created by Sergio Garcia on 27/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPercentage;
@end
