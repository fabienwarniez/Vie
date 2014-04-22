//
//  FWAppDelegate.h
//  Vie
//
//  Created by Fabien Warniez on 2014-03-25.
//  Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWGameViewController;
@class FWUserModel;

@interface FWAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) FWUserModel *userModel;

@end
