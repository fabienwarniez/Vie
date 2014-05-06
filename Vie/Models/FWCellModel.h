//
// Created by Fabien Warniez on 2014-03-26.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@interface FWCellModel : NSObject <NSCopying>

@property (nonatomic, assign) BOOL alive;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, assign) NSUInteger column;
@property (nonatomic, assign) NSUInteger row;

- (instancetype)initWithAlive:(BOOL)alive column:(NSUInteger)column row:(NSUInteger)row;

+ (instancetype)cellWithAlive:(BOOL)alive column:(NSUInteger)column row:(NSUInteger)row;

@end