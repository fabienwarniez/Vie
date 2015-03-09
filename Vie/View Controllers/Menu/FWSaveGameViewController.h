//
// Created by Fabien Warniez on 2015-04-08.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWTitleBar.h"

@class FWSaveGameViewController;

@protocol FWSaveGameViewControllerDelegate

- (void)saveGameViewControllerDidCancel:(FWSaveGameViewController *)saveGameViewController;
- (void)saveGameViewController:(FWSaveGameViewController *)saveGameViewController didSaveWithName:(NSString *)name;

@end

@interface FWSaveGameViewController : UIViewController <FWTitleBarDelegate>

@property (nonatomic, weak) id<FWSaveGameViewControllerDelegate> delegate;

@end
