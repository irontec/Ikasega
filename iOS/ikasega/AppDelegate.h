//
//  AppDelegate.h
//  ikasega
//
//  Created by Sergio Garcia on 22/10/14.
//  Copyright (c) 2014 Sergio Garcia. All rights reserved.
//

@import UIKit;
@import CoreData;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
@end

