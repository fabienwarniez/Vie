//
// Created by Fabien Warniez on 2014-03-26.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWBoardView;
@class FWBoardSizeModel;

@interface FWGameViewController : UIViewController

@property (nonatomic, strong) IBOutlet FWBoardView *gameBoardView;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *generateNewBoardButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *restartButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *pauseButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *playButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *backButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *nextButtonItem;

@property (nonatomic, strong) FWBoardSizeModel *boardSize;
@property (nonatomic, assign, readonly) BOOL isRunning;

// Cell Style
@property (nonatomic, assign) CGFloat cellBorderWidth;
@property (nonatomic, strong) UIColor *cellBorderColor;
@property (nonatomic, strong) UIColor *cellFillColor;

- (void)interruptGame;
- (void)resumeAfterInterruption;
- (void)setForceResumeAfterInterruption:(BOOL)force;

- (void)play;
- (void)pause;

- (IBAction)generateNewBoardButtonTapped:(id)sender;
- (IBAction)restartButtonTapped:(id)sender;
- (IBAction)pauseButtonTapped:(id)sender;
- (IBAction)playButtonTapped:(id)sender;
- (IBAction)backButtonTapped:(id)sender;
- (IBAction)nextButtonTapped:(id)sender;

@end