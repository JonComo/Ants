//
//  NNNetwork.h
//  MyNeuralNetwork
//
//  Created by Jon Como on 11/25/12.
//  Copyright (c) 2012 Jon Como. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NNNetwork;

@protocol NNNetworkDelegate <NSObject>

-(void)networkGenerated:(NNNetwork *)network withNeurons:(NSArray *)neurons;
-(void)displayNetwork:(NNNetwork *)network withNeurons:(NSArray *)neurons;

@end

@interface NNNetwork : NSObject

@property id delegate;

@property float beneficialCoefficient;

-(id)initWithDelegate:(id)networkDelegate;

-(void)generateNetworkWithNeuronCount:(int)numberOfNeurons size:(CGSize)size;

-(void)tapNetworkAtPoint:(CGPoint)point withCharge:(float)charge;

-(void)reorientNeurons;

-(void)setAllCharges:(float)chargeAmplitude;

@end