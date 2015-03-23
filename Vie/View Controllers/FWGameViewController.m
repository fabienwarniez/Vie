//
// Created by Fabien Warniez on 2014-03-26.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWGameViewController.h"
#import "FWCellModel.h"
#import "FWBoardView.h"
#import "FWBoardSizeModel.h"
#import "FWRandomNumberGenerator.h"
#import "FWSavedGameModel.h"
#import "FWColorSchemeModel.h"
#import "FWPatternModel.h"

static CGFloat const kFWGameViewControllerBoardPadding = 15.0f;

@interface FWGameViewController () <ADBannerViewDelegate>
{
    FWCellModel * __unsafe_unretained *_currentCellsArray;
    FWCellModel * __unsafe_unretained *_previousArrayOfCells;
}

@property (nonatomic, assign) BOOL cArraysAllocated;
@property (nonatomic, strong) NSArray *currentCellsNSArray;
@property (nonatomic, strong) NSArray *previousNSArrayOfCells;
@property (nonatomic, strong) NSArray *initialBoard;
@property (nonatomic, strong) NSTimer *refreshTimer;
@property (nonatomic, assign) BOOL wasPlayingBeforeInterruption;
@property (nonatomic, assign) BOOL isRewindingPossible;

@end

@implementation FWGameViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _cArraysAllocated = NO;
        _isRewindingPossible = NO;
    }

    return self;
}

#pragma mark - Accessors

- (void)setBoardSize:(FWBoardSizeModel *)boardSize
{
    if ([self isRunning])
    {
        [self pause];
    }

    _boardSize = boardSize;
    self.gameBoardView.boardSize = boardSize;

    [self reallocCArrays];
    [self setupNewGame];
}

- (BOOL)isRunning
{
    return self.refreshTimer != nil && [self.refreshTimer isValid];
}

- (void)setCellBorderWidth:(CGFloat)cellBorderWidth
{
    _cellBorderWidth = cellBorderWidth;
    self.gameBoardView.borderWidth = cellBorderWidth;
}

- (void)setCellFillColorScheme:(FWColorSchemeModel *)cellFillColorScheme
{
    _cellFillColorScheme = cellFillColorScheme;
    self.gameBoardView.fillColorScheme = cellFillColorScheme;
}

- (void)setIsRewindingPossible:(BOOL)isRewindingPossible
{
    _isRewindingPossible = isRewindingPossible;
    if (isRewindingPossible)
    {
        [self.gameToolbar enableBackButton];
    }
    else
    {
        [self.gameToolbar disableBackButton];
    }
}

#pragma mark - UIViewController

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self interruptGame];
    [self.gameBoardView setNeedsDisplay];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self resumeAfterInterruption];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.adBannerView.delegate = self;

    self.gameBoardView.minimumBoardPadding = kFWGameViewControllerBoardPadding;

    // Needed to update the play / pause buttons
    [self pause];

    [self setupNewGame];
}

- (void)dealloc
{
    free(_currentCellsArray);
    free(_previousArrayOfCells);
}

#pragma mark - FWTitleBarDelegate

- (NSString *)titleFor:(FWTitleBar *)titleBar
{
    return NSLocalizedString(@"game.quick-play", @"Quick Play");
}

- (void)buttonTappedFor:(FWTitleBar *)titleBar
{
    if ([self isRunning])
    {
        [self pause];
    }

    [self.delegate menuButtonTappedForGameViewController:self];
}

- (UIImage *)buttonImageFor:(FWTitleBar *)titleBar
{
    return [UIImage imageNamed:@"hamburger"];
}

#pragma mark - FWGameToolbarDelegate

- (void)rewindButtonTappedFor:(FWGameToolbar *)gameToolbar
{
    NSAssert(self.isRewindingPossible, @"Back button should be disabled if rewinding is not possible.");

    if ([self isRunning])
    {
        [self pause];
    }
    else
    {
        // swap NSArray's
        NSArray *nextCycleArray = self.previousNSArrayOfCells;
        self.previousNSArrayOfCells = self.currentCellsNSArray;
        self.currentCellsNSArray = nextCycleArray;

        // swap C arrays
        FWCellModel * __unsafe_unretained *currentCycleArray = _currentCellsArray;
        _currentCellsArray = _previousArrayOfCells;
        _previousArrayOfCells = currentCycleArray;

        self.isRewindingPossible = NO;

        NSArray *liveCells = [self liveCellsGroupedByAgeFromGameMatrix:self.currentCellsNSArray];
        self.gameBoardView.liveCells = liveCells;
    }
}

