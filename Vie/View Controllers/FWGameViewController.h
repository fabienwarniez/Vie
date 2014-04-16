//
// Created by Fabien Warniez on 2014-03-26.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWGameBoardView;
@class FWBoardSize;

@interface FWGameViewController : UIViewController

@property (nonatomic, strong) IBOutlet FWGameBoardView *gameBoardView;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *reloadButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *pauseButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *playButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *backButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *nextButtonItem;
@property (nonatomic, strong) FWBoardSize *boardSize;
@property (nonatomic, assign, readonly) BOOL isRunning;

- (void)interruptGame;
- (void)resumeAfterInterruption;

- (void)play;
- (void)pause;

- (IBAction)reloadButtonTapped:(id)sender;
- (IBAction)pauseButtonTapped:(id)sender;
- (IBAction)playButtonTapped:(id)sender;
- (IBAction)backButtonTapped:(id)sender;
- (IBAction)nextButtonTapped:(id)sender;

@end