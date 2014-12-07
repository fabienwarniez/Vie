//
// Created by Fabien Warniez on 14-11-23.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWColorSchemeModel;
@class FWBoardSizeModel;
@class FWGameSettingsViewController;

@protocol FWGameSettingsViewControllerDelegate <NSObject>

- (void)gameSettings:(FWGameSettingsViewController *)gameSettingsViewController colorSchemeDidChange:(FWColorSchemeModel *)colorScheme;
- (void)gameSettings:(FWGameSettingsViewController *)gameSettingsViewController boardSizeDidChange:(FWBoardSizeModel *)boardSize;
- (void)gameSettingsDidClose:(FWGameSettingsViewController *)gameSettingsViewController;

@end

@interface FWGameSettingsViewController : UIViewController

@property (nonatomic, strong) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) id<FWGameSettingsViewControllerDelegate> delegate;

- (IBAction)closeButtonTapped:(id)sender;

@end