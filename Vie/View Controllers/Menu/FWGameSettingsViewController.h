//
// Created by Fabien Warniez on 14-11-23.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWTitleBar.h"

@class FWColorSchemeModel;
@class FWBoardSizeModel;
@class FWGameSettingsViewController;
@class FWTitleBar;

@protocol FWGameSettingsViewControllerDelegate <NSObject>

- (void)gameSettings:(FWGameSettingsViewController *)gameSettingsViewController colorSchemeDidChange:(FWColorSchemeModel *)colorScheme;
- (void)gameSettings:(FWGameSettingsViewController *)gameSettingsViewController boardSizeDidChange:(FWBoardSizeModel *)boardSize;
- (void)gameSettings:(FWGameSettingsViewController *)gameSettingsViewController gameSpeedDidChange:(NSUInteger)gameSpeed;
- (void)gameSettingsDidClose:(FWGameSettingsViewController *)gameSettingsViewController;

@end

@interface FWGameSettingsViewController : UIViewController <FWTitleBarDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) id<FWGameSettingsViewControllerDelegate> delegate;

@end