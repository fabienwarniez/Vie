//
// Created by Fabien Warniez on 2014-09-01.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWQuickPlayMenuViewController;
@class FWColorSchemeModel;
@class FWBoardSizeModel;
@class FWGameSettingsViewController;

@protocol FWQuickPlayMenuControllerDelegate

- (void)quickPlayMenuDidClose:(FWQuickPlayMenuViewController *)quickPlayMenuViewController;
- (void)quickPlayMenuDidQuit:(FWQuickPlayMenuViewController *)quickPlayMenuViewController;
- (void)quickPlayMenu:(FWQuickPlayMenuViewController *)quickPlayMenuViewController
 colorSchemeDidChange:(FWColorSchemeModel *)colorScheme;
- (void)quickPlayMenu:(FWQuickPlayMenuViewController *)quickPlayMenuViewController
 boardSizeDidChange:(FWBoardSizeModel *)boardSize;
- (void)quickPlayMenu:(FWQuickPlayMenuViewController *)quickPlayMenuViewController
 gameSpeedDidChange:(NSUInteger)gameSpeed;

@end

@interface FWQuickPlayMenuViewController : UIViewController

@property (nonatomic, strong) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, weak) id<FWQuickPlayMenuControllerDelegate> delegate;

- (IBAction)closeButtonTapped:(id)sender;

@end