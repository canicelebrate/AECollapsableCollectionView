//
//  AECollapsableCollectionView.m
//  AECollapsableCollectionViewDemo
//
//  Created by WangLin on 16/9/22.
//  Copyright © 2016年 AmberEase Co.,ltd. All rights reserved.
//

#import "AECollapsableCollectionView.h"

@interface AECollapsableCollectionView ()<UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray* expandedSections;
@property (nonatomic, weak) id<UICollectionViewDataSource> myDataSource;

@end


@implementation AECollapsableCollectionView
@dynamic delegate;

#pragma mark - Constructors

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.allowsMultipleExpandedSections = YES;
}


#pragma mark - Public Methods
- (NSMutableArray *)expandedSections {
    if (!_expandedSections) {
        _expandedSections = [NSMutableArray array];
        NSInteger maxI = [self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)] ? [self.dataSource numberOfSectionsInCollectionView:self] : 0;
        for (NSInteger i = 0; i < maxI; i++) {
            [_expandedSections addObject:@YES];
        }
    }
    return _expandedSections;
}


- (BOOL)isExpandedSection:(NSInteger)section {
    return [self.expandedSections[section] boolValue];
}


- (void)collapseAllSections {
    [_expandedSections removeAllObjects];
    _expandedSections = nil;
}

-(void)toggleCollapsableSection:(NSInteger)section{
 
    BOOL willOpen = ![self.expandedSections[section] boolValue];
    NSArray* indexPaths = [self indexPathsForSection:section];
    NSArray* expandedSectionIndexPaths = willOpen ? [self expandedSectionIndexPaths] : @[];
    CGFloat oldContentHeight = self.contentSize.height;
    __block CGFloat newContentHeight = 0.0f;
    [self performBatchUpdates:^{
        if (willOpen) {
            [self deleteItemsAtIndexPaths:[self collapseIndexPathsForSectionIndexPaths:expandedSectionIndexPaths]];
            [self insertItemsAtIndexPaths:indexPaths];
        } else {
            [self deleteItemsAtIndexPaths:indexPaths];
        }
        [self updateExpandedSectionsForSectionIndexPaths:expandedSectionIndexPaths];
        self.expandedSections[section] = @(willOpen);
    } completion:^(BOOL finished){
        if (willOpen) {
            newContentHeight = self.contentSize.height;
            CGFloat offset = newContentHeight - oldContentHeight;


            CGFloat boundsHeight = self.bounds.size.height;

            UICollectionReusableView* headerView = [self supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            
            CGFloat sectionTop = headerView.frame.origin.y;
            CGFloat headerHeight = headerView.frame.size.height;
            
            if ((sectionTop + offset + headerHeight) <= (self.contentOffset.y + boundsHeight)) {
                //展开后，如果section头位置不动，当前视窗可以容纳所有新内容
                //什么也不做
                //[self setContentOffset:CGPointMake(0., sectionTop) animated:YES];
                
            }
            else{
                if((headerHeight + offset) > boundsHeight){
                    //展开后新的section的内容的高度，超过整个窗体的大小,将当前的section头置顶
                    [self setContentOffset:CGPointMake(0,sectionTop) animated:YES];
                }
                else{
                    //展开后，需要将内容向上滚动以显示所有新的内容
                    CGFloat offsetMovement =  (sectionTop + headerHeight + offset) - (self.contentOffset.y + boundsHeight);
                    [self setContentOffset:CGPointMake(0, self.contentOffset.y + offsetMovement)];
                    
                }
            }
            
            
        //        [self setContentOffset:CGPointMake(0., self.contentOffset.y + offset) animated:YES];
        
            
        
            
            
            if ([self.delegate respondsToSelector:@selector(collectionView:didExpandItemAtSection:)]) {
                //[self didCollapseItemsForSectionIndexPaths:expandedSectionIndexPaths];
                [self.delegate collectionView:self didExpandItemAtSection:section];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(collectionView:didCollapseItemAtSection:)]) {
                [self.delegate collectionView:self didCollapseItemAtSection:section];
            }
        }
    }];
    

    
}

#pragma mark - Help Methods

- (NSArray*)indexPathsForSection:(NSInteger)section {
    NSMutableArray* indexPaths = [NSMutableArray array];
    for (NSInteger i = 0, maxI = [self.myDataSource collectionView:self numberOfItemsInSection:section]; i < maxI; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:section]];
    }
    return [indexPaths copy];
}

- (NSArray*)expandedSectionIndexPaths {
    NSMutableArray* sectionIndexPaths = [NSMutableArray array];
    if (!self.allowsMultipleExpandedSections) {
        for (NSInteger i = 0; i < self.numberOfSections; i++) {
            if ([self isExpandedSection:i]) {
                [sectionIndexPaths addObject:[NSIndexPath indexPathForItem:0 inSection:i]];
            }
        }
    }
    return [sectionIndexPaths copy];
}

- (NSArray*)collapseIndexPathsForSectionIndexPaths:(NSArray*)sectionIndexPaths {
    NSArray* indexPaths = @[];
    for (NSIndexPath* sectionIndexPath in sectionIndexPaths) {
        indexPaths = [indexPaths arrayByAddingObjectsFromArray:[self indexPathsForSection:sectionIndexPath.section]];
    }
    return indexPaths;
}

- (void)updateExpandedSectionsForSectionIndexPaths:(NSArray*)sectionIndexPaths {
    for (NSIndexPath* sectionIndexPath in sectionIndexPaths) {
        self.expandedSections[sectionIndexPath.section] = @(NO);
    }
}

/*
- (void)didCollapseItemsForSectionIndexPaths:(NSArray*)sectionIndexPaths {
    for (NSIndexPath* sectionIndexPath in sectionIndexPaths) {
        if ([self.delegate respondsToSelector:@selector(collectionView:didCollapseItemAtIndexPath:)]) {
            [self.delegate collectionView:self didCollapseItemAtIndexPath:sectionIndexPath];
        }
    }
}
*/


/**/
#pragma mark - Override Methods
- (id<UICollectionViewDataSource>)dataSource {
    return [super dataSource];
}

- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource {
    _myDataSource = dataSource;
    [super setDataSource:self];
}
//*/

/**/
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.myDataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)] ? [self.myDataSource numberOfSectionsInCollectionView:self] : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItemsInSection = [self.myDataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)] ? [self.myDataSource collectionView:self numberOfItemsInSection:section] : 0;
    return [self isExpandedSection:section] ? numberOfItemsInSection : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.myDataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)] ? [self.myDataSource collectionView:self cellForItemAtIndexPath:indexPath] : [UICollectionViewCell new];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [self.myDataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)] ? [self.myDataSource collectionView:self viewForSupplementaryElementOfKind:kind atIndexPath:indexPath] : nil;
}
//*/

@end
