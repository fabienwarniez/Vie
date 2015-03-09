//
// Created by Fabien Warniez on 2015-04-08.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWSaveGameViewController.h"

@implementation FWSaveGameViewController

#pragma mark - FWTitleBarDelegate

- (NSString *)titleFor:(FWTitleBar *)titleBar
{
    return @"Save";
}

- (void)buttonTappedFor:(FWTitleBar *)titleBar
{
    [self.delegate saveGameViewControllerDidCancel:self];
}

@end
