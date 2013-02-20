//
//  TAAnt.m
//  TinyAnts
//
//  Created by Jon Como on 12/11/12.
//  Copyright (c) 2012 Jon Como. All rights reserved.
//

#import "TAAnt.h"
#import "TAFood.h"
#import "TAColony.h"
#import "JCMath.h"
#import "NNNetwork.h"
#import "NNNeuron.h"

@interface TAAnt () <NNNetworkDelegate, NNNeuronDelegate>
{
    __weak TAColony *delegate;
    
    NNNetwork *brain;
    
    //Control neurons
    NSMutableArray *controlNeurons; //forward, right, backward, left
    NSMutableArray *inputNeurons; //Vision left, center, right
    
    //engine variables
    float velocity;
    float velocityIncrement;
    float jawOffset;
    float headRotation;
    float headRotationVelocity;
    CGPoint headPoint;
    CGPoint targetPoint;
    NSMutableArray *visibleObjects;
    
    //genes
    float speed;
    int hunger; //Above zero full below zero hungry
}

@end

@implementation TAAnt

-(id)initWithPosition:(CGPoint)initialPosition delegate:(TAColony *)colonyDelegate
{
    if (self = [super initWithPosition:initialPosition]) {
        //Init
        delegate = colonyDelegate;
        
        brain = [[NNNetwork alloc] initWithDelegate:self];
        [brain generateNetworkWithNeuronCount:10+arc4random()%20 size:CGSizeMake(100, 100)];
        brain.beneficialCoefficient = ((float)(arc4random()%10) - 5.0)/10.0;
        controlNeurons = [NSMutableArray array];
        inputNeurons = [NSMutableArray array];
        
        headRotationVelocity = 5;
        
        //genes
        speed = 0.1 + (float)(arc4random()%40)/40;
        hunger = 10;
        self.durability = 10;
        
        self.rotation = arc4random()%360 % 180;
    }
    
    return self;
}

-(id)asexualReproduction
{
    id child = [[[self class] alloc] initWithPosition:self.position delegate:delegate];
    
    return child;
}

#pragma NNNeuronDelegate

-(void)neuronDidFire:(NNNeuron *)neuron
{
    float amount = neuron.chargeAmplitude/2;
    
    switch ([controlNeurons indexOfObject:neuron]) {
        case 2:
            //Forward
            velocity += amount;
            break;
            
        case 1:
            //Right
            self.rotationVelocity += amount;
            break;
            
        case 0:
            //Backward
            velocity -= amount/2;
            break;
            
        case 3:
            //Left
            self.rotationVelocity -= amount;
            break;
            
        default:
            break;
    }
}

#pragma TAObject methods

-(void)hitObject:(TAObject *)object atAngle:(float)angle
{
    if (ABS([JCMath differenceBetweenAngle:self.rotation andAngle:angle]) < 60) {
        //Youre the one doing the attacking!
        jawOffset += 2;
        self.durability ++;
        object.durability --;
        if (object.durability < 0) {
            object.markForDeath = YES;
        }
    }
}

#pragma NNNetworkDelegate

-(void)networkGenerated:(NNNetwork *)network withNeurons:(NSArray *)neurons
{
    for (u_int i = 0; i<4; i++) {
        //Get random neurons and add them to the control array
        NNNeuron *randomNeuron = [self randomObjectFromArray:neurons];
        
        while ([controlNeurons containsObject:randomNeuron]) {
            randomNeuron = [self randomObjectFromArray:neurons];
        }
        
        [controlNeurons addObject:randomNeuron];
        randomNeuron.delegate = self;
    }
    
    for (u_int i = 0; i<6; i++) {
        //Input
        NNNeuron *inputNeuron = [self randomObjectFromArray:neurons];
        
        while ([inputNeurons containsObject:inputNeuron]) {
            inputNeuron = [self randomObjectFromArray:neurons];
        }
        
        [inputNeurons addObject:inputNeuron];
    }
}

-(void)displayNetwork:(NNNetwork *)network withNeurons:(NSArray *)neurons
{
    //Don't display
}

#pragma Utility

-(id)randomObjectFromArray:(NSArray *)array
{
    return array[arc4random()%array.count];
}

-(void)setDelegateOfNeuron:(NNNeuron *)neuron
{
    neuron.delegate = self;
}

-(void)impulseNeuronAtIndex:(NSUInteger)index withAmplitude:(float)amplitude
{
    if (inputNeurons.count == 0) return;
    
    NNNeuron *inputNeuron = [inputNeurons objectAtIndex:index];
    [inputNeuron receiveChargeOfAmplitude:amplitude];
}

