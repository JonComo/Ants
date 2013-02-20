//
//  NNNeuron.m
//  MyNeuralNetwork
//
//  Created by Jon Como on 11/25/12.
//  Copyright (c) 2012 Jon Como. All rights reserved.
//

#import "NNNeuron.h"

#import "JCMath.h"

#define CONNECTION_STRENGTH_MAX 0.995
#define CONNECTION_STRENGTH_MIN 0.8

@interface NNNeuron ()
{
    BOOL discharging;
    float activity;
    float suppression;
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
        suppression = (arc4random()%20==0) ? -1 : 1;
    }
    
    return self;
}

-(void)relateToAxonDendriteChild:(NNNeuron *)childNeuron
{
    if (!childNeuron) return;
    if (![self.childrenNeurons containsObject:childNeuron]) {
        [self.childrenNeurons addObject:childNeuron];
    }
}

-(void)receiveChargeOfAmplitude:(float)charge
{
    self.chargeAmplitude += charge;
    activity += charge;
    
    if (self.chargeAmplitude < 0) {
        self.chargeAmplitude = 0;
    }
    
    if (self.chargeAmplitude > self.actionPotential && !discharging) {
        discharging = YES;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(neuronDidFire:)]) {
            [self.delegate neuronDidFire:self];
        }
        
        [self chargeChildren];
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
    
    self.connectionStrength += beneficialCoefficient * activity/100;
    
    if (self.connectionStrength > CONNECTION_STRENGTH_MAX) self.connectionStrength = CONNECTION_STRENGTH_MAX;
    if (self.connectionStrength < CONNECTION_STRENGTH_MIN) self.connectionStrength = CONNECTION_STRENGTH_MIN;
    
    activity = 0; //reset cell activity
}

-(void)chargeChildren
{
    u_int numberOfChildren = _childrenNeurons.count;
    
    for (NNNeuron *childNeuron in _childrenNeurons)
    {
        [childNeuron receiveChargeOfAmplitude:(_chargeAmplitude*_connectionStrength*suppression)/numberOfChildren];
        
        /* MOVE NEURON
        float pushAmount = ([JCMath distanceBetweenPoint:_somaLocation andPoint:childNeuron.somaLocation sorting:NO] - 60)/60;
        CGPoint pushPoint = [JCMath pointFromPoint:CGPointZero pushedBy:pushAmount inDirection:[JCMath angleFromPoint:_somaLocation toPoint:childNeuron.somaLocation]];
        velocity = CGPointMake(velocity.x + pushPoint.x, velocity.y + pushPoint.y);
         */
    }
    
    discharging = NO;
    self.chargeAmplitude = 0;
}

@end
