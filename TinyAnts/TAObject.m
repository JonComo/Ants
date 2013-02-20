//
//  TAObject.m
//  TinyAnts
//
//  Created by Jon Como on 12/11/12.
//  Copyright (c) 2012 Jon Como. All rights reserved.
//

#import "TAObject.h"

@implementation TAObject

-(id)initWithPosition:(CGPoint)initialPosition
{
    if (self = [super init]) {
        //init
        _position = initialPosition;
    }
    
    return self;
}

-(void)draw
{
    //draw with the current context
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextStrokeEllipseInRect(contextRef, CGRectMake(_position.x, _position.y, 20, 20));
}

@end
