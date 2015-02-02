//
// Created by Fabien Warniez on 2015-02-01.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

@class FWCellPatternModel;
@class FWColorSchemeModel;

@interface FWPatternCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) FWCellPatternModel *cellPattern;
@property (nonatomic, strong) FWColorSchemeModel *colorScheme;
@property (nonatomic, assign) BOOL fitsOnCurrentBoard;

@end