//
//  UnityApplication.m
//  UnityPersonalThemeSwitcher
//
//  Created by Sergey A. Bazylev on 20/09/2018.
//  Copyright © 2018 Sergey A. Bazylev. All rights reserved.
//

#import "UnityThemeController.h"

static unsigned char standardThemePattern[] = {
    0xE8, 0x47, 0x55, 0xFC, 0x00, 0x31, 0xC0,
    0x84, 0xDB, 0x74, 0x03, 0x41, 0x8B, 0x06,
    0x48, 0x8B, 0x0D, 0x17, 0x3C, 0xBC, 0x05
};

static unsigned char darkThemePattern[] = {
    0xE8, 0x47, 0x55, 0xFC, 0x00, 0x31, 0xC0,
    0x84, 0xDB, 0x75, 0x03, 0x41, 0x8B, 0x06,
    0x48, 0x8B, 0x0D, 0x17, 0x3C, 0xBC, 0x05
};


@implementation UnityThemeController

NSRange markerLoacation;
NSData *patternStandardMode = nil;
NSData *patternDarkMode = nil;
NSData *contentData = nil;
NSString *unityFilePath = nil;

- (UnityThemeController *)init {
	if (self == [super init]) {
        patternStandardMode = [NSData dataWithBytes:standardThemePattern length: 21];
        patternDarkMode = [NSData dataWithBytes:darkThemePattern length: 21];
	}
	return self;
}

- (BOOL)open:(nonnull NSString *)path {
	
	unityFilePath = path;
	
	NSError *readError = nil;
	contentData = [NSData dataWithContentsOfFile:path options:NSDataReadingUncached error: &readError];
	
	if (contentData != nil) {
		markerLoacation = [contentData rangeOfData:patternStandardMode options:0 range:NSMakeRange(0, [contentData length])];
		
		if (markerLoacation.location != NSNotFound) {
			_unityUiMode = StandardMode;
			return true;
			
		} else {
			
			markerLoacation = [contentData rangeOfData:patternDarkMode options:0 range:NSMakeRange(0, [contentData length])];
			
			if (markerLoacation.location != NSNotFound) {
				_unityUiMode = DarkMode;
				return true;
			}
		}
	}
	
	return false;
}

- (BOOL)switchUiMode {
	
	if (contentData == nil) {
		return false;
	}
	
	if (self.unityUiMode == UndefinedMode) {
		return false;
	}
	
	if (markerLoacation.location == NSNotFound) {
		return false;
	}
	
	NSData *pattern = nil;
	
	switch (self.unityUiMode) {
		case StandardMode:
			pattern = patternDarkMode;
			break;
			
		case DarkMode:
			pattern = patternStandardMode;
			break;
			
		default:
			break;
	}
	
	if (pattern == nil) {
		return false;
	}
	NSMutableData *patchedData = [NSMutableData dataWithData:contentData];
	
	[patchedData replaceBytesInRange:markerLoacation withBytes:pattern.bytes];
	
	[patchedData writeToFile:unityFilePath atomically:true];
	
	return true;
}

@end

