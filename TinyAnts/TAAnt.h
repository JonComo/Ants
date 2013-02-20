//
//  TAAnt.h
//  TinyAnts
//
//  Created by Jon Como on 12/11/12.
//  Copyright (c) 2012 Jon Como. All rights reserved.
//

#import "TAObject.h"

@class TAColony;

@interface TAAnt : TAObject

-(id)initWithPosition:(CGPoint)initialPosition delegate:(TAColony *)colonyDelegate;

@end
