//
//  AECollapsableCollectionView.h
//  APLExpandableCollectionViewDemo
//
//  Created by WangLin on 16/9/22.
//  Copyright © 2016年 AmberEase Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AECollapsableCollectionViewDelegate <UICollectionViewDelegateFlowLayout>

@optional

/** Tells the delegate that the item at the specified index path was expanded. */
- (void)collectionView:(UICollectionView *)collectionView didExpandItemAtSection:(NSInteger)indexPath;

/** Tells the delegate that the item at the specified index path was collapsed. */
- (void)collectionView:(UICollectionView *)collectionView didCollapseItemAtSection:(NSInteger)indexPath;

@end

@interface AECollapsableCollectionView : UICollectionView
/** The collection view’s delegate object. */
@property (nonatomic, assign) id <AECollapsableCollectionViewDelegate> delegate;

/** A Boolean value that determines whether users can expand more than one section, default is YES */
@property (nonatomic, assign) BOOL allowsMultipleExpandedSections;

/** Returns YES if the specified section is expanded. */
- (BOOL)isExpandedSection:(NSInteger)section;

/** Collapses all expanded sections.
 */
- (void)collapseAllSections;

/**
 *  Toggle section's collapsable state between collapsed and expanded
 */
-(void)toggleCollapsableSection:(NSInteger)section;
@end
