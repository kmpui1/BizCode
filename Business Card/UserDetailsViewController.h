//
//  UserDetailsViewController.h
//  Business Card
//
//  User can add and edit his/her own details in this view controller. This includes adding title, name, position, company, phone, address and email.
//  User could also add a photo chosen from the photo library.
//  All the datails will be save into the database on the server and the image will be uploaded to the server using Black Raccoon.
//  User details and image will also be kept in the Core Data for data persistency.
//
//  Created by Kar Mun Pui on 6/06/14.
//  Copyright (c) 2014 Kar Mun Pui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CFNetwork/CFNetwork.h>
#import "Users.h"
#import "BRRequestUpload.h"


@interface UserDetailsViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BRRequestDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)addPhoto:(id)sender;

@property (strong, nonatomic) BRRequestUpload *uploadFile;  // Black Raccoon's upload object
@property (strong,nonatomic) NSData *uploadData;// data we plan to upload

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, retain) NSNumber * userIdnum;
@property (nonatomic) int page;
@property (nonatomic) int number;
@property (strong) NSManagedObject *user;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong,nonatomic) UIManagedDocument *document;

@end
