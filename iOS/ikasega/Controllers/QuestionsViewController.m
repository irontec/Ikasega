//
//  QustionsViewController.m
//  ikasega
//
//  Created by Sergio Garcia on 23/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

#import "QuestionsViewController.h"
#import "QuestionTableViewCell.h"
#import "AnswerTableViewCell.h"
#import "Progress.h"
#import "Question.h"
#import "Answer.h"
#import "AppDelegate.h"
#import "ExamCompletedViewController.h"
#import "Ranking.h"
#import "RankingHelper.h"
#import "FileManagerHelper.h"
#import "DataDownloader.h"
#import "PlayerHelper.h"
#import "Math.h"
#import "Activity.h"
#import "UserDefaultsHelper.h"
#import "UIColorIkasega.h"
#import "UIFontIkasega.h"

static NSString * const QuestionCellIdentifier = @"questionTableViewCell";
static NSString * const AnswerCellIdentifier = @"answerTableViewCell";

static NSInteger const QuestionMinHeight = 90;
static NSInteger const AnswerMinHeight = 70;

@interface QuestionsViewController () {
    
    Question *question;
    BOOL answered;
    PlayerHelper *_playerHelper;
    NSTimer *_progressTimer;
    NSDate *_initDate;
    Activity *userActivity;
    UILabel *questionsCounterLabel;
    CGFloat playerDefaultHeight;
}

@end

@implementation QuestionsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    [self setTitle:_exam.name];
    [self.view setBackgroundColor:[UIColor ikasegaBackground]];
    playerDefaultHeight = _playerViewHeightConstraint.constant;
    
    userActivity = [UserDefaultsHelper getUserActivity];
    
    [self setupQuestionCounterUI];
    [self loadQuestion];
    
    [_lblPlayerTitle setTextColor:[UIColor ikasegaGray4]];
    [_lblPlayerTitle setText:NSLocalizedString(@"playerTitle", nil)];
    [_playerButton setBackgroundColor:[UIColor ikasegaOrange4]];
    [_playerButton setTitle:nil forState:UIControlStateNormal];
    
    [_progressView setProgressTintColor:[UIColor ikasegaOrange4]];
    [_progressView setTrackTintColor:[UIColor ikasegaGray2]];
    [_playerBottomSeparator setBackgroundColor:[UIColor ikasegaGray1]];
    [self enablePlayerUI:NO];
    _playerHelper = [PlayerHelper sharedPlayer];
    [self addPlayerIfNeeded];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
}


- (void)viewDidAppear:(BOOL)animated {
    
    _initDate = [NSDate date];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self saveElapsedTime];
    [UserDefaultsHelper setUserActivity:userActivity];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [_playerHelper enableMainControls:NO];
        [self pausePlayer];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:PlayerHelperDidChangeStateNotification
                                                      object:nil];
    }
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    
    [_playerHelper enableMainControls:NO];
    [self pausePlayer];
    question = nil;
    _exam = nil;
    _progress = nil;
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

- (void)setupQuestionCounterUI {
    
    questionsCounterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, self.navigationController.navigationBar.frame.size.height)];
    [questionsCounterLabel setFont:[UIFont ikasegaRegularWithSize:questionsCounterLabel.font.pointSize]];
    [questionsCounterLabel setText:@""];
    [questionsCounterLabel setTextColor:[UIColor whiteColor]];
    [questionsCounterLabel setTextAlignment:NSTextAlignmentRight];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:questionsCounterLabel];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)updateQuestionsCounter {
    
    // New value
    NSString *questionCounterValue = [NSString stringWithFormat:@"%d/%d", ([_progress.totalRightAnswers integerValue] + [_progress.totalWrongAnswers integerValue] + 1), [[_exam.questions allObjects] count]];
    // Animation
    CATransition *animation = [CATransition animation];
    animation.duration = 0.25;
    animation.type = kCATransitionFade;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [questionsCounterLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
    // Change the text
    [questionsCounterLabel setText:questionCounterValue];
}

- (void)saveElapsedTime {
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:_initDate];
    _initDate = [NSDate date];
    _progress.elapsedTime = [NSNumber numberWithInteger:[_progress.elapsedTime integerValue] + (int)timeInterval];
    [_progress.managedObjectContext save:nil];
}

#pragma mark - Player management

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    [self pausePlayer];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    
    NSLog(@"player:%@ error%@", player, error);
    // FIXME: Manage error -> ¿Disable player?
}

