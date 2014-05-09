//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWColorSchemeModel;

@protocol FWColorSchemePickerTableViewControllerDelegate <NSObject>

- (void)colorSchemeDidChange:(FWColorSchemeModel *)newColorScheme;

@end

@interface FWColorSchemePickerTableViewController : UIViewController

@property (nonatomic, weak) id <FWColorSchemePickerTableViewControllerDelegate> delegate;

@end