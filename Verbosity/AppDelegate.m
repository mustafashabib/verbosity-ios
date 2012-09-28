//
//  AppDelegate.m
//  Verbosity
//
//  Created by Mustafa Shabib on 6/20/12.
//  Copyright Betel Nut Games 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "VerbosityPreLoadLayer.h"
#import "VerbosityGameState.h"
#import "VerbosityGameLayer.h"
#import "TestFlight.h"
#import "SimpleAudioEngine.h"
#import "PauseGameLayer.h"
#import "VerbosityGameConstants.h"
#import "VerbositySettings.h"

@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;
/*
 My Apps Custom uncaught exception catcher, we do special stuff here, and TestFlight takes care of the rest
 */
void HandleExceptions(NSException *exception) {
    NSLog(@"This is where we save the application data during a exception");
    // Save application data on crash
}
/*
 My Apps Custom signal catcher, we do special stuff here, and TestFlight takes care of the rest
 */
void SignalHandler(int sig) {
    NSLog(@"This is where we save the application data during a signal");
    // Save application data on crash
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&HandleExceptions);
    // create the signal action structure
    struct sigaction newSignalAction;
    // initialize the signal action structure
    memset(&newSignalAction, 0, sizeof(newSignalAction));
    // set SignalHandler as the handler in the signal action structure
    newSignalAction.sa_handler = &SignalHandler;
    // set SignalHandler as the handlers for SIGABRT, SIGILL and SIGBUS
    sigaction(SIGABRT, &newSignalAction, NULL);
    sigaction(SIGILL, &newSignalAction, NULL);
    sigaction(SIGBUS, &newSignalAction, NULL);
    
    [TestFlight takeOff:@"0720a5d7fbaa84c532f261d15814e864_MTEwODk5MjAxMi0wNy0xNiAyMDo1NjoyNy4yNjQ2MDQ"];
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];

	director_.wantsFullScreenLayout = YES;

	// Display FSP and SPF
	[director_ setDisplayStats:NO];

	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];

	// attach the openglView to the director
	[director_ setView:glView];

	// for rotation and other messages
	[director_ setDelegate:self];

	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
//	[director setProjection:kCCDirectorProjection3D];

	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");

	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;

	// set the Navigation Controller as the root view controller
//	[window_ setRootViewController:rootViewController_];
	[window_ addSubview:navController_.view];
    [window_ setRootViewController:navController_];
	// make main window visible
	[window_ makeKeyAndVisible];

	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"

	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

    // initialize random seed
    srandom(time(NULL));
    
    //set menu item font
    [CCMenuItemFont setFontName:@"AmerTypewriterITCbyBT-Medium"];
    
    //set volume
    
    float fxVolume = [VerbositySettings sharedSettings].FXVolume;
    [[SimpleAudioEngine sharedEngine] setEffectsVolume:fxVolume];
    
	// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
    
  
	[director_ pushScene: [VerbosityPreLoadLayer scene]];

	return YES;
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
    [VerbosityGameState sharedState].IsActive = NO;
    
   	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
    [VerbosityGameState sharedState].IsActive = YES;
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
    [VerbosityGameState sharedState].IsActive = NO;
    
    if( [[CCDirector sharedDirector] runningScene].userData != nil &&
        [(NSString*)[[CCDirector sharedDirector] runningScene].userData isEqualToString:kGameLayerData]){
            [[CCDirector sharedDirector] pushScene: [PauseGameLayer scene]];
    }
   	
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
    [VerbosityGameState sharedState].IsActive = YES;
    
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

@end
