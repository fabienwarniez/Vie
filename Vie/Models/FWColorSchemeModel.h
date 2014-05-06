//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@interface FWColorSchemeModel : NSObject

@property (nonatomic, strong) NSString *guid;
@property (nonatomic, strong) UIColor *youngFillColor;
@property (nonatomic, strong) UIColor *mediumFillColor;
@property (nonatomic, strong) UIColor *oldFillColor;

- (instancetype)initWithGuid:(NSString *)guid
              youngFillColor:(UIColor *)youngFillColor
             mediumFillColor:(UIColor *)mediumFillColor
                oldFillColor:(UIColor *)oldFillColor;

+ (instancetype)colorSchemeWithGuid:(NSString *)guid
                     youngFillColor:(UIColor *)youngFillColor
                    mediumFillColor:(UIColor *)mediumFillColor
                       oldFillColor:(UIColor *)oldFillColor;

- (BOOL)isEqualToColorScheme:(FWColorSchemeModel *)other;

+ (FWColorSchemeModel *)colorSchemeFromGuid:(NSString *)guid inArray:(NSArray *)array;

+ (NSArray *)colors;

@end