- (void)addPlayerIfNeeded {
    
    NSString *audioName = [FileManagerHelper getAudioNameFromExam:_exam];
    if (audioName) {
        //Exam has audio file to play
        NSString *audioFile = [FileManagerHelper getAudioPathFromExam:_exam];
        if (audioFile) {
            //File exits
            [self createPlayer:audioFile andDownloadIfError:YES];
        } else {
            //File NOT exist
            NSLog(@"No mp3 file exist...downloading it!");
            [self downloadMp3:^() {
                NSString *downloadedAudioFile = [FileManagerHelper getAudioPathFromExam:_exam];
                if (downloadedAudioFile) {
                     [self createPlayer:downloadedAudioFile andDownloadIfError:YES];
                }
            }];
        }
    }
}

- (void)downloadMp3:(void(^)(void))completion {
    
    NSString *audioName = [FileManagerHelper getAudioNameFromExam:_exam];
    DataDownloader *downloader = [[DataDownloader alloc] init];
    [downloader downloadMP3:audioName withCompletion:^(NSError *error) {
        if (!error) {
            NSLog(@"Okeyy");
            completion();
        } else {
            NSLog(@"Ooppss");
            // FIXME: Manage error -> ¿Disable player?
        }
    }];
}

- (void)createPlayer:(NSString *)audioFile andDownloadIfError:(BOOL)downloadIfError {
    
    NSURL *soundUrl = [NSURL fileURLWithPath:audioFile];
    NSError *error;
    
    _playerHelper.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl
                                                         error:&error];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PlayerHelperDidChangeStateNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePlayerUI)
                                                 name:PlayerHelperDidChangeStateNotification
                                               object:nil];
    
    if (!error) {
        NSLog(@"Player created..");
        [self setupPlayerUI];
    } else {
        NSLog(@"Error creating player. Error: %@", [error localizedDescription]);
        if (downloadIfError) {
            NSLog(@"New mp3 file downloading..");
            [self downloadMp3:^{
                [self createPlayer:audioFile andDownloadIfError:NO];
            }];
        }
    }
}

- (void)playerButtonAction:(id)sender {
    
    if ([_playerHelper.player isPlaying]) {
        [self pausePlayer];
    } else {
        [_playerHelper updateCurrentTrackInfoWithTitle:_exam.name
                                                author:NSLocalizedString(@"mediaPlayerArtist", nil)
                                                 album:NSLocalizedString(@"mediaPlayerAlbum", nil)];
        [self playPlayer];
    }
}

- (void)playPlayer {
    
    if (_playerHelper.player) {
        [_playerHelper.player play];
        [_playerHelper enableMainControls:YES];
        [self setPauseButton];
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(updateAudioProgress)
                                                        userInfo:nil
                                                         repeats:YES];
    }
}

- (void)pausePlayer {
    
    [_playerHelper.player pause];
    [_playerHelper enableMainControls:NO];
    [self setPlayButton];
    [_progressTimer invalidate];
}

#pragma mark - Player UI

