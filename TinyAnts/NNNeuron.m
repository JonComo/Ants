//
//  NNNeuron.m
//  MyNeuralNetwork
//
//  Created by Jon Como on 11/25/12.
//  Copyright (c) 2012 Jon Como. All rights reserved.
//

#import "NNNeuron.h"

#import "JCMath.h"

#define CONNECTION_STRENGTH_MAX 1.01
#define CONNECTION_STRENGTH_MIN 0.8

@interface NNNeuron ()
{
    BOOL discharging;
    float activity;
    //CGPoint velocity;
}

@end

@implementation NNNeuron

-(id)init
{
    self = [super init];
    if (self) {
        //init
        _childrenNeurons = [[NSMutableArray alloc] init];
        activity = 0;
    }
    return self;
}

-(void)relateToAxonDendriteChild:(NNNeuron *)childNeuron
{
    if (!childNeuron) return;
    if (![_childrenNeurons containsObject:childNeuron]) {
        [_childrenNeurons addObject:childNeuron];
    }
}

-(void)receiveChargeOfAmplitude:(float)charge
{
    _chargeAmplitude += charge;
    activity += charge;
    
    if (_chargeAmplitude > _actionPotential && !discharging) {
        discharging = YES;
        NSTimer *chargeTimer;
        chargeTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(chargeChildren) userInfo:nil repeats:NO];
    }
}

-(void)updateState
{
    
    /* MOVE NEURON
    _somaLocation.x += velocity.x;
    _somaLocation.y += velocity.y;
    
    _axonEndLocation.x += velocity.x;
    _axonEndLocation.y += velocity.y;
    
    velocity = CGPointMake(velocity.x*=0.8, velocity.y*=0.8);
     */
}

-(void)learnWaveWithBeneficialCoefficient:(float)beneficialCoefficient
{
    //Every 3 seconds a wave passes all neurons and connections are strengthened or weakend based on the beneficial index and the amount of activity that the cell underwent the past 3 seconds
    
    _connectionStrength += beneficialCoefficient * activity/100;
    
    if (_connectionStrength > CONNECTION_STRENGTH_MAX) _connectionStrength = CONNECTION_STRENGTH_MAX;
    if (_connectionStrength < CONNECTION_STRENGTH_MIN) _connectionStrength = CONNECTION_STRENGTH_MIN;
    
    activity = 0; //reset cell activity
}

-(void)chargeChildren
{
    u_int numberOfChildren = _childrenNeurons.count;
    
    if (numberOfChildren == 0) {
        _chargeAmplitude = 0;
        return;
    }
    
    for (NNNeuron *childNeuron in _childrenNeurons)
    {
        [childNeuron receiveChargeOfAmplitude:(_chargeAmplitude*_connectionStrength)/numberOfChildren];
        
        /* MOVE NEURON
        float pushAmount = ([JCMath distanceBetweenPoint:_somaLocation andPoint:childNeuron.somaLocation sorting:NO] - 60)/60;
        CGPoint pushPoint = [JCMath pointFromPoint:CGPointZero pushedBy:pushAmount inDirection:[JCMath angleFromPoint:_somaLocation toPoint:childNeuron.somaLocation]];
        velocity = CGPointMake(velocity.x + pushPoint.x, velocity.y + pushPoint.y);
         */
    }
    
    discharging = NO;
    _chargeAmplitude = 0;
}

@end