- (void)playButtonTappedFor:(FWGameToolbar *)gameToolbar
{
    if ([self isRunning])
    {
        [self pause];
    }
    else
    {
        [self play];
    }
}

- (void)fastForwardButtonTappedFor:(FWGameToolbar *)gameToolbar
{
    if ([self isRunning])
    {
        [self pause];
    }
    else
    {
        [self calculateNextCycle];
    }
}

#pragma mark - ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"Ad loaded");
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Ad could not load");
}

#pragma mark - Game Lifecycle Management

- (void)interruptGame
{
    self.wasPlayingBeforeInterruption = [self isRunning];
    if ([self isRunning])
    {
        [self pause];
    }
}

- (void)resumeAfterInterruption
{
    if (self.wasPlayingBeforeInterruption)
    {
        [self play];
    }
}

- (void)setForceResumeAfterInterruption:(BOOL)force
{
    self.wasPlayingBeforeInterruption = force;
}

- (void)play
{
    if (self.refreshTimer == nil || ![self.refreshTimer isValid])
    {
        self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f / self.gameSpeed
                                                         target:self
                                                       selector:@selector(calculateNextCycle:)
                                                       userInfo:nil
                                                        repeats:YES];
    }

    [self.gameToolbar showPauseButton];
}

- (void)pause
{
    if ([self.refreshTimer isValid])
    {
        [self.refreshTimer invalidate];
    }

    [self.gameToolbar showPlayButton];
}

- (void)newGame
{
    if ([self isRunning])
    {
        [self pause];
    }

    [self setupNewGame];
}

- (void)restart
{
    if ([self isRunning])
    {
        [self pause];
    }

    [self copyCellsStatusesFromArray:self.initialBoard toArray:self.currentCellsNSArray];
    [self fillCArray:_currentCellsArray withNSArray:self.currentCellsNSArray];

    self.gameBoardView.liveCells = [self liveCellsGroupedByAgeFromGameMatrix:self.currentCellsNSArray];

    self.isRewindingPossible = NO;
}

- (void)loadSavedGame:(FWSavedGameModel *)savedGame
{
    _boardSize = [FWBoardSizeModel boardSizeWithName:nil
                                     numberOfColumns:savedGame.boardSize.numberOfColumns
                                        numberOfRows:savedGame.boardSize.numberOfRows];

    [self reallocCArrays];

    self.currentCellsNSArray = [self generateInitialCellsWithColumns:savedGame.boardSize.numberOfColumns
                                                                rows:savedGame.boardSize.numberOfRows
                                               percentageOfLiveCells:0];

    NSUInteger numberOfLiveCells = [savedGame.liveCells count];
    NSUInteger numberOfRows = savedGame.boardSize.numberOfRows;
    for (NSUInteger i = 0; i < numberOfLiveCells; i++)
    {
        FWCellModel *liveCell = savedGame.liveCells[i];
        FWCellModel *cellToMakeAlive = self.currentCellsNSArray[liveCell.column * numberOfRows + liveCell.row];
        NSAssert(liveCell.column == cellToMakeAlive.column && liveCell.row == cellToMakeAlive.row, @"Cells attributes should match");
        cellToMakeAlive.alive = YES;
    }

    self.initialBoard = [[NSArray alloc] initWithArray:self.currentCellsNSArray copyItems:YES];
    self.previousNSArrayOfCells = [self generateInitialCellsWithColumns:self.boardSize.numberOfColumns rows:self.boardSize.numberOfRows percentageOfLiveCells:0];

    [self fillCArray:_currentCellsArray withNSArray:self.currentCellsNSArray];
    [self fillCArray:_previousArrayOfCells withNSArray:self.previousNSArrayOfCells];

    NSArray *liveCells = [self liveCellsGroupedByAgeFromGameMatrix:self.currentCellsNSArray];

    self.gameBoardView.boardSize = self.boardSize;
    self.gameBoardView.liveCells = liveCells;

    self.isRewindingPossible = NO;
}

