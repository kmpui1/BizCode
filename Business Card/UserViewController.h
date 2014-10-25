//
//  UserViewController.h
//  Business Card
//
//  User can add his/her own profile or view his/her own profile after added the details.
//
//
//  Created by Kar Mun Pui on 6/06/14.
//  Copyright (c) 2014 Kar Mun Pui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDetailsViewController.h"
#import "UserNamecardViewController.h"


@interface UserViewController : UITableViewController

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;

@end
