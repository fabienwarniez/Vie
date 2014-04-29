//
// Created by Fabien Warniez on 2014-04-12.
// Copyright (c) 2014 Fabien Warniez. All rights reserved.
//

@interface FWColorSchemeModel : NSObject

@property (nonatomic, strong) NSString *guid;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) NSString *colorSchemeName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)colorSchemeWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithGuid:(NSString *)guid fillColor:(UIColor *)fillColor colorSchemeName:(NSString *)colorSchemeName;
+ (instancetype)colorSchemeWithGuid:(NSString *)guid fillColor:(UIColor *)fillColor colorSchemeName:(NSString *)colorSchemeName;

- (BOOL)isEqualToColorScheme:(FWColorSchemeModel *)other;

+ (NSArray *)colorSchemesFromFile;
+ (FWColorSchemeModel *)colorSchemeFromGuid:(NSString *)guid inArray:(NSArray *)array;

@end