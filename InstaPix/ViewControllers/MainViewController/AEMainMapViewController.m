//
//  AEMainViewController.m
//  InstaPix
//
//  Created by Ahmed Eid Air on 5/22/14.
//  Copyright (c) 2014 Ahmed_Eid_Inc. All rights reserved.
//

#import "AEMainMapViewController.h"
#import "AEInstagramPhotosManager.h"
#import "UIImageView+download.h"
#import "AEInstagramPhotoAnnotation.h"
#import "AEInstagramPhotosCollectionViewController.h"
#import "AEInstagramPhotoViewController.h"
#import "AEInstagramPhoto.h"
#import "MBProgressHUD.h"

#define kMinimumValueInKm           20
#define kDefaultSearchRadiusInKm    1000
#define kMaximumValueInKm           4500

@interface AEMainMapViewController () <MKMapViewDelegate>

//Data
@property (nonatomic, strong) AEInstagramPhotosManager *instagramPhotosManager;
@property (nonatomic, strong) NSArray *photos;

//Views
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UISlider *slider;

//Gesture Recognizer
@property (nonatomic, strong) UITapGestureRecognizer *mapTapGestureRecognizer;

@end

@implementation AEMainMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"InstaPix: Ahmed Eid";
    
    self.instagramPhotosManager = [AEInstagramPhotosManager new];
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    self.slider.minimumValue = kMinimumValueInKm;
    self.slider.maximumValue = kMaximumValueInKm;
    self.slider.value = kDefaultSearchRadiusInKm;
    [self.slider addTarget:self action:@selector(sliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider addTarget:self action:@selector(sliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view insertSubview:self.slider aboveSubview:self.mapView];
    
    self.mapTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.mapView addGestureRecognizer:self.mapTapGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Data 

- (void)fetchPhotos {
    
    __weak AEMainMapViewController *weakSelf = self;
    
    [self.instagramPhotosManager fetchPhotosWithinCurrentLocationWithSuccessBlock:^(NSArray *photos) {
        if (photos.count == 0){
            [weakSelf showHUDWithMessage:@"Found no photos near you. Try moving somewhere with some action going on and trying again!" detailMessage:nil];
        } else {
            //Show photos on map
            weakSelf.photos = photos;
            NSLog(@"Successfully downloaded %lu photos from instagram", (unsigned long)photos.count);
            
            [photos enumerateObjectsUsingBlock:^(AEInstagramPhoto *photo, NSUInteger idx, BOOL *stop) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(photo.photoLatitude, photo.photoLongitude);
                photo.distanceFromCurrentPoint = [self getPhotoDistance:coordinate];
                
                AEInstagramPhotoAnnotation *annotation = [[AEInstagramPhotoAnnotation alloc]initWithLocation:coordinate];
                annotation.instagramPhoto = photo;
                annotation.title = [NSString stringWithFormat:@"%.2f km by %@",
                                    [self getPhotoDistance:coordinate] , photo.photoUserName];
                annotation.subtitle = [NSString stringWithFormat:@"Filter: %@", photo.photoFilterName];
                [self.mapView addAnnotation:annotation];

            }];
        }
    } failureBlock:^(NSError *error) {
        [weakSelf showHUDWithMessage:error.description detailMessage:nil];
    }];
}

#pragma mapView Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    //Show tutorial
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showedTutorial"] == NO){
        [self showHUDWithMessage:@"Tap on map to view all images" detailMessage:@"Tap on right accessory button to view individual image"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showedTutorial"];
    }
    
    //Fetch Photos
    if (!self.photos.count){
        //Set location
        [self centerMapViewWithRadius:kDefaultSearchRadiusInKm];
        self.instagramPhotosManager.preferredSearchRadius = kDefaultSearchRadiusInKm;
        self.instagramPhotosManager.searchOriginLocation = mapView.userLocation.location;

        [self fetchPhotos];
    }
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    [self showHUDWithMessage:@"Could not determine your location" detailMessage:nil];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MKPinAnnotationView *tappedAnnotationView = (MKPinAnnotationView *)view;
    AEInstagramPhotoAnnotation *tappedAnnotation = (AEInstagramPhotoAnnotation *)tappedAnnotationView.annotation;
    AEInstagramPhoto *tappedPhoto = tappedAnnotation.instagramPhoto;
    [self presentPhoto:tappedPhoto];
}

