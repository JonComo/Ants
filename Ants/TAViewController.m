//
//  TAViewController.m
//  TinyAnts
//
//  Created by Jon Como on 12/11/12.
//  Copyright (c) 2012 Jon Como. All rights reserved.
//

#import "TAViewController.h"
#import "TAColony.h"

@interface TAViewController ()

@end

@implementation TAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(holdDown)];
    tap.numberOfTouchesRequired = 2;
    
    [self.view addGestureRecognizer:tap];
}

-(void)holdDown
{
    [colonyView.objects removeAllObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
