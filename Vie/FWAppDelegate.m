//
//  FWAppDelegate.m
//  Vie
//
//  Created by Fabien Warniez on 2014-03-25.
//  Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

#import "FWAppDelegate.h"
#import "FWMainViewController.h"
#import "FWDataManager.h"
#import "FWPatternManager.h"
#import "FWPatternLoader.h"
#import "FWPatternModel.h"

@interface FWAppDelegate ()

@property (nonatomic, strong) FWMainViewController *mainViewController;

@end

@implementation FWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Flurry startSession:@"NCWY32JF9G39SQ7PYVKH"];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [self loadPatternsIntoCoreDataIfNeeded];

    self.mainViewController = [[FWMainViewController alloc] init];
    self.window.rootViewController = self.mainViewController;
    
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)loadPatternsIntoCoreDataIfNeeded
{
    FWPatternManager *patternManager = [[FWDataManager sharedDataManager] patternManager];
    NSUInteger patternCount = [patternManager patternCount];

    if (patternCount == 0) {
        FWPatternLoader *patternLoader = [[FWPatternLoader alloc] init];
        NSArray *patterns = [patternLoader patternsInRange:NSMakeRange(0, [patternLoader patternCount])];
        for (FWPatternModel *patternModel in patterns) {
            [patternModel.managedObjectContext save:nil];
        }
    }
}

@end
