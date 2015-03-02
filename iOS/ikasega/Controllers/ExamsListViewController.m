//
//  ExamsListViewController.m
//  ikasega
//
//  Created by Sergio Garcia on 22/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "ExamsListViewController.h"
#import "AppDelegate.h"
#import "Exam.h"
#import "Progress.h"
#import "ProgressHelper.h"
#import "ExamTableViewCell.h"
#import "QuestionsViewController.h"
#import "ExamCompletedViewController.h"
#import "UIColorIkasega.h"
#import "DataDownloader.h"
#import "Math.h"

@interface ExamsListViewController () {
    
    NSManagedObjectContext *managedObjectContext;
}

@end

@implementation ExamsListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    [self setTitle:NSLocalizedString(@"titleExams", nil)];
    [self.view setBackgroundColor:[UIColor ikasegaBackground]];
    [_imgDownload setImage:[UIImage imageNamed:@"download"]];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    managedObjectContext = appDelegate.managedObjectContext;
    [self dataControllerSetup];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(emptyViewAction:)];
    [_emptyView addGestureRecognizer:singleFingerTap];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [_tableView reloadData];
}

- (void)showEmptyView:(BOOL)show {
    
    [_lblEmptyText setText:NSLocalizedString(@"noExamsDownloaded", nil)];
    [_emptyView setHidden:!show];
    [_emptyView setUserInteractionEnabled:show];
}
- (void)emptyViewAction:(id)sender {
    
    DataDownloader *dataDownloader = [[DataDownloader alloc] init];
    [_emptyView setUserInteractionEnabled:NO];
    [dataDownloader updateData:^(NSError *error) {
        [_emptyView setUserInteractionEnabled:YES];
        if (!error) {
            NSLog(@"Datos actualizados");
        } else {
            @try {
                BOOL examErrorResult = [error.userInfo[@"deserializeError"] boolValue];
                BOOL mp3ErrorResult = [error.userInfo[@"mp3DownloadError"] boolValue];
                
                if (examErrorResult) {
                    NSLog(@"Error descargado examenes...");
                }
                if (mp3ErrorResult) {
                    NSLog(@"Error descargado ficheros mp3...");
                    // TODO: Error message
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Error descargando el fichero...inetnalo de nuevo...");
            }
            @finally {
                // TODO: Error message
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    NSInteger count = [sectionInfo numberOfObjects];
    [self showEmptyView:(count > 0 ? NO : YES)];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExamTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"examTableViewCell"];
    [self configureCell:cell
            atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    ExamTableViewCell *mCell = (ExamTableViewCell *)cell;
    Exam *e = [_fetchedResultsController objectAtIndexPath:indexPath];
    Progress *progress = [Progress getProgressIfExistWithExamId:e.idExam inManagedObjectContext:managedObjectContext];
    CGFloat totalCuestions = [e.questions allObjects].count;
    CGFloat anweredQuestions = [progress.totalRightAnswers integerValue] + [progress.totalWrongAnswers integerValue];
    
    
    mCell.lblPercentage.layer.masksToBounds = YES;
    mCell.lblPercentage.layer.cornerRadius = mCell.lblPercentage.frame.size.width / 2;

    // Color
    [mCell.lblPercentage setTextColor:[UIColor whiteColor]];
    [mCell.lblPercentage setBackgroundColor:[UIColor backgroundColorWithPercentage:[Math percentageWith:anweredQuestions
                                                                                                ofTotal:totalCuestions]]];
    [mCell.lblName setTextColor:[UIColor ikasegaGray4]];
    [mCell.lblRightTitle setTextColor:[UIColor ikasegaGray2]];
    [mCell.lblWrongTitle setTextColor:[UIColor ikasegaGray2]];
    [mCell.lblQuestionsTitle setTextColor:[UIColor ikasegaGray2]];
    [mCell.lblRight setTextColor:[UIColor ikasegaGray2]];
    [mCell.lblWrong setTextColor:[UIColor ikasegaGray2]];
    [mCell.lblQuestions setTextColor:[UIColor ikasegaGray2]];
    // Titles
    [mCell.lblQuestionsTitle setText:NSLocalizedString(@"Questions", nil)];
    [mCell.lblRightTitle setText:NSLocalizedString(@"Right", nil)];
    [mCell.lblWrongTitle setText:NSLocalizedString(@"Wrong", nil)];
    // Data
    [mCell.lblName setText:e.name];
    [mCell.lblRight setText:[NSString stringWithFormat:@"%ld", (long)[progress.totalRightAnswers integerValue]]];
    [mCell.lblWrong setText:[NSString stringWithFormat:@"%ld", (long)[progress.totalWrongAnswers integerValue]]];
    [mCell.lblQuestions setText:[NSString stringWithFormat:@"%ld", (long)[e.questions allObjects].count]];

    [mCell.lblPercentage setText:[NSString stringWithFormat:@"%.0f%%", [Math percentageWith:anweredQuestions
                                                                                    ofTotal:totalCuestions]]];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Exam *e = [_fetchedResultsController objectAtIndexPath:indexPath];
    Progress *progress = [Progress getProgressIfExistWithExamId:e.idExam
                                         inManagedObjectContext:managedObjectContext];

    NSInteger total = [progress.totalRightAnswers integerValue] + [progress.totalWrongAnswers integerValue];//[progress.totalAnweredQuestions intValue];
    
    if (total < [e.questions allObjects].count) {
        [self performSegueWithIdentifier:@"showExam"
                                  sender:e];
    } else {
        [self openResultsControllerWith:e];
    }
    [_tableView deselectRowAtIndexPath:indexPath
                              animated:YES];
}

- (void)openResultsControllerWith:(Exam *)exam {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ExamCompletedViewController *examCompletedViewController = [storyboard instantiateViewControllerWithIdentifier:@"examCompletedViewController"];
    examCompletedViewController.examTitle = exam.name;
    examCompletedViewController.progress = [Progress getProgressIfExistWithExamId:exam.idExam
                                                       inManagedObjectContext:managedObjectContext];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:examCompletedViewController];
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navController animated:YES completion:^{
        
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showExam"]) {
        Exam *e = (Exam *)sender;
        QuestionsViewController *questionController = (QuestionsViewController *)[segue destinationViewController];
        questionController.exam = e;
        questionController.progress = [Progress getProgressIfExistWithExamId:e.idExam
                                                      inManagedObjectContext:managedObjectContext];
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
    NSEntityDescription *mEntity = [NSEntityDescription entityForName:NSStringFromClass([Exam class])
                                               inManagedObjectContext:managedObjectContext];
    [mfetchRequest setEntity:mEntity];
    [mfetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *msort = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                          ascending:YES];
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
