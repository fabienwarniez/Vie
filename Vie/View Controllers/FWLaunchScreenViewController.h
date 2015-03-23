//
// Created by Fabien Warniez on 2014-08-31.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWLaunchScreenViewController;

@protocol FWLaunchScreenViewControllerDelegate

- (void)quickGameButtonTappedForLaunchScreen:(FWLaunchScreenViewController *)launchScreenViewController;
- (void)patternsButtonTappedForLaunchScreen:(FWLaunchScreenViewController *)launchScreenViewController;
- (void)savedGamesButtonTappedForLaunchScreen:(FWLaunchScreenViewController *)launchScreenViewController;
- (void)aboutButtonTappedForLaunchScreen:(FWLaunchScreenViewController *)launchScreenViewController;

@end

@interface FWLaunchScreenViewController : UIViewController

@property (nonatomic, weak) id<FWLaunchScreenViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UIImageView *logoImageView;

@end