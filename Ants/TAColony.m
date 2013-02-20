//
//  TAColony.m
//  TinyAnts
//
//  Created by Jon Como on 12/11/12.
//  Copyright (c) 2012 Jon Como. All rights reserved.
//

#import "TAColony.h"
#import "TAAnt.h"
#import "TAFood.h"
#import "JCMath.h"

@interface TAColony ()
{
    NSTimer *refreshTimer;
    NSMutableArray *objectsToDestroy;
    TAObject *selectedObject;
    BOOL touchMoved;
    CGPoint firstTouchPoint;
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
    
    _objects = [[NSMutableArray alloc] init];
    objectsToDestroy = [[NSMutableArray alloc] init];
    
//    for (u_int i = 0; i<6; i++) {
//        TAAnt *ant = [[TAAnt alloc] initWithPosition:CGPointMake(arc4random()%320, arc4random()%568) delegate:self];
//        [_objects addObject:ant];
//    }
    
//    NSTimer *foodtime;
//    foodtime = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(foods) userInfo:nil repeats:YES];
    
    refreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
}

-(void)foods
{
    TAFood *newFood = [[TAFood alloc] initWithPosition:CGPointMake(arc4random()%(int)self.frame.size.width, arc4random()%(int)self.frame.size.height)];
    [_objects addObject:newFood];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    touchMoved = NO;
    
    __block TAObject *newSelection;
    
    [self.objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TAObject *object = (TAObject *)obj;
        if ([JCMath distanceBetweenPoint:location andPoint:object.position sorting:NO] < 20) {
            //Touched an ant
            newSelection = object;
            firstTouchPoint = location;
            *stop = YES;
        }
    }];
    
    selectedObject = newSelection;
    
    if (!selectedObject) {
        TAAnt *ant = [[TAAnt alloc] initWithPosition:location delegate:self];
        [_objects addObject:ant];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    touchMoved = YES;
    
    if (selectedObject) {
        selectedObject.position = location;
        
        if (location.y < 40) {
            //Delete object
            [self.objects removeObject:selectedObject];
            selectedObject = nil;
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!touchMoved) {
        if (selectedObject.selected) {
            selectedObject.selected = NO;
        }else{
            selectedObject.selected = YES;
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [_objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TAObject *object = (TAObject *)obj;
        
        [_objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TAObject *otherObject = (TAObject *)obj;
            
            if (![object isEqual:otherObject]) {
                if ([JCMath distanceBetweenPoint:object.position andPoint:otherObject.position sorting:NO] < 20) {
                    //Too close, push away
                    float angle = [JCMath angleFromPoint:object.position toPoint:otherObject.position];
                    object.position = [JCMath pointFromPoint:object.position pushedBy:-1 inDirection:angle];
                    otherObject.position = [JCMath pointFromPoint:otherObject.position pushedBy:1 inDirection:angle];
                    
                    [object hitObject:otherObject atAngle:angle];
                    [otherObject hitObject:object atAngle:angle + 180];
                }
            }
        }];
        
        [object update];
        [object draw];
        
        if (object.position.x < 0) {
            object.position = CGPointMake(self.frame.size.width, object.position.y);
        }else if(object.position.x>self.frame.size.width)
        {
            object.position = CGPointMake(0, object.position.y);
        }
        
        if (object.position.y < 0) {
            object.position = CGPointMake(object.position.x, self.frame.size.height);
        }else if(object.position.y>self.frame.size.height)
        {
            object.position = CGPointMake(object.position.x, 0);
        }
        
    }];
    
    for (u_int i = 0; i<_objects.count; i++)
    {
        TAObject *object = (TAObject *)[_objects objectAtIndex:i];
        if (object.markForDeath) {
            [_objects removeObject:object];
        }
    }
}

@end