- (void)setPattern:(FWPatternModel *)cellPattern
{
    NSAssert([self.boardSize isGreaterOrEqualToBoardSize:cellPattern.boardSize], @"The pattern loaded is too big for the board size");

    self.currentCellsNSArray = [self generateInitialCellsWithColumns:self.boardSize.numberOfColumns
                                                                rows:self.boardSize.numberOfRows
                                               percentageOfLiveCells:0];

    NSUInteger xOffset = (NSUInteger) lround((self.boardSize.numberOfColumns - cellPattern.boardSize.numberOfColumns) / 2.0f);
    NSUInteger yOffset = (NSUInteger) lround((self.boardSize.numberOfRows - cellPattern.boardSize.numberOfRows) / 2.0f);

    NSUInteger numberOfLiveCells = [cellPattern.liveCells count];
    NSUInteger numberOfRows = self.boardSize.numberOfRows;
    for (NSUInteger i = 0; i < numberOfLiveCells; i++)
    {
        FWCellModel *liveCell = cellPattern.liveCells[i];
        NSUInteger liveCellDestinationColumn = liveCell.column + xOffset;
        NSUInteger liveCellDestinationRow = liveCell.row + yOffset;
        FWCellModel *cellToMakeAlive = self.currentCellsNSArray[liveCellDestinationColumn * numberOfRows + liveCellDestinationRow];
        NSAssert(liveCellDestinationColumn == cellToMakeAlive.column && liveCellDestinationRow == cellToMakeAlive.row, @"Cells attributes should match");
        cellToMakeAlive.alive = YES;
    }

    self.initialBoard = [[NSArray alloc] initWithArray:self.currentCellsNSArray copyItems:YES];
    self.previousNSArrayOfCells = [self generateInitialCellsWithColumns:self.boardSize.numberOfColumns rows:self.boardSize.numberOfRows percentageOfLiveCells:0];

    [self fillCArray:_currentCellsArray withNSArray:self.currentCellsNSArray];
    [self fillCArray:_previousArrayOfCells withNSArray:self.previousNSArrayOfCells];

    NSArray *liveCells = [self liveCellsGroupedByAgeFromGameMatrix:self.currentCellsNSArray];

    self.gameBoardView.liveCells = liveCells;

    self.isRewindingPossible = NO;
}

- (NSArray *)initialBoardLiveCells
{
    return [self liveCellsFromGameMatrix:self.initialBoard];
}

- (NSArray *)generateInitialCellsWithColumns:(NSUInteger)numberOfColumns rows:(NSUInteger)numberOfRows percentageOfLiveCells:(NSUInteger)percentageOfLiveCells
{
    NSMutableArray *cells = [NSMutableArray array];

    for (NSUInteger columnIndex = 0; columnIndex < numberOfColumns; columnIndex++)
    {
        for (NSUInteger rowIndex = 0; rowIndex < numberOfRows; rowIndex++)
        {
            FWCellModel *newCell = [[FWCellModel alloc] init];

            newCell.column = columnIndex;
            newCell.row = rowIndex;

            newCell.alive = [FWRandomNumberGenerator randomBooleanWithPositivePercentageOf:percentageOfLiveCells];

            cells[columnIndex * numberOfRows + rowIndex] = newCell;
        }
    }

    return cells;
}

- (void)calculateNextCycle:(NSTimer *)senderTimer
{
    [self calculateNextCycle];
}

