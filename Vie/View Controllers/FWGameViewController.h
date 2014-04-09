//
// Created by Fabien Warniez on 2014-03-26.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWGameBoardView;

@interface FWGameViewController : UIViewController

@property (nonatomic, assign, readonly) BOOL isRunning;

- (void)play;
- (void)pause;

@end