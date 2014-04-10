//
// Created by Fabien Warniez on 2014-03-26.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWGameBoardView;
@class FWBoardSize;

@interface FWGameViewController : UIViewController

@property (nonatomic, strong) IBOutlet FWGameBoardView *gameBoardView;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) FWBoardSize *boardSize;
@property (nonatomic, assign, readonly) BOOL isRunning;

- (void)play;
- (void)pause;

@end