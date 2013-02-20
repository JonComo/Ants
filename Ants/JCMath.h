//
//  JCMath.h
//  MyNeuralNetwork
//
//  Created by Jon Como on 11/26/12.
//  Copyright (c) 2012 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ARC4RANDOM_MAX 0x100000000

@interface JCMath : NSObject

#pragma Math functions

+(float)angleFromPoint:(CGPoint)point1 toPoint:(CGPoint)point2;
+(double)distanceBetweenPoint:(CGPoint)point1 andPoint:(CGPoint)point2 sorting:(BOOL)sorting;
+(CGPoint)pointFromPoint:(CGPoint)point pushedBy:(float)pushAmount inDirection:(float)degrees;
+(int)turnAngle:(float)angle towardsDesiredAngle:(float)desiredAngle;
+(float)differenceBetweenAngle:(float)angle1 andAngle:(float)angle2;
+(float)randomFloat;

@end