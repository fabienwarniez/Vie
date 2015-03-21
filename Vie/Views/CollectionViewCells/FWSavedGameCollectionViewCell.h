//
// Created by Fabien Warniez on 2015-03-14.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

@class FWPatternModel;
@class FWColorSchemeModel;
@class FWSavedGameCollectionViewCell;
@class FWSavedGameModel;

@protocol FWSavedGameCollectionViewCellDelegate <NSObject>

- (void)playButtonTappedForSavedGameCollectionViewCell:(FWSavedGameCollectionViewCell *)savedGameCollectionViewCell;
- (void)optionsButtonTappedForSavedGameCollectionViewCell:(FWSavedGameCollectionViewCell *)savedGameCollectionViewCell;
- (void)savedGameCollectionViewCellDidCancel:(FWSavedGameCollectionViewCell *)savedGameCollectionViewCell;

@end

@interface FWSavedGameCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<FWSavedGameCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) UIColor *mainColor;

- (void)setSavedGame:(FWSavedGameModel *)savedGame;

@end