- (void)centerMapViewWithRadius:(CGFloat)radius {
    CGFloat radiusMultipliter = 1.3;  //We use a multiplier to show a little more than the exact radius of search
    
    MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(
                                                                      self.mapView.userLocation.location.coordinate,
                                                                      radius*radiusMultipliter,
                                                                      radius*radiusMultipliter
                                                                      );
    [self.mapView setRegion:newRegion];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[AEInstagramPhotoAnnotation class]]) {
        
        AEInstagramPhotoAnnotation *instagramPhotoAnnotation = (AEInstagramPhotoAnnotation*) annotation;
        MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"MKPinAnnotationView"];
        
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:@"MKPinAnnotationView"];
            annotationView.canShowCallout = YES;
            annotationView.enabled = YES;
            
        } else {
            annotationView.annotation = annotation;
        }
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
        annotationView.rightCalloutAccessoryView = rightButton;
        UIImageView *thumbnail = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 48.0f, 48.0f)];
        [thumbnail downloadImageFromUrl:instagramPhotoAnnotation.instagramPhoto.photoThumbnailImageUrl];
        annotationView.leftCalloutAccessoryView  = thumbnail;
        
        return annotationView;
    }
    return nil;
}

#pragma mark - UIGestureRecognizer Methods

-(void) handleTapGesture:(UITapGestureRecognizer*) gestureRecognizer {
    if (self.photos.count == 0){
        return;
    }
    
    CGPoint locInView = [gestureRecognizer locationInView:self.mapView];
    id obj = [self.mapView hitTest:locInView withEvent:nil];
    if ([obj isKindOfClass:[MKPinAnnotationView class]]) {
        return; // do not handle tap gesture if tapped on an annotation
    } else {
        //Present photos
        AEInstagramPhotosCollectionViewController *controller = [[AEInstagramPhotosCollectionViewController alloc] initWithPhotos:self.photos tappedPhotoIndex:(int)[self.photos indexOfObject:0]];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - UISlider Methods

- (void)sliderTouchEnded:(UISlider *)sender {
    self.instagramPhotosManager.preferredSearchRadius = sender.value;
    self.instagramPhotosManager.searchOriginLocation = self.mapView.userLocation.location;
    [self fetchPhotos];
}

- (void)sliderValueChanged:(UISlider *)sender {
    NSArray *annotations = self.mapView.annotations;
    if( annotations.count > 0) {
        [self.mapView removeAnnotations:annotations];
    }
    [self.mapView removeOverlays:self.mapView.overlays];
    [self centerMapViewWithRadius:sender.value];
}

#pragma mark - Other 

- (void)presentPhoto:(AEInstagramPhoto *)photo {
    AEInstagramPhotoViewController *controller = [[AEInstagramPhotoViewController alloc] initWithInstagramPhoto:photo];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showHUDWithMessage:(NSString *)message detailMessage:(NSString *)detailMessage {
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.hud.removeFromSuperViewOnHide = YES;
    self.hud.mode = MBProgressHUDModeText;
    [self.view addSubview:self.hud];
    
    self.hud.labelText = message;
    self.hud.detailsLabelText = detailMessage;
    
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:3.5f];
}

-(CLLocationDistance) getPhotoDistance:(CLLocationCoordinate2D)coord {
    CLLocation *annotationLocation = [[CLLocation alloc]
                                      initWithLatitude:coord.latitude longitude:coord.longitude];
    CLLocationDistance distance = [self.mapView.userLocation.location distanceFromLocation:annotationLocation];
    CLLocationDistance distanceInKm = distance/1000;
    return distanceInKm;
}

@end
