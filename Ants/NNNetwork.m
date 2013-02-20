//
//  NNNetwork.m
//  MyNeuralNetwork
//
//  Created by Jon Como on 11/25/12.
//  Copyright (c) 2012 Jon Como. All rights reserved.
//

#import "NNNetwork.h"
#import "NNNeuron.h"

#import "JCMath.h"

#define SPREADNESS (arc4random()%15 != 1) ? arc4random()%10 + 10 : arc4random()%30 + 30

@interface NNNetwork ()
{
    NSMutableArray *neurons;
    UIImage *networkImage;
    CGSize networkSize;
    u_int numChildren;
}

@end

@implementation NNNetwork

-(id)initWithDelegate:(id)networkDelegate
{
    self = [super init];
    if (self) {
        //init
        _delegate = networkDelegate;
		_beneficialCoefficient = 1;
    }
	
    return self;
}

-(void)generateNetworkWithNeuronCount:(int)numberOfNeurons size:(CGSize)size
{
	if (neurons) {
		[neurons removeAllObjects];
	}else{
		neurons = [[NSMutableArray alloc] initWithCapacity:numberOfNeurons];
	}
	
    networkSize = size;
    
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		
		//Loop through and create that many neurons
		for (u_int i = 0; i<numberOfNeurons; i++) {
			//create neurons
			NNNeuron *neuron = [[NNNeuron alloc] init];
			
			neuron.somaLocation = [JCMath pointFromPoint:CGPointZero pushedBy:arc4random()%(int)(size.width/2) inDirection:arc4random()%360];
			float pushAmount = SPREADNESS;
			neuron.axonEndLocation = [JCMath pointFromPoint:neuron.somaLocation pushedBy:pushAmount inDirection:arc4random()%360];
			
			neuron.actionPotential = 0.9 + [JCMath randomFloat] * 0.2;
			neuron.chargeAmplitude = 0.4;
			neuron.connectionStrength = 0.94;
			
			[neurons addObject:neuron];
		}
		
		//Next add parents and children based on distance
		numChildren = MIN(3, numberOfNeurons-1);
		
		for (u_int i = 0; i<numChildren; i++)
		{
			for (NNNeuron *parentNeuron in neurons)
			{
				//Add the closest neuron as a child
				NNNeuron *childNeuron = [self neuronClosestToPoint:parentNeuron.axonEndLocation childOfNeuron:parentNeuron];
				[parentNeuron relateToAxonDendriteChild:childNeuron];
			}
		}
			
		dispatch_async(dispatch_get_main_queue(), ^{
			[_delegate networkGenerated:self withNeurons:neurons];
			/*
			NSTimer *learnTimer;
			learnTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(learnWave) userInfo:nil repeats:YES];
             */
		});
		
	});
}

-(void)learnWave
{
	for (NNNeuron *neuron in neurons)
    {
        [neuron learnWaveWithBeneficialCoefficient:self.beneficialCoefficient];
    }
}

-(void)render
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 1);
    
    for (NNNeuron *neuron in neurons)
    {
        float intensity = neuron.chargeAmplitude;
        CGContextSetRGBStrokeColor(contextRef, intensity/4, intensity/4, intensity, 1);
        
        float ellipseSize = neuron.chargeAmplitude * 8;
        CGContextStrokeEllipseInRect(contextRef, CGRectMake(neuron.somaLocation.x - ellipseSize/2, neuron.somaLocation.y - ellipseSize/2, ellipseSize, ellipseSize));
        
        //Axon line
        CGContextMoveToPoint(contextRef, neuron.somaLocation.x, neuron.somaLocation.y);
        CGContextAddLineToPoint(contextRef, neuron.axonEndLocation.x, neuron.axonEndLocation.y);
        
        CGContextStrokePath(contextRef);
        
        CGContextSetRGBStrokeColor(contextRef, intensity/4, intensity/4, intensity, intensity/6 + 0.1);
        
        //Axon dendrite lines
        for (NNNeuron *childNeuron in neuron.childrenNeurons)
        {
            CGContextMoveToPoint(contextRef, neuron.axonEndLocation.x, neuron.axonEndLocation.y);
            CGContextAddLineToPoint(contextRef, childNeuron.somaLocation.x, childNeuron.somaLocation.y);
        }
        
        CGContextStrokePath(contextRef);
    }
}

#pragma Brain readjustment

-(void)reorientNeurons
{
	//Loop through and create that many neurons
    for (NNNeuron *neuron in neurons) {
		[neuron.childrenNeurons removeAllObjects];
		
        neuron.somaLocation = [JCMath pointFromPoint:neuron.somaLocation pushedBy:(float)(arc4random()%20)-10.0 inDirection:90];
		float pushAmount = SPREADNESS;
        neuron.axonEndLocation = [JCMath pointFromPoint:neuron.somaLocation pushedBy:pushAmount inDirection:arc4random()%360];
    }
    
    //Next add parents and children based on distance
	for (NNNeuron *parentNeuron in neurons)
	{
		for (u_int i = 0; i<numChildren; i++)
		{
			//Add the closest neuron as a child
			NNNeuron *childNeuron = [self neuronClosestToPoint:parentNeuron.axonEndLocation childOfNeuron:parentNeuron];
			[parentNeuron relateToAxonDendriteChild:childNeuron];
		}
	}
}

-(void)setAllCharges:(float)chargeAmplitude
{
	for (NNNeuron *neuron in neurons)
	{
		neuron.chargeAmplitude = chargeAmplitude;
	}
}

#pragma Interaction

-(void)tapNetworkAtPoint:(CGPoint)point withCharge:(float)charge
{
    //Find neuron nearest the point
    NNNeuron *tappedNeuron = [self neuronClosestToPoint:point childOfNeuron:nil];
    [tappedNeuron receiveChargeOfAmplitude:charge];
}

#pragma helper methods

-(NNNeuron *)neuronClosestToPoint:(CGPoint)point childOfNeuron:(NNNeuron *)parentNeuron
{
    double distance = DBL_MAX;
    NNNeuron *closestNeuron;
    for (NNNeuron *neuron in neurons){
        double neuronDistance = [JCMath distanceBetweenPoint:neuron.somaLocation andPoint:point sorting:YES];
        
		if (neuronDistance < distance) {
			if (parentNeuron) {
				if (![neuron isEqual:parentNeuron] && ![parentNeuron.childrenNeurons containsObject:neuron]) {
					distance = neuronDistance;
					closestNeuron = neuron;
				}
			}else{
				distance = neuronDistance;
				closestNeuron = neuron;
			}
		}
    }
    
    return closestNeuron;
}

@end
