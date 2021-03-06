/*
 CoreDataStack.m
 5Artists
 
 Created by Said on 01/12/2014.
 Copyright (c) 2014 Tower Labs. All rights reserved.
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 2
 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the
 Free Software Foundation, Inc., 51 Franklin Street,
 Fifth Floor, Boston, MA  02110-1301, USA.
 */

#import "CoreDataStack.h"

@interface CoreDataStack ()

@end

@implementation CoreDataStack

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static CoreDataStack *coreDataStack = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreDataStack = [CoreDataStack new];
    });
    return coreDataStack;
}

#pragma mark - Init

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        // Create model
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"5Artists" withExtension:@"momd"];
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        // Create coordinator
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        // Create context
        _context = [NSManagedObjectContext new];
        _context.persistentStoreCoordinator = _coordinator;
        
        // Create store
        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"5Artists.sqlite"];
        
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES};
        
        NSError *error = nil;
        _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
        
        if (!_store) {
            NSLog(@"Error adding persistent store: %@", error.description);
        }
        
    }
    
    return self;
    
}

#pragma mark - Helpers

- (void)saveContext {
    
    if (!self.context) {
        return;
    }
    
    NSError *error = nil;
    if ([self.context hasChanges] && ![self.context save:&error]) {
        NSLog(@"Error saving context: %@", error.userInfo);
    }
    
}

#pragma mark - Entity descriptions

@end