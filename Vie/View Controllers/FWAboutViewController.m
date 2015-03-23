//
// Created by Fabien Warniez on 2015-03-22.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWAboutViewController.h"

@implementation FWAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:NSLocalizedString(@"about.wikipedia-url", @"http://en.m.wikipedia.org/wiki/Conway%27s_Game_of_Life")]]];
}

- (NSString *)titleFor:(FWTitleBar *)titleBar
{
    return NSLocalizedString(@"about.about", @"About");
}

- (void)buttonTappedFor:(FWTitleBar *)titleBar
{
    [self.delegate aboutDidClose:self];
}

- (UIImage *)buttonImageFor:(FWTitleBar *)titleBar
{
    return [UIImage imageNamed:@"x"];
}

@end