- (void)calculateNextCycle
{
    NSArray *nextCycleArray = self.previousNSArrayOfCells;
    FWCellModel * __unsafe_unretained *currentCycleArray = _currentCellsArray;
    NSMutableArray *liveCellsArray = [@[[NSMutableArray array], [NSMutableArray array], [NSMutableArray array]] mutableCopy];
    NSUInteger numberOfColumns = self.boardSize.numberOfColumns; // performance optimization
    NSUInteger numberOfRows = self.boardSize.numberOfRows;

    FWCellModel *neighbourCells[] = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil};

    for (NSUInteger rowIndex = 0; rowIndex < numberOfRows; rowIndex++)
    {
        for (NSUInteger columnIndex = 0; columnIndex < numberOfColumns; columnIndex++)
        {
            if (columnIndex == 0)
            {
                for (NSUInteger i = 0; i < 3; i++)
                {
                    neighbourCells[i] = nil;
                }

                for (NSInteger rowOffsetIndex = -1; rowOffsetIndex <= 1; rowOffsetIndex++)
                {
                    for (NSUInteger columnOffsetIndex = 0; columnOffsetIndex <= 1; columnOffsetIndex++)
                    {
                        NSInteger neighbourColumnIndex = columnOffsetIndex + columnIndex;
                        NSInteger neighbourRowIndex = rowOffsetIndex + rowIndex;

                        NSUInteger neighbourArrayIndex = (columnOffsetIndex + 1) * 3 + (rowOffsetIndex + 1);

                        if (neighbourRowIndex >= 0 && neighbourColumnIndex < numberOfColumns && neighbourRowIndex < numberOfRows)
                        {
                            FWCellModel * __unsafe_unretained neighbourCell = currentCycleArray[(NSUInteger) (neighbourColumnIndex * numberOfRows + neighbourRowIndex)];
                            neighbourCells[neighbourArrayIndex] = neighbourCell;
                        }
                        else
                        {
                            neighbourCells[neighbourArrayIndex] = nil;
                        }
                    }
                }
            }
            else
            {
                for (NSUInteger i = 0; i < 6; i++)
                {
                    FWCellModel * __unsafe_unretained cellToShift = neighbourCells[i + 3];
                    neighbourCells[i] = cellToShift;
                }
                for (NSInteger i = -1; i <= 1; i++)
                {
                    NSInteger neighbourColumnIndex = 1 + columnIndex;
                    if (neighbourColumnIndex >= numberOfColumns)
                    {
                        continue;
                    }
                    NSInteger neighbourRowIndex = i + rowIndex;
                    FWCellModel * __unsafe_unretained cellToAdd = nil;
                    if (neighbourRowIndex >= 0 && neighbourRowIndex < numberOfRows)
                    {
                        cellToAdd = currentCycleArray[(NSUInteger) (neighbourColumnIndex * numberOfRows + neighbourRowIndex)];
                    }
                    neighbourCells[i + 7] = cellToAdd;
                }
            }

            FWCellModel * __unsafe_unretained currentCell = neighbourCells[4];
            FWCellModel * __unsafe_unretained nextCycleCell = nextCycleArray[columnIndex * numberOfRows + rowIndex];

            NSUInteger numberOfNeighbours = 0;
            for (NSUInteger neighbourIndex = 0; neighbourIndex < 9; neighbourIndex++)
            {
                if (neighbourIndex != 4)
                {
                    FWCellModel * __unsafe_unretained neighbourCell = neighbourCells[neighbourIndex];
                    if (neighbourCell != nil && neighbourCell.alive)
                    {
                        numberOfNeighbours++;
                    }
                }
            }

            if (currentCell.alive)
            {
                if (numberOfNeighbours < 2 || numberOfNeighbours > 3)
                {
                    nextCycleCell.alive = NO;
                }
                else
                {
                    nextCycleCell.alive = YES;
                    nextCycleCell.age = currentCell.age + 1;
                }
            }
            else
            {
                if (numberOfNeighbours == 3)
                {
                    nextCycleCell.alive = YES;
                    nextCycleCell.age = 0;
                }
                else
                {
                    nextCycleCell.alive = NO;
                }
            }

            if (nextCycleCell.alive)
            {
                [liveCellsArray[[FWGameViewController ageGroupFromAge:nextCycleCell.age]] addObject:nextCycleCell];
            }
        }
    }

    _currentCellsArray = _previousArrayOfCells;
    _previousArrayOfCells = currentCycleArray;
    self.previousNSArrayOfCells = self.currentCellsNSArray;
    self.currentCellsNSArray = nextCycleArray;
    self.gameBoardView.liveCells = liveCellsArray;
    if (!self.isRewindingPossible)
    {
        self.isRewindingPossible = YES;
    }
}

