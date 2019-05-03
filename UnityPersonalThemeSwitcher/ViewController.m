//
//  ViewController.m
//  UnityPersonalThemeSwitcher
//
//  Created by Sergey A. Bazylev on 20/09/2018.
//  Copyright © 2018 Sergey A. Bazylev. All rights reserved.
//

#import "UnityThemeController.h"
#import "ViewController.h"

@implementation ViewController

static NSString *defaultUnityPath = @"/Applications/Unity/Hub/Editor/2019.1.1f1/Unity.app/Contents/MacOS/Unity";

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self processDetectCurrentUnityTheme: defaultUnityPath];
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];
}

- (IBAction)onSwitchThemeClick:(id)sender {
	[self processPathUnityFile: defaultUnityPath];
}

- (void)processDetectCurrentUnityTheme:(NSString *)path { 
	
	[_processSpinner startAnimation: self];
	[_processSpinner setHidden: false];
	[_buttonSwitchTheme setEnabled: false];
	_unity3dPathLabel.stringValue = @"";
	
	NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
		UnityThemeController *controller = [[UnityThemeController alloc] init];
		
		[controller open: path];
		
		NSString *modeText = nil;
		
		switch (controller.unityUiMode) {
			case StandardMode:
				modeText = @"Personal";
				break;
				
			case DarkMode:
				modeText = @"Professional";
				break;
				
			default: modeText = @"Undefined";
				break;
		}
		
		self->_modeLabel.stringValue = modeText;
		self->_unity3dPathLabel.stringValue = [@"Unity3d path: " stringByAppendingString: path];
		[self->_processSpinner stopAnimation: self];
		[self->_processSpinner setHidden: true];
		[self->_buttonSwitchTheme setEnabled: true];
	}];
	
	[ [NSOperationQueue mainQueue] addOperation:operation];
}

- (void)processPathUnityFile:(NSString *)path {
	
	[_processSpinner startAnimation: self];
	[_processSpinner setHidden: false];
	[_buttonSwitchTheme setEnabled: false];
	
	NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
		UnityThemeController *controller = [[UnityThemeController alloc] init];
		
		[controller open: path];
		
		NSString *modeText = nil;
		
		if (controller.unityUiMode == StandardMode || controller.unityUiMode == DarkMode) {
			[controller switchUiMode];
			
			[controller open: path];
			
			switch (controller.unityUiMode) {
				case StandardMode:
					modeText = @"Standard";
					break;
					
				case DarkMode:
					modeText = @"Dark";
					break;
					
				default: modeText = @"Undefined";
					break;
			}
		}
		
		self->_modeLabel.stringValue = modeText;
		[self->_processSpinner stopAnimation: self];
		[self->_processSpinner setHidden: true];
		[self->_buttonSwitchTheme setEnabled: true];
	}];
	
	[ [NSOperationQueue mainQueue] addOperation:operation];
	
}

@end
