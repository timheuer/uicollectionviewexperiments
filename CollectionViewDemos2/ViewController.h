//
//  ViewController.h
//  CollectionViewDemos2
//
//  Created by Tim Heuer on 7/7/14.
//  Copyright (c) 2014 Tim Heuer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITextView *logOutput;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


@end

