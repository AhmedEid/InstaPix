### InstaPix

## Find Instagram photos near me

### README 

This is an Objective C app that fetches a list of images within a search radius around the user's location by passing in the location (latitude and longitude) to the Instagram API.
The images returned are available on the map as pins. 

If you tap anywhere on the map, you will be taken to a collectionView of all the images. 
If you tap on the right accessory button in the callout from the pin, you will be taken to an individual photo screen. 

The app tries to lazy-load all image assets, using a category on UIImageView which asynchronously downloads an image while setting a placeholder image. 
It will attempt two retires before giving up.

### Prerequisites

- XCode 5.x
- ios 7.1

### Running the app

Simply hit run. I kept my Instagram App client ID and secret in the app for testing purposes. 
If you would like to use your own client ID and secret, please do so in the AEInstagramPhotosManager.m class

### Known issues / assumptions:
- There is no caching within the app, if an image is already downloaded, we don't check a local cache to see if the image exists before downloading it. Also, we do not delete downloaded images. 
- There is no network connection check --  no network means no results, with an error message, and it will not restart the process. 

