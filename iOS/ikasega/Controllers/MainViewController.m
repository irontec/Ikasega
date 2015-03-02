//
//  ViewController.m
//  ikasega
//
//  Created by Sergio Garcia on 23/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "MainViewController.h"
#import "DataDownloader.h"
#import "UIColorIkasega.h"
#import "MainTableViewCell.h"

static NSString * const MainTablewVieCellIdentifier = @"mainTableViewCell";

@interface MainViewController () <UIAlertViewDelegate> {
    
    BOOL _dataChecked;
    DataDownloader *_dataDownloader;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(openInfoURL:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    [self.navigationItem setRightBarButtonItem:modalButton];
    
    _dataChecked = NO;
    
    _dataDownloader = [[DataDownloader alloc] init];
    [self setTitle:NSLocalizedString(@"appName", nil)];
    [self.view setBackgroundColor:[UIColor ikasegaBackground]];
    [self tableviewSetup];
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (void)openInfoURL:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://ikastek.net/aplikazioak/helduentzako/ikasega/"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
         [[UIApplication sharedApplication] openURL:url];
    }
   
}

- (void)viewDidAppear:(BOOL)animated {
    
    if (!_dataChecked) {
        [self checkData];
    }
}
#pragma mark - UITableview Setup

- (void)tableviewSetup {
    
    [_tableView setBounces:NO];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  [self heightForMainCellAtIndexPath:indexPath];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self mainCellAtIndexPath:indexPath];;
}

#pragma mark - Main Cell

- (CGFloat)heightForMainCellAtIndexPath:(NSIndexPath *)indexPath {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 300;
    } else {
        return 150;
    }
}

- (MainTableViewCell *)mainCellAtIndexPath:(NSIndexPath *)indexPath {
    
    MainTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:MainTablewVieCellIdentifier forIndexPath:indexPath];
    [self configureMainCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureMainCell:(MainTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    [cell.lblTitle setTextColor:[UIColor ikasegaGray3]];
    [cell.lblDescription setTextColor:[UIColor ikasegaGray2]];
    
    switch (indexPath.row) {
        case 0:
            [cell.lblTitle setText:NSLocalizedString(@"titleExams", nil)];
            [cell.lblDescription setText:NSLocalizedString(@"descExams", nil)];
            [cell.imgIcon setImage:[UIImage imageNamed:@"exams"]];
            break;
        case 1:
            [cell.lblTitle setText:NSLocalizedString(@"titleHistory", nil)];
            [cell.lblDescription setText:NSLocalizedString(@"descHistory", nil)];
            [cell.imgIcon setImage:[UIImage imageNamed:@"history"]];
            break;
            case 2:
            [cell.lblTitle setText:NSLocalizedString(@"titlePoints", nil)];
            [cell.lblDescription setText:NSLocalizedString(@"descPoints", nil)];
            [cell.imgIcon setImage:[UIImage imageNamed:@"points"]];
            break;
        default:
            break;
    }
}

#pragma mark - UITableVIewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"showExams" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"showHistory" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"showPoints" sender:self];
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Data Downloader

- (void)enableUI:(BOOL)enable {
    
    [self.view setUserInteractionEnabled:enable];
}

- (void)checkData {
    
    [_dataDownloader checkDataOnCompletion:^(BOOL success, BOOL dataAvalaible) {
        _dataChecked = success;
        if (success && dataAvalaible) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"appName", nil) message:NSLocalizedString(@"newExamsMessage", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No", nil)otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [alert show];
            });
        }
    }];
}

- (void)downloadNewData {
    
    [self enableUI:NO];
    [_dataDownloader updateData:^(NSError *error) {
        [self enableUI:YES];
        if (error) {
            NSLog(@"Error: %@ userInfo:%@", error, error.userInfo);
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [self downloadNewData];
    }
}

@end
