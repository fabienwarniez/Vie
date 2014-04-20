//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWColorScheme;

@protocol FWColorSchemePickerTableViewControllerDelegate <NSObject>

- (void)colorSchemeDidChange:(FWColorScheme *)newColorScheme;

@end

@interface FWColorSchemePickerTableViewController : UIViewController

@property (nonatomic, weak) id <FWColorSchemePickerTableViewControllerDelegate> delegate;

@end