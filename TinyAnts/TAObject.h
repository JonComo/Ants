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
@property float durability;

-(id)initWithPosition:(CGPoint)initialPosition;
-(void)draw;

@end
