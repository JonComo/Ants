//
//  TAAnt.m
//  TinyAnts
//
//  Created by Jon Como on 12/11/12.
//  Copyright (c) 2012 Jon Como. All rights reserved.
//

#import "TAAnt.h"
#import "main.m"

@interface TAAnt ()
{
    TAColony *delegate;
    float velocity;
    float rotation;
}

@end

@implementation TAAnt

-(id)initWithPosition:(CGPoint)initialPosition delegate:(TAColony *)colonyDelegate
{
    if (self = [super initWithPosition:initialPosition]) {
        //Init
        delegate = colonyDelegate;
    }
    
    return self;
}

-(void)draw
{
    //draw with the current context
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextStrokeEllipseInRect(contextRef, CGRectMake(self.position.x, self.position.y, 20, 20));
}

@end
