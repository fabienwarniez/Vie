//
//  FWAppDelegate.m
//  Vie
//
//  Created by Fabien Warniez on 2014-03-25.
//  Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWAppDelegate.h"
#import "FWMainViewController.h"
#import "UIColor+FWAppColors.h"

@interface FWAppDelegate ()

@property (nonatomic, strong) FWMainViewController *mainViewController;

@end

@implementation FWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    self.mainViewController = [[FWMainViewController alloc] init];
    self.window.rootViewController = self.mainViewController;
    
    [self.window makeKeyAndVisible];

    [self setGlobalAppearance];

    return YES;
}

- (void)setGlobalAppearance
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{
            NSForegroundColorAttributeName:[UIColor whiteColor],
            NSFontAttributeName:[UIFont fontWithName:@"Gotham-Book" size:20]
    }];
    [[UINavigationBar appearance] setBarTintColor:[UIColor mainAppColor]];
}

@end
