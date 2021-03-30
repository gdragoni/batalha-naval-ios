//
//  AppDelegate.h
//  Batalha Naval
//
//  Created by Gabriel A. Dragoni on 12/30/15.
//  Copyright (c) 2015 Gabriel A. Dragoni. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "RestKitCallBack.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSFetchedResultsControllerDelegate>{
}

@property (strong, nonatomic) UIWindow                                  *window;
@property (nonatomic, retain, readonly) NSManagedObjectModel            *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext          *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator    *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;

+(AppDelegate *)sharedInstance;

@end


