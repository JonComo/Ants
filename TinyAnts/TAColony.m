//
//  TAColony.m
//  TinyAnts
//
//  Created by Jon Como on 12/11/12.
//  Copyright (c) 2012 Jon Como. All rights reserved.
//

#import "TAColony.h"
#import "TAAnt.h"

@interface TAColony ()
{
    NSMutableArray *objects;
    NSTimer *refreshTimer;
}

@end

@implementation TAColony

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self colonySetup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //Init code
        [self colonySetup];
    }
    return self;
}

-(void)colonySetup
{
    NSLog(@"I was setup!");
    
    objects = [[NSMutableArray alloc] init];
    
    for (u_int i = 0; i<20; i++) {
        TAAnt *ant = [[TAAnt alloc] initWithPosition:CGPointMake(arc4random()%320, arc4random()%568) delegate:self];
        [objects addObject:ant];
    }
    
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TAObject *object = (TAObject *)obj;
        [object draw];
    }];
}

@end
