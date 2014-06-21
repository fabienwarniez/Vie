//
// Created by Fabien Warniez on 2014-04-09.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@interface FWBoardSizeModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) NSUInteger numberOfRows;

- (instancetype)initWithName:(NSString *)name numberOfColumns:(NSUInteger)numberOfColumns numberOfRows:(NSUInteger)numberOfRows;
+ (instancetype)boardSizeWithName:(NSString *)name numberOfColumns:(NSUInteger)numberOfColumns numberOfRows:(NSUInteger)numberOfRows;

- (BOOL)isEqualToBoardSize:(FWBoardSizeModel *)other;
- (BOOL)isGreaterOrEqualToBoardSize:(FWBoardSizeModel *)other;
- (BOOL)isSmallerOrEqualToBoardSize:(FWBoardSizeModel *)other;

+ (NSArray *)boardSizes;
+ (instancetype)defaultBoardSize;

@end