- (void)setupPlayerUI {
    
    [_playerButton addTarget:self
                      action:@selector(playerButtonAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    _playerHelper.player.delegate = self;
    [_playerHelper.player prepareToPlay];
    [_progressView setProgress:0 animated:YES];
    [self enablePlayerUI:YES];
}

- (void)enablePlayerUI:(BOOL)enable {
    
    if (enable) {
        _playerViewHeightConstraint.constant = playerDefaultHeight;
    } else {
        _playerViewHeightConstraint.constant = 0;
    }
    [self updatePlayerUI];
}

- (void)updatePlayerUI {
    
    if ([_playerHelper.player isPlaying]) {
        [self setPauseButton];
    } else {
        [self setPlayButton];
    }
}

- (void)updateAudioProgress {
    
    if ([_playerHelper.player isPlaying]) {
        [_progressView setProgress:_playerHelper.player.currentTime/_playerHelper.player.duration animated:YES];
    }
}

- (void)setPlayButton {
    
    [_playerButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
}

- (void)setPauseButton {
    
    [_playerButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
}


#pragma mark - Exam management


- (void)loadQuestion {
    
    int total = [_progress.totalRightAnswers intValue] + [_progress.totalWrongAnswers intValue];//[_progress.totalAnweredQuestions intValue];
    if (total == 0) {
        //Set initial value
         //Reset elapsed time when set start date
        _progress.startDate = [NSDate date];
        _progress.elapsedTime = [NSNumber numberWithInteger:0];
    }
    if (total < [_exam.questions allObjects].count) {
        
        /* Aleatory order */
        /*
         NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
         NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([Question class])
         inManagedObjectContext:_exam.managedObjectContext];
         
         [fetch setEntity: entity];
         
         NSArray *ids = [[_progress.answeredQuestion allObjects] valueForKey:@"idQuestion"];
         NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"(exam.idExam == %@) AND (NOT (idQuestion IN %@))", _exam.idExam, ids];
         
         [fetch setPredicate:predicate];
         NSArray *posibleQuestions = [_exam.managedObjectContext executeFetchRequest:fetch
         error:nil];
         
         if (posibleQuestions && [posibleQuestions count] > 0) {
         int r = arc4random_uniform([posibleQuestions count]);
         question = [posibleQuestions objectAtIndex:r];
         }
         */
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"customOrder" ascending:YES];
        question = [[_exam.questions sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] objectAtIndex:total];
        [self updateQuestionsCounter];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
        answered = NO;
    } else {
        [self addExamResultsToRanking];
        [self openResultsController];
    }
}

- (void)openResultsController {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ExamCompletedViewController *examCompletedViewController = [storyboard instantiateViewControllerWithIdentifier:@"examCompletedViewController"];
    examCompletedViewController.examTitle = _exam.name;
    examCompletedViewController.progress = _progress;    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:examCompletedViewController];
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navController animated:YES completion:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

- (void)questionAnswerRigth:(BOOL)right {
    
    [_progress addAnsweredQuestionObject:question];
    if (right) {
        [self rightAnswerWithProgress:_progress];
    } else {
        [self wrongAnswerWithProgress:_progress];
    }
    
    [_progress.managedObjectContext save:nil];
    [self loadQuestion];
}

- (void)rightAnswerWithProgress:(Progress *)p {
    
    [userActivity addRightAnswer];
    int value = [p.totalRightAnswers intValue];
    p.totalRightAnswers = [NSNumber numberWithInt:value + 1];
}

- (void)wrongAnswerWithProgress:(Progress *)p {
    
    [userActivity addWrongAnswer];
    int value = [p.totalWrongAnswers intValue];
    p.totalWrongAnswers = [NSNumber numberWithInt:value + 1];
}

- (void)addExamResultsToRanking {
    
    //Set finish date when user answer last question
    _progress.finishDate = [NSDate date];
    [userActivity addExam];
    [self saveElapsedTime];
    Ranking *ranking = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Ranking class])
                                                     inManagedObjectContext:_exam.managedObjectContext];
    
    CGFloat percentage = [Math percentageWith:[_progress.totalRightAnswers floatValue] ofTotal:[_exam.questions allObjects].count];
    [ranking generateWithExam:_exam.name
     withPercentage:[NSNumber numberWithFloat:percentage]
                 rightAnswers:_progress.totalRightAnswers
                  wrongAnswers:_progress.totalWrongAnswers
                    startDate:_progress.startDate
                   finishDate:_progress.finishDate
                  elpasedTime:_progress.elapsedTime];
    [_exam.managedObjectContext save:nil];
}

#pragma mark - Question Cell

