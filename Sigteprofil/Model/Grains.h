//
//  Grains.h
//  Sigteprofil
//
//  Created by coneits on 10/9/16.
//  Copyright © 2016 masterteam. All rights reserved.
//

#ifndef Grains_h
#define Grains_h

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Grains : NSManagedObject

@property (nonatomic, retain) NSString * grain_name;
@property (nonatomic, retain) NSString * grain_under;
@property (nonatomic, retain) NSString * grain_middle;
@property (nonatomic, retain) NSString * grain_over;

@end



#endif /* Grains_h */
