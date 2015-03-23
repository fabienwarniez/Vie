//
// Created by Fabien Warniez on 2014-08-31.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@protocol FWLaunchScreenViewControllerDelegate

- (void)quickGameButtonTapped;
- (void)patternsButtonTapped;
- (void)savedGamesButtonTapped;

@end

@interface FWLaunchScreenViewController : UIViewController

@property (nonatomic, weak) id<FWLaunchScreenViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UIImageView *logoImageView;

@end