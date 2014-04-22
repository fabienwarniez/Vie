//
//  FWAppDelegate.m
//  Vie
//
//  Created by Fabien Warniez on 2014-03-25.
//  Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWAppDelegate.h"
#import "FWMainViewController.h"
#import "FWGameBoardSizeModel.h"
#import "FWSettingsManager.h"
#import "FWColorSchemeModel.h"
#import "FWUserModel.h"

@interface FWAppDelegate ()

@property (nonatomic, strong) FWMainViewController *mainViewController;

@end

@implementation FWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    self.userModel = [self loadUserModel];
    self.mainViewController = [[FWMainViewController alloc] initWithBoardSize:self.userModel.gameBoardSize];

    self.window.rootViewController = self.mainViewController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (FWUserModel *)loadUserModel
{
    FWUserModel *newUserModel = [[FWUserModel alloc] init];

    newUserModel.colorScheme = [FWSettingsManager getUserColorScheme];
    newUserModel.gameBoardSize = [FWSettingsManager getUserBoardSize];

    return newUserModel;
}

@end
