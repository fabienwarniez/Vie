//
// Created by Fabien Warniez on 14-12-07.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@class FWTitleBar;

@protocol FWTitleBarDelegate <NSObject>

- (NSString *)titleFor:(FWTitleBar *)titleBar;
- (void)buttonTappedFor:(FWTitleBar *)titleBar;

@end

@interface FWTitleBar : UIView

@property (nonatomic, weak) IBOutlet id<FWTitleBarDelegate> delegate;
@property (nonatomic, strong) NSString *title;

@end