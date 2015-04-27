//
// Created by Fabien Warniez on 2015-03-22.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWAboutViewController.h"

@implementation FWAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [self.webView loadRequest:request];
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

- (BOOL)webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType
{
    if (inType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    return YES;
}

@end
