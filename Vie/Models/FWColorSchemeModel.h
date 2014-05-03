//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@interface FWColorSchemeModel : NSObject

@property (nonatomic, strong) NSString *guid;
@property (nonatomic, strong) UIColor *fillColor;

- (instancetype)initWithGuid:(NSString *)guid fillColor:(UIColor *)fillColor;

+ (instancetype)colorSchemeWithGuid:(NSString *)guid fillColor:(UIColor *)fillColor;

- (BOOL)isEqualToColorScheme:(FWColorSchemeModel *)other;

+ (FWColorSchemeModel *)colorSchemeFromGuid:(NSString *)guid inArray:(NSArray *)array;

+ (NSArray *)colors;

@end