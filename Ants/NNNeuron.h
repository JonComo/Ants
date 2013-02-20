//
//  NNNeuron.h
//  MyNeuralNetwork
//
//  Created by Jon Como on 11/25/12.
//  Copyright (c) 2012 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NNNeuron;

@protocol NNNeuronDelegate <NSObject>

@optional
-(void)neuronDidFire:(NNNeuron *)neuron;

@end

@interface NNNeuron : NSObject

@property (nonatomic, strong) NSMutableArray *childrenNeurons;

@property (weak, nonatomic) id<NNNeuronDelegate> delegate;

@property float actionPotential;
@property float chargeAmplitude;
@property float connectionStrength;

@property CGPoint somaLocation;
@property CGPoint axonEndLocation;

-(id)init;

-(void)relateToAxonDendriteChild:(NNNeuron *)childNeuron;

-(void)receiveChargeOfAmplitude:(float)chargeAmplitude;

-(void)updateState;

-(void)learnWaveWithBeneficialCoefficient:(float)beneficialCoefficient;

@end
