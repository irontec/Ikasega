//
//  MainTableViewCell.h
//  ikasega
//
//  Created by Sergio Garcia on 28/1/15.
//  Copyright (c) 2015 Sergio Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@end
