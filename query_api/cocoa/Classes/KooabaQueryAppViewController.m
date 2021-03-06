//
//  KooabaQueryAppViewController.m
//  KooabaQueryApp
//
//  Created by Joachim Fornallaz on 12.01.11.
//  Copyright 2011 kooaba AG. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. 
//

#import "KooabaQueryAppViewController.h"
#import "KooabaQuery.h"

@implementation KooabaQueryAppViewController

#pragma mark -
#pragma mark Object lifecycle

- (void)dealloc
{
	[locationManager release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	locationArrowView.hidden = YES;
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	[locationManager startUpdatingLocation];
	textView.font = [UIFont fontWithName:@"Courier" size:12.0];
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
	[imagePickerController release];
	[textView release];
	[locationArrowView release];
}

#pragma mark -
#pragma mark Action methods

- (IBAction)takePicture
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	[self presentModalViewController:imagePickerController animated:YES];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self dismissModalViewControllerAnimated:YES];
	UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	if (originalImage) {
		NSData *jpegData = UIImageJPEGRepresentation(originalImage, 0.75);
		KooabaQuery *query = [[KooabaQuery alloc] initWithImageData:jpegData type:@"jpeg"];
		query.accessKey = @"df8d23140eb443505c0661c5b58294ef472baf64";
		query.secretKey = @"054a431c8cd9c3cf819f3bc7aba592cc84c09ff7";
		query.groupIds = [NSArray arrayWithObject:[NSNumber numberWithInt:32]];
		query.location = locationManager.location; // might be nil
		NSString *result = [query create];
		NSLog(@"The return string  %@", result);

		textView.text = result;
		[query release];
	}
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	[locationManager stopUpdatingLocation];
	locationArrowView.hidden = NO;
}

@end
