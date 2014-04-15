//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@interface FWColorScheme : NSObject

@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) NSString *colorSchemeName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)colorSchemeWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithFillColor:(UIColor *)fillColor borderColor:(UIColor *)borderColor colorSchemeName:(NSString *)colorSchemeName;
+ (instancetype)colorSchemeWithFillColor:(UIColor *)fillColor borderColor:(UIColor *)borderColor colorSchemeName:(NSString *)colorSchemeName;

@end