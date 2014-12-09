//
// Created by Fabien Warniez on 2014-03-26.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWTitleBar.h"
#import "FWGameToolbar.h"

@class FWBoardView;
@class FWBoardSizeModel;
@class FWSavedGameModel;
@class FWColorSchemeModel;
@class FWCellPatternModel;
@class FWGameViewController;

typedef enum FWCellAgeGroup
{
    FWCellAgeGroupYoung = 0,
    FWCellAgeGroupMedium = 1,
    FWCellAgeGroupOld = 2
} FWCellAgeGroup;

typedef enum FWPatternPosition
{
    FWPatternPositionTop = 1 << 0,
    FWPatternPositionMiddle = 1 << 1,
    FWPatternPositionBottom = 1 << 2,
    FWPatternPositionLeft = 1 << 3,
    FWPatternPositionCenter = 1 << 4,
    FWPatternPositionRight = 1 << 5
} FWPatternPosition;

@protocol FWGameViewControllerDelegate

- (void)menuButtonTappedForGameViewController:(FWGameViewController *)gameViewController;

@end

@interface FWGameViewController : UIViewController <FWTitleBarDelegate, FWGameToolbarDelegate>

@property (nonatomic, strong) IBOutlet FWBoardView *gameBoardView;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet ADBannerView *adBannerView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *generateNewBoardButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *restartButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *pauseButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *playButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *backButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *nextButtonItem;

@property (nonatomic, weak) id<FWGameViewControllerDelegate> delegate;
@property (nonatomic, strong) FWBoardSizeModel *boardSize;
@property (nonatomic, assign) NSUInteger gameSpeed;
@property (nonatomic, assign, readonly) BOOL isRunning;

// Cell Style
@property (nonatomic, assign) CGFloat cellBorderWidth;
@property (nonatomic, strong) FWColorSchemeModel *cellFillColorScheme;

- (void)interruptGame;
- (void)resumeAfterInterruption;
- (void)setForceResumeAfterInterruption:(BOOL)force;

- (void)play;
- (void)pause;
- (void)loadSavedGame:(FWSavedGameModel *)savedGame;
- (void)setPattern:(FWCellPatternModel *)cellPattern;

- (NSArray *)initialBoardLiveCells;

- (IBAction)generateNewBoardButtonTapped:(id)sender;
- (IBAction)restartButtonTapped:(id)sender;

@end