//
//  NamecardsViewController.h
//  Business Card
//
//  A list showing all saved namecards. User can delete namecards or view namecard by clicking on the namecard cell. User can add new namecards by choosing the add button.
//
//  Created by Kar Mun Pui on 8/06/14.
//  Copyright (c) 2014 Kar Mun Pui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NamecardData1.h"
#import "AddNamecardViewController.h"
#import "NamecardDetailsViewController.h"

@interface NamecardsViewController : UITableViewController 

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;

@end
