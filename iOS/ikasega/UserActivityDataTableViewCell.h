//
//  UserActivityDataTableViewCell.h
//  ikasega
//
//  Created by Sergio Garcia on 3/12/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserActivityDataTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblData;
@end
