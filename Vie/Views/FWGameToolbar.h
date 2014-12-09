//
// Created by Fabien Warniez on 14-12-08.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWGameToolbar;

@protocol FWGameToolbarDelegate <NSObject>

- (void)rewindButtonTappedFor:(FWGameToolbar *)gameToolbar;
- (void)playButtonTappedFor:(FWGameToolbar *)gameToolbar;
- (void)fastForwardButtonTappedFor:(FWGameToolbar *)gameToolbar;

@end

@interface FWGameToolbar : UIView

@property (nonatomic, weak) IBOutlet id<FWGameToolbarDelegate> delegate;

@end