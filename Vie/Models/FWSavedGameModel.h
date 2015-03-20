//
//  Created by Fabien Warniez on 2014-08-30.
//  Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import <CoreData/CoreData.h>

@class FWBoardSizeModel;

@interface FWSavedGameModel : NSManagedObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) FWBoardSizeModel *boardSize;
@property (nonatomic, strong) NSArray *liveCells;
@property (nonatomic, strong) NSDate *creationDate;

@end
