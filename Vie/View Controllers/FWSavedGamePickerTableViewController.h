//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWSavedGame;

@protocol FWSavedGamePickerTableViewControllerDelegate <NSObject>

- (void)loadSavedGame:(FWSavedGame *)savedGame;

@end

@interface FWSavedGamePickerTableViewController : UIViewController

@property (nonatomic, weak) id <FWSavedGamePickerTableViewControllerDelegate> delegate;

@end