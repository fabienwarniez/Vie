//
// Created by Fabien Warniez on 2014-05-07.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWBoardView;
@class FWCellPatternModel;
@class FWColorSchemeModel;

@interface FWCellPatternTableViewCell : UITableViewCell

@property (nonatomic, strong) FWCellPatternModel *cellPattern;
@property (nonatomic, strong) FWColorSchemeModel *colorScheme;

@end