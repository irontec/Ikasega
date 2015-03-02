//
//  HistoryViewController.m
//  ikasega
//
//  Created by Sergio Garcia on 27/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "HistoryViewController.h"
#import "AppDelegate.h"
#import "ActivityTableViewCell.h"
#import "Ranking.h"
#import "Math.h"
#import "ExamCompletedViewController.h"
#import "UIColorIkasega.h"

@interface HistoryViewController () {
    
    NSManagedObjectContext *managedObjectContext;
}
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    [self setTitle:NSLocalizedString(@"titleHistory", nil)];
    [self.view setBackgroundColor:[UIColor ikasegaBackground]];
    [_imgHistory setImage:[UIImage imageNamed:@"history"]];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    managedObjectContext = appDelegate.managedObjectContext;
    [self dataControllerSetup];
}

- (void)showEmptyView:(BOOL)show {
 
    [_lblEmptyText setText:NSLocalizedString(@"noExamsFinished", nil)];
    [_emptyView setHidden:!show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    NSInteger count = [sectionInfo numberOfObjects];
    [self showEmptyView:(count > 0 ? NO : YES)];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ActivityTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"activityTableViewCell"];
    [self configureCell:cell
            atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    ActivityTableViewCell *mCell = (ActivityTableViewCell *)cell;
    Ranking *ranking = [_fetchedResultsController objectAtIndexPath:indexPath];
    CGFloat percentage = [Math percentageWith:[ranking.rightAnswers floatValue] ofTotal:[ranking.rightAnswers integerValue] + [ranking.wrongAnswers integerValue]];
    
    [mCell setBackgroundColor:[UIColor clearColor]];
    
    [mCell.lblPercentage setTextColor:[UIColor whiteColor]];
    [mCell.lblPercentage setBackgroundColor:[UIColor backgroundColorWithPercentage:percentage]];
    mCell.lblPercentage.layer.masksToBounds = YES;
    mCell.lblPercentage.layer.cornerRadius = mCell.lblPercentage.frame.size.width / 2;
    
    [mCell.lblName setText:ranking.name];
    
    [mCell.lblPercentage setText:[NSString stringWithFormat:@"%.0f%%", percentage]];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Ranking *ranking = [_fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"examResults"
                              sender:ranking];
    [_tableView deselectRowAtIndexPath:indexPath
                              animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"examResults"]) {
        Ranking *r = (Ranking *)sender;
        ExamCompletedViewController *examCompletedController = (ExamCompletedViewController *)[segue destinationViewController];
        examCompletedController.examTitle = r.name;
        examCompletedController.ranking = r;
    }
}

#pragma mark - Data Control

- (void)dataControllerSetup {
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    NSError *error;
    if (![[self fetchResultsController] performFetch:&error]) {
        NSLog(@"All exams data. Unresolved error %@, %@", error, [error userInfo]);
    }
}

- (NSFetchedResultsController *)fetchResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *mfetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *mEntity = [NSEntityDescription entityForName:NSStringFromClass([Ranking class])
                                               inManagedObjectContext:managedObjectContext];
    [mfetchRequest setEntity:mEntity];
    [mfetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *msort = [[NSSortDescriptor alloc] initWithKey:@"percentage"
                                                          ascending:NO];
    [mfetchRequest setSortDescriptors:[NSArray arrayWithObject:msort]];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:mfetchRequest
                                                                                                  managedObjectContext:managedObjectContext
                                                                                                    sectionNameKeyPath:nil
                                                                                                             cacheName:nil];
    
    _fetchedResultsController = theFetchedResultsController;
    
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller {
    
    [[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController*)controller didChangeSection:(id)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    UITableView *tableView = [self tableView];
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                     withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                     withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath*)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath*)newIndexPath {
    
    UITableView *tableView = [self tableView];
    
    switch (type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller {
    
    [[self tableView] endUpdates];
}
@end
