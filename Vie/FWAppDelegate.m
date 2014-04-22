//
//  FWAppDelegate.m
//  Vie
//
//  Created by Fabien Warniez on 2014-03-25.
//  Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWAppDelegate.h"
#import "FWMainViewController.h"
#import "FWBoardSize.h"
#import "FWSettingsManager.h"
#import "FWColorScheme.h"

@interface FWAppDelegate ()

@property (nonatomic, strong) FWMainViewController *mainViewController;

@end

@implementation FWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    FWBoardSize *initialBoardSize = [FWSettingsManager getUserBoardSize];
    FWColorScheme *initialColorScheme = [FWSettingsManager getUserColorScheme];
    self.mainViewController = [[FWMainViewController alloc] initWithBoardSize:initialBoardSize];

    self.window.rootViewController = self.mainViewController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
