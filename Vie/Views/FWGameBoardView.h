//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWBoardSize;

@interface FWGameBoardView : UIView

@property (nonatomic, strong) FWBoardSize *boardSize;

- (void)updateCellsWithDiff:(NSArray *)diffArray newCellArray:(NSArray *)wholeCellsArray;

@end