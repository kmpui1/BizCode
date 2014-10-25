//
//  AddNamecardViewController.h
//  Business Card
//
//  User must enter the ID and the name to search for the namecard. If it is found from the database server, it will automatically added to the namecard collection and user will be brought to the screen where the found namecard details will be shown.
//  If user enter an invalid ID or name, user will be notified.
//  If user did not enter either ID or name, an error alert will be shown to prompt user to enter both the field.
//
//  Created by Kar Mun Pui on 7/06/14.
//  Copyright (c) 2014 Kar Mun Pui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NamecardData1.h"
#import "NamecardDetailsViewController.h"

@interface AddNamecardViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *idSearchTextField;
@property (weak, nonatomic) IBOutlet UITextField *searchNameTextField;

@property (strong) NamecardData1 *namecard;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong,nonatomic) UIManagedDocument *document;

- (IBAction)cancel:(id)sender;
- (IBAction)search:(id)sender;

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender;

@end
