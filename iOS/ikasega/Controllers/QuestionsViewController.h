//
//  QustionsViewController.h
//  ikasega
//
//  Created by Sergio Garcia on 23/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Exam.h"
#import "Progress.h"

@interface QuestionsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *lblPlayerTitle;
@property (weak, nonatomic) IBOutlet UIButton *playerButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *playerBottomSeparator;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Exam *exam;
@property (strong, nonatomic) Progress *progress;
@end