#pragma mark - Private Methods

- (void)setupNewGame
{
    if ([self isRunning])
    {
        [self pause];
    }

    NSArray *cellsArray = [self generateInitialCellsWithColumns:self.boardSize.numberOfColumns rows:self.boardSize.numberOfRows percentageOfLiveCells:15];
    NSArray *initialBoard = [[NSArray alloc] initWithArray:cellsArray copyItems:YES];
    NSArray *secondArrayOfCells = [self generateInitialCellsWithColumns:self.boardSize.numberOfColumns rows:self.boardSize.numberOfRows percentageOfLiveCells:0];

    self.currentCellsNSArray = cellsArray;
    self.initialBoard = initialBoard;
    self.previousNSArrayOfCells = secondArrayOfCells;

    [self fillCArray:_currentCellsArray withNSArray:self.currentCellsNSArray];
    [self fillCArray:_previousArrayOfCells withNSArray:self.previousNSArrayOfCells];

    NSArray *liveCells = [self liveCellsGroupedByAgeFromGameMatrix:cellsArray];

    self.gameBoardView.boardSize = self.boardSize;
    self.gameBoardView.borderWidth = self.cellBorderWidth;
    self.gameBoardView.fillColorScheme = self.cellFillColorScheme;
    self.gameBoardView.liveCells = liveCells;

    self.isRewindingPossible = NO;
}

- (void)reallocCArrays
{
    NSUInteger numberOfCells = self.boardSize.numberOfColumns * self.boardSize.numberOfRows;

    if (_cArraysAllocated)
    {
        free(_currentCellsArray);
        free(_previousArrayOfCells);
    }
    else
    {
        _cArraysAllocated = YES;
    }

    _currentCellsArray = (FWCellModel * __unsafe_unretained *) malloc(sizeof(FWCellModel *) * numberOfCells);
    _previousArrayOfCells = (FWCellModel * __unsafe_unretained *) malloc(sizeof(FWCellModel *) * numberOfCells);
}

- (void)fillCArray:(FWCellModel * __unsafe_unretained *)destination withNSArray:(NSArray *)source
{
    NSUInteger numberOfItems = [source count];
    for (NSUInteger i = 0; i < numberOfItems; i++)
    {
        destination[i] = source[i];
    }
}

- (void)copyCellsStatusesFromArray:(NSArray *)source toArray:(NSArray *)destination
{
    NSUInteger numberOfItems = [source count];
    for (NSUInteger i = 0; i < numberOfItems; i++)
    {
        FWCellModel *sourceCell = source[i];
        FWCellModel *destinationCell = destination[i];

        NSAssert(sourceCell.column == destinationCell.column && sourceCell.row == destinationCell.row, @"Cells should represent same position on grid.");

        destinationCell.alive = sourceCell.alive;
        destinationCell.age = 0;
    }
}

- (NSArray *)liveCellsFromGameMatrix:(NSArray *)cells
{
    NSMutableArray *liveCellsArray = [NSMutableArray array];

    for (FWCellModel *cell in cells)
    {
        if (cell.alive)
        {
            [liveCellsArray addObject:cell];
        }
    }

    return [liveCellsArray copy];
}

- (NSArray *)liveCellsGroupedByAgeFromGameMatrix:(NSArray *)cells
{
    NSMutableArray *liveCellsArray = [@[[NSMutableArray array], [NSMutableArray array], [NSMutableArray array]] mutableCopy];

    for (FWCellModel *cell in cells)
    {
        if (cell.alive)
        {
            [liveCellsArray[[FWGameViewController ageGroupFromAge:cell.age]] addObject:cell];
        }
    }

    return [liveCellsArray copy];
}

+ (FWCellAgeGroup)ageGroupFromAge:(NSUInteger)age
{
    if (age > 10)
    {
        return FWCellAgeGroupOld;
    }
    else if (age > 3)
    {
        return FWCellAgeGroupMedium;
    }
    else
    {
        return FWCellAgeGroupYoung;
    }
}

@end