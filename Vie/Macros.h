//
// Created by Fabien Warniez on 2015-03-22.
// Copyright (c) 2015 Fabien Warniez. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#define FWRoundFloat(x) floorf([UIScreen mainScreen].scale * x) / [UIScreen mainScreen].scale
#define FWDegreesToRadians(x) x * M_PI / 180.0f

#endif
