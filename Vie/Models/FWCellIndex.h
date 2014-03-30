//
// Created by Fabien Warniez on 2014-03-30.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@interface FWCellIndex : NSObject <NSCopying>

@property (nonatomic, assign) NSUInteger column;
@property (nonatomic, assign) NSUInteger row;

- (instancetype)initWithColumn:(NSUInteger)column row:(NSUInteger)row;

@end
