//
// Created by Fabien Warniez on 2015-03-22.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#import "FWTitleBar.h"

@class FWAboutViewController;

@protocol FWAboutViewControllerDelegate <NSObject>

- (void)aboutDidClose:(FWAboutViewController *)aboutViewController;

@end

@interface FWAboutViewController : UIViewController <FWTitleBarDelegate>

@property (nonatomic, weak) id<FWAboutViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end