- (CGFloat)heightForQuestionCellAtIndexPath:(NSIndexPath *)indexPath {
    
    static QuestionTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [_tableView dequeueReusableCellWithIdentifier:QuestionCellIdentifier];
    });
    
    [self configureQuestionCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (QuestionTableViewCell *)questionCellAtIndexPath:(NSIndexPath *)indexPath {
    
    QuestionTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:QuestionCellIdentifier forIndexPath:indexPath];
    [self configureQuestionCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureQuestionCell:(QuestionTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    cell.clipsToBounds = YES;
    [cell.lblTitle setText:NSLocalizedString(@"Question", nil)];
    [cell.lblTitle setTextColor:[UIColor ikasegaBlue]];
    [cell.lblQuestion setTextColor:[UIColor ikasegaGray4]];
    [cell.bottomSeparator setBackgroundColor:[UIColor ikasegaGray1]];
    [cell.bottomSeparator setHidden:YES];
    NSString *ques = question.questionText;
    // Normal text
    [cell.lblQuestion setText:ques];
    // Atributted text
    /*
    [cell.lblQuestion setAttributedText:[self getAttibutedStringFrom:question.questionHtml
                                                      withFontFamily:cell.lblQuestion.font.familyName
                                                         andFontSize:cell.lblQuestion.font.pointSize]];
     */
}

#pragma mark - Answer Cell

- (CGFloat)heightForAnswerCellAtIndexPath:(NSIndexPath *)indexPath {
    
    static AnswerTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [_tableView dequeueReusableCellWithIdentifier:AnswerCellIdentifier];
    });
    
    [self configureAnswerCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (AnswerTableViewCell *)answerCellAtIndexPath:(NSIndexPath *)indexPath {
    
    AnswerTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:AnswerCellIdentifier forIndexPath:indexPath];
    [self configureAnswerCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureAnswerCell:(AnswerTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.clipsToBounds = YES;
    [cell.lblAnswer setTextColor:[UIColor ikasegaGray4]];
    [cell.bottomSeparator setBackgroundColor:[UIColor ikasegaGray1]];
    [cell.topSeparator setBackgroundColor:[UIColor ikasegaGray1]];
    [cell.containerView setBackgroundColor:[UIColor ikasegaHighlighted]];
    
    cell.containerView.layer.cornerRadius = 1;
    cell.containerView.clipsToBounds = YES;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Answer *answer = [[question.answers allObjects] objectAtIndex:indexPath.row - 1];
    NSString *answ = answer.answ;
    [cell.lblAnswer setText:answ];
}

#pragma mark - Cell Height

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));
    
    [sizingCell setNeedsLayout];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

#pragma mark -  UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1 + [question.answers allObjects].count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        CGFloat height = [self heightForQuestionCellAtIndexPath:indexPath];
        if (height < QuestionMinHeight) {
            height = QuestionMinHeight;
        }
        return height;
    } else {
        CGFloat height = [self heightForAnswerCellAtIndexPath:indexPath];
        if (height < AnswerMinHeight) {
            height = AnswerMinHeight;
        }
        return height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return [self questionCellAtIndexPath:indexPath];
    } else {
        return [self answerCellAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!answered && indexPath.row != 0) {
        answered = YES;
        Answer *answer = [[question.answers allObjects] objectAtIndex:indexPath.row - 1];
        UIColor *color;
        if ([answer.valid boolValue]) {
            color = [UIColor ikasegaGreen];
        } else {
            color = [UIColor ikasegaRed];
        }
        AnswerTableViewCell *cell = (AnswerTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        CGPoint lastPoint = [cell getLastTouchPoint];
        
        CGFloat touchViewSize = 10;
        CGRect frame = CGRectMake(0, 0, touchViewSize, touchViewSize);
        __block UIView *cView = [[UIView alloc] initWithFrame:frame];
        cView.center = lastPoint;
        cView.layer.cornerRadius = frame.size.width/2;
        cView.clipsToBounds = YES;
        [cView setBackgroundColor:color];
        [cView setAlpha:0.3];
        
        color = nil;
        [cell.containerView addSubview:cView];
        [cell.containerView sendSubviewToBack:cView];
        
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
                                CGFloat scaleFactor = (cell.frame.size.width > cell.frame.size.height ? cell.frame.size.width / touchViewSize : cell.frame.size.height / touchViewSize);
                                scaleFactor = scaleFactor * 2;
                                cView.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
                                cView.center = lastPoint;
                                [cView setAlpha:1.0];
                            } completion:^(BOOL finished) {
                                [cView removeFromSuperview];
                                cView = nil;
                                [self questionAnswerRigth:[answer.valid boolValue]];
                                [_tableView deselectRowAtIndexPath:indexPath
                                                          animated:NO];
                            }];
    }
}

#pragma mark - Helpers
/*
- (NSMutableAttributedString *)getAttibutedStringFrom:(NSString *)htmlString withFontFamily:(NSString *)fontName andFontSize:(CGFloat)fontSize {
    
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                      documentAttributes:nil error:nil];
    
    
    NSMutableAttributedString *res = [mString mutableCopy];
    mString = nil;
    [res beginEditing];
    [res enumerateAttribute:NSFontAttributeName
                    inRange:NSMakeRange(0, res.length)
                    options:0
                 usingBlock:^(id value, NSRange range, BOOL *stop) {
                     if (value) {
                         UIFont *oldFont = (UIFont *)value;
                         UIFontDescriptor *descriptor = [oldFont fontDescriptor];
                         BOOL bold = [self isBold:descriptor];
                         BOOL italic = [self isItalic:descriptor];
                         
                         UIFont *newFont = [oldFont fontWithSize:fontSize];
                         
                         NSString *mFontName = fontName;
                         
                         if (bold || italic) {
                             if (bold) {
                                 mFontName = [NSString stringWithFormat:@"%@-Bold", fontName];
                             } else {
                                 mFontName = [NSString stringWithFormat:@"%@-", mFontName];
                             }
                             if(italic) {
                                 mFontName = [NSString stringWithFormat:@"%@Italic", fontName];
                             }
                         } else {
                             mFontName = [NSString stringWithFormat:@"%@-Regular", fontName];
                         }
                         [res addAttribute:NSFontAttributeName value:newFont range:range];
                     }
                 }];
    [res endEditing];
    return res;
}

 - (BOOL)isBold:(UIFontDescriptor *)fontDescriptor
{
    return (fontDescriptor.symbolicTraits & UIFontDescriptorTraitBold) != 0;
}

- (BOOL)isItalic:(UIFontDescriptor *)fontDescriptor
{
    return (fontDescriptor.symbolicTraits & UIFontDescriptorTraitItalic) != 0;
}
*/
@end
