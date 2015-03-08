//
// Created by Fabien Warniez on 2015-03-03.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

@class FWPatternManager;

@interface FWDataManager : NSObject

+ (instancetype)sharedDataManager;
- (FWPatternManager *)patternManager;

@end
