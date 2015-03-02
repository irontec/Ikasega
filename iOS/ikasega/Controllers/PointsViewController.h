//
//  PointsViewController.h
//  ikasega
//
//  Created by Sergio Garcia on 3/12/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
