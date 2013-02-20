//
//  TAFood.m
//  TinyAnts
//
//  Created by Jon Como on 12/11/12.
//  Copyright (c) 2012 Jon Como. All rights reserved.
//

#import "TAFood.h"

@implementation TAFood

-(id)initWithPosition:(CGPoint)initialPosition
{
    if (self = [super initWithPosition:initialPosition]) {
        //init
        _amount = arc4random()%10 + 10;
    }
    
    return self;
}

-(void)draw
{
    //draw with the current context
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(contextRef, 0, 1, 0, 1);
    CGContextFillEllipseInRect(contextRef, CGRectMake(self.position.x - _amount/2, self.position.y - _amount/2, _amount, _amount));
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 1);
}

-(void)update
{
    if (_amount<0) {
        self.markForDeath = YES;
    }
}

@end
