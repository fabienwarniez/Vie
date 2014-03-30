//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@interface FWGameBoardView : UIView

- (instancetype)initWithNumberOfColumns:(NSUInteger)numberOfColumns numberOfRows:(NSUInteger)numberOfRows cellSize:(CGSize)cellSize;

- (void)updateCellsWithDiff:(NSMutableArray *)diffArray newCellArray:(NSArray *)wholeCellsArray;
@end