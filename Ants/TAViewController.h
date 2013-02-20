//
//  TAViewController.h
//  TinyAnts
//
//  Created by Jon Como on 12/11/12.
//  Copyright (c) 2012 Jon Como. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TAColony;

@interface TAViewController : UIViewController
{
    __weak IBOutlet TAColony *colonyView;
}

@end
