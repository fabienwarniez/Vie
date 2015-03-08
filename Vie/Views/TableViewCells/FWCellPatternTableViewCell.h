//
// Created by Fabien Warniez on 2014-05-07.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWBoardView;
@class FWPatternModel;
@class FWColorSchemeModel;

@interface FWCellPatternTableViewCell : UITableViewCell

@property (nonatomic, strong) FWPatternModel *cellPattern;
@property (nonatomic, strong) FWColorSchemeModel *colorScheme;
@property (nonatomic, assign) BOOL fitsOnCurrentBoard;

@end