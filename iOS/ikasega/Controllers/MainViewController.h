//
//  ViewController.h
//  ikasega
//
//  Created by Sergio Garcia on 23/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
