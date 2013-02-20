//
//  TAAnt.h
//  TinyAnts
//
//  Created by Jon Como on 12/11/12.
//  Copyright (c) 2012 Jon Como. All rights reserved.
//

#import "TAObject.h"

typedef enum
{
    kClanBlack,
    kClanRed
} kClanType;

@class TAColony;

@interface TAAnt : TAObject

@property float rotationVelocity;
@property int physicalHealth;
@property kClanType clan;

-(id)initWithPosition:(CGPoint)initialPosition delegate:(TAColony *)colonyDelegate;
-(id)asexualReproduction;

@end