-(void)draw
{
    //draw with the current context
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    if (_clan == kClanRed)
    {
        CGContextSetRGBFillColor(contextRef, 1.0, 0, 0, 1);
        CGContextSetRGBStrokeColor(contextRef, 1.0, 0, 0, 1);
    }else{
        CGContextSetRGBFillColor(contextRef, 0, 0, 0, 1);
        CGContextSetRGBStrokeColor(contextRef, 0, 0, 0, 1);
    }
    
    CGContextTranslateCTM(contextRef, self.position.x, self.position.y);
    CGContextRotateCTM(contextRef, self.rotation * M_PI/180);
    
    //Head
    CGPoint headDrawPoint = CGPointMake(10, 0);
    [self drawEllipseInRef:contextRef atPoint:CGPointMake(10, 0) radius:8];
    //Butt
    [self drawEllipseInRef:contextRef atPoint:CGPointMake(-10, 0) radius:9];
    //Body
    [self drawEllipseInRef:contextRef atPoint:CGPointMake(-3, 0) radius:6];
    [self drawEllipseInRef:contextRef atPoint:CGPointMake(3, 0) radius:6];
    
    //Legs
    float rotV = self.rotationVelocity;
    
    [self drawLegInRef:contextRef atPoint:CGPointMake(-5, 0) legLength:16 inDirection:-90 sinOffset:3.1 - rotV];
    [self drawLegInRef:contextRef atPoint:CGPointMake(0, 0) legLength:17 inDirection:-90 sinOffset:0 - rotV];
    [self drawLegInRef:contextRef atPoint:CGPointMake(5, 0) legLength:16 inDirection:-90 sinOffset:3.14 - rotV];
    
    [self drawLegInRef:contextRef atPoint:CGPointMake(-5, 0) legLength:16 inDirection:90 sinOffset:0 + rotV];
    [self drawLegInRef:contextRef atPoint:CGPointMake(0, 0) legLength:17 inDirection:90 sinOffset:3.0 + rotV];
    [self drawLegInRef:contextRef atPoint:CGPointMake(5, 0) legLength:16 inDirection:90 sinOffset:0 + rotV];
    
    //pinchers
    headRotation = rotV * 25;
    
    float jawTurn = sinf(jawOffset)*20;
    CGContextSetLineWidth(contextRef, 2);
    [self drawLineInRef:contextRef fromPoint:[JCMath pointFromPoint:headDrawPoint pushedBy:4 inDirection:-90 + headRotation] distance:10 direction:headRotation + jawTurn];
    [self drawLineInRef:contextRef fromPoint:[JCMath pointFromPoint:headDrawPoint pushedBy:4 inDirection:90 + headRotation] distance:10 direction:headRotation - jawTurn];
    
    CGContextStrokePath(contextRef);
    
    if (self.selected) {
        //render brain only in selected
        [brain render];
    }
    
    CGContextRotateCTM(contextRef, -self.rotation * M_PI/180);
    CGContextTranslateCTM(contextRef, -self.position.x, -self.position.y);
}

-(void)update
{
    NSMutableArray *objectsAhead = [NSMutableArray array];
    
    [delegate.objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        TAObject *object = (TAObject *)obj;
        
        float distance = [JCMath distanceBetweenPoint:self.position andPoint:object.position sorting:NO];
        
        if (![object isEqual:self] && distance < 200) {
            
            float angle = [JCMath differenceBetweenAngle:self.rotation andAngle:[JCMath angleFromPoint:self.position toPoint:object.position]];
            
            [objectsAhead addObject:object];
            
            float amplitude = (200 - distance)/20;
            
            amplitude = powf(amplitude, 2) / 100;
            
            angle = round(angle / 60);
            
            angle += 3;
            
            [self impulseNeuronAtIndex:angle - 1 withAmplitude:amplitude];
        }
        
    }];
    
    velocity *= 0.9;
    velocityIncrement += velocity/5 + ABS(self.rotationVelocity)/20;
    self.rotationVelocity *= 0.95;
    
    self.rotation += self.rotationVelocity;
    self.position = [JCMath pointFromPoint:self.position pushedBy:velocity inDirection:self.rotation];
    
    if (self.rotation > 180)
    {
        self.rotation = -180;
    }else if(self.rotation < -180)
    {
        self.rotation = 180;
    }
    
    //Appearance variables
    headPoint = [JCMath pointFromPoint:self.position pushedBy:10 inDirection:0];
    headRotation = [JCMath angleFromPoint:headPoint toPoint:targetPoint] - self.rotation;
}

-(void)turnTowardsTargetPoint:(CGPoint)point
{
    float angleToTarget = [JCMath angleFromPoint:self.position toPoint:point];
    self.rotationVelocity += ([JCMath turnAngle:self.rotation towardsDesiredAngle:angleToTarget] + 0.1) * velocity/2;
}

#pragma Drawing functions

-(void)drawLegInRef:(CGContextRef)contextRef atPoint:(CGPoint)startPoint legLength:(float)length inDirection:(float)direction sinOffset:(float)offset
{
    float sinOffset = sinf(velocityIncrement + offset);
    
    CGContextMoveToPoint(contextRef, startPoint.x, startPoint.y);
    CGPoint legOut = [JCMath pointFromPoint:startPoint pushedBy:length inDirection:direction + sinOffset*30];
    CGContextAddLineToPoint(contextRef, legOut.x, legOut.y);
}

-(void)drawLineInRef:(CGContextRef)contextRef fromPoint:(CGPoint)start distance:(float)distance direction:(float)direction
{
    CGContextMoveToPoint(contextRef, start.x, start.y);
    CGPoint end = [JCMath pointFromPoint:start pushedBy:distance inDirection:direction];
    CGContextAddLineToPoint(contextRef, end.x, end.y);
}

-(void)drawEllipseInRef:(CGContextRef)contextRef atPoint:(CGPoint)center radius:(float)radius
{
    CGContextFillEllipseInRect(contextRef, CGRectMake(center.x - radius/2, center.y - radius/2, radius, radius));
}

-(TAObject *)nearestObjectInObjects:(NSArray *)objects
{
    __block float maxDist = FLT_MAX;
    __block __weak TAObject *closestObject;
    
    [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj != self) {
            //Found object
            TAObject *object = (TAObject *)obj;
            
            if (ABS(object.position.x - headPoint.x) < 250 && ABS(object.position.y - headPoint.y) < 250) {
                float dist = [JCMath distanceBetweenPoint:object.position andPoint:headPoint sorting:NO];
                if (dist<maxDist) {
                    maxDist = dist;
                    closestObject = object;
                }
                
                if (dist<40 && object) {
                    *stop = YES;
                }
            }
        }
    }];
    
    return closestObject;
}

@end
