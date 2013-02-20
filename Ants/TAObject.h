//
//  TAObject.h
//  TinyAnts
//
//  Created by Jon Como on 12/11/12.
//  Copyright (c) 2012 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAObject : NSObject

@property CGPoint position;
@property float rotation;
@property float durability;
@property BOOL markForDeath;
@property BOOL selected;

-(id)initWithPosition:(CGPoint)initialPosition;
-(void)draw;
-(void)update;

-(void)hitObject:(TAObject *)object atAngle:(float)angle;

@end
