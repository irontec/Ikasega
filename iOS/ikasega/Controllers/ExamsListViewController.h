//
//  ExamsListViewController.h
//  ikasega
//
//  Created by Sergio Garcia on 22/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ExamsListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIImageView *imgDownload;
@property (weak, nonatomic) IBOutlet UILabel *lblEmptyText;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end
