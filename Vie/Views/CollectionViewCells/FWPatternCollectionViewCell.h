//
// Created by Fabien Warniez on 2015-02-01.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

@class FWCellPatternModel;
@class FWColorSchemeModel;
@class FWPatternCollectionViewCell;

@protocol FWPatternCollectionViewCellDelegate <NSObject>

- (void)playButtonTappedFor:(FWPatternCollectionViewCell *)patternCollectionViewCell;
- (void)favouriteButtonTappedFor:(FWPatternCollectionViewCell *)patternCollectionViewCell;
- (void)unfavouriteButtonTappedFor:(FWPatternCollectionViewCell *)patternCollectionViewCell;

@end

@interface FWPatternCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<FWPatternCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) UIColor *mainColor;
@property (nonatomic, strong) FWCellPatternModel *cellPattern;
@property (nonatomic, strong) FWColorSchemeModel *colorScheme;
@property (nonatomic, assign) BOOL fitsOnCurrentBoard;

+ (CGFloat)titleBarHeight;

@end