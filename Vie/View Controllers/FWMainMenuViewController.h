//
// Created by Fabien Warniez on 2014-08-31.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@protocol FWMainMenuViewControllerDelegate

- (void)quickGameButtonTapped;

@end

@interface FWMainMenuViewController : UIViewController

@property (nonatomic, weak) id<FWMainMenuViewControllerDelegate> delegate;

@end