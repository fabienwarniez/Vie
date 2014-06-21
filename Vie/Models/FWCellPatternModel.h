//
// Created by Fabien Warniez on 2014-05-08.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWGameViewController.h"

@class FWBoardSizeModel;

@interface FWCellPatternModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *format;
@property (nonatomic, strong) FWBoardSizeModel *boardSize;
@property (nonatomic, strong) NSString *encodedData;
@property (nonatomic, strong) NSArray *liveCells;
@property (nonatomic, assign) FWPatternPosition recommendedPosition;

@end