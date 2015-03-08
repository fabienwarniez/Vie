//
// Created by Fabien Warniez on 2014-05-08.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FWGameViewController.h"

@class FWBoardSizeModel;

@interface FWPatternModel : NSManagedObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *format;
@property (nonatomic, strong) FWBoardSizeModel *boardSize;
@property (nonatomic, strong) NSString *encodedData;
@property (nonatomic, strong) NSArray *liveCells;
@property (nonatomic, assign) BOOL favourited;

@end