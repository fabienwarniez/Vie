//
// Created by Fabien Warniez on 2014-03-29.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWNavigationController.h"

@implementation FWNavigationController

- (void)loadView
{
    [super loadView];
    self.view.layer.borderWidth = 1;
    self.view.layer.borderColor = [UIColor blueColor].CGColor;
}

@end