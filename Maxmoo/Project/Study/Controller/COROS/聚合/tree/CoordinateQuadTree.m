//
//  CoordinateQuadTree.m
//  officialDemo2D
//
//  Created by yi chen on 14-5-15.
//  Copyright (c) 2014年 AutoNavi. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>
#import "CoordinateQuadTree.h"
#import "Maxmoo-Swift.h"


QuadTreeNodeData QuadTreeNodeDataForAll(id<CRSMapClusterProtocol> clu)
{
    return QuadTreeNodeDataMake(clu.coordinate.latitude, clu.coordinate.longitude, (__bridge_retained void *)(clu));
}

BoundingBox BoundingBoxForMapRect(MAMapRect mapRect)
{
    CLLocationCoordinate2D topLeft = MACoordinateForMapPoint(mapRect.origin);
    CLLocationCoordinate2D botRight = MACoordinateForMapPoint(MAMapPointMake(MAMapRectGetMaxX(mapRect), MAMapRectGetMaxY(mapRect)));
    
    CLLocationDegrees minLat = botRight.latitude;
    CLLocationDegrees maxLat = topLeft.latitude;
    
    CLLocationDegrees minLon = topLeft.longitude;
    CLLocationDegrees maxLon = botRight.longitude;
    
    return BoundingBoxMake(minLat, minLon, maxLat, maxLon);
}

float CellSizeForZoomLevel(double zoomLevel)
{
    /*zoomLevel越大，cellSize越小. */
    if (zoomLevel < 13.0)
    {
        return 64;
    }
    else if (zoomLevel <15.0)
    {
        return 32;
    }
    else if (zoomLevel <18.0)
    {
        return 16;
    }
    else if (zoomLevel < 20.0)
    {
        return 8;
    }
    
    return 64;
}

BoundingBox quadTreeNodeDataArrayForAnns(QuadTreeNodeData *dataArray, NSArray * anns)
{
    CLLocationDegrees minX = ((id<CRSMapClusterProtocol>)anns[0]).coordinate.latitude;
    CLLocationDegrees maxX = ((id<CRSMapClusterProtocol>)anns[0]).coordinate.latitude;
    
    CLLocationDegrees minY = ((id<CRSMapClusterProtocol>)anns[0]).coordinate.longitude;
    CLLocationDegrees maxY = ((id<CRSMapClusterProtocol>)anns[0]).coordinate.longitude;
    
    for (NSInteger i = 0; i < [anns count]; i++)
    {
        dataArray[i] = QuadTreeNodeDataForAll(anns[i]);
        
        if (dataArray[i].x < minX)
        {
            minX = dataArray[i].x;
        }
        
        if (dataArray[i].x > maxX)
        {
            maxX = dataArray[i].x;
        }
        
        if (dataArray[i].y < minY)
        {
            minY = dataArray[i].y;
        }
        
        if (dataArray[i].y > maxY)
        {
            maxY = dataArray[i].y;
        }
    }
    
    return BoundingBoxMake(minX, minY, maxX, maxY);
}

#pragma mark -

@implementation CoordinateQuadTree

#pragma mark Utility

- (NSArray *)getAnnotationsWithoutClusteredInMapRect:(MAMapRect)rect
{
    __block NSMutableArray *clusteredAnnotations = [[NSMutableArray alloc] init];
    QuadTreeGatherDataInRange(self.root, BoundingBoxForMapRect(rect), ^(QuadTreeNodeData data) {
        id<CRSMapClusterProtocol> ann = (__bridge id<CRSMapClusterProtocol>)data.data;
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(ann.coordinate.latitude, ann.coordinate.longitude);
        CRSMapClusterAnnotation *cluAnn = [[CRSMapClusterAnnotation alloc] init];
        cluAnn.coordinate = coordinate;
        cluAnn.anns = @[ann].mutableCopy;
        
        [clusteredAnnotations addObject:cluAnn];
    });
    
    return clusteredAnnotations;
}

- (NSArray *)clusteredAnnotationsWithinMapRect:(MAMapRect)rect withZoomScale:(double)zoomScale andZoomLevel:(double)zoomLevel
{
    //满足特定zoomLevel时不产生聚合效果(这里取地图的最大zoomLevel，效果为地图达到最大zoomLevel时，annotation全部展开，无聚合效果)
    if (zoomLevel >= 19.0)
    {
        return [self getAnnotationsWithoutClusteredInMapRect:rect];
    }
    
    double CellSize = CellSizeForZoomLevel(zoomLevel);
    double scaleFactor = zoomScale / CellSize;
    
    NSInteger minX = floor(MAMapRectGetMinX(rect) * scaleFactor);
    NSInteger maxX = floor(MAMapRectGetMaxX(rect) * scaleFactor);
    NSInteger minY = floor(MAMapRectGetMinY(rect) * scaleFactor);
    NSInteger maxY = floor(MAMapRectGetMaxY(rect) * scaleFactor);
        
    NSMutableArray *clusteredAnnotations = [[NSMutableArray alloc] init];
    for (NSInteger x = minX; x <= maxX; x++)
    {
        for (NSInteger y = minY; y <= maxY; y++)
        {
            MAMapRect mapRect = MAMapRectMake(x / scaleFactor, y / scaleFactor, 1.0 / scaleFactor, 1.0 / scaleFactor);
            
            __block double totalX = 0;
            __block double totalY = 0;
            __block int     count = 0;
            
            NSMutableArray *anns = [[NSMutableArray alloc] init];
            
            /* 查询区域内数据的个数. */
            QuadTreeGatherDataInRange(self.root, BoundingBoxForMapRect(mapRect), ^(QuadTreeNodeData data)
                                      {
                                          totalX += data.x;
                                          totalY += data.y;
                                          count++;
                                          
                                          [anns addObject:(__bridge id<CRSMapClusterProtocol>)data.data];
                                      });
            
            /* 若区域内仅有一个数据. */
            if (count == 1)
            {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(totalX, totalY);
                CRSMapClusterAnnotation *cluAnn = [[CRSMapClusterAnnotation alloc] init];
                cluAnn.coordinate = coordinate;
                cluAnn.anns = anns;
                
                [clusteredAnnotations addObject:cluAnn];
            }
            
            /* 若区域内有多个数据 按数据的中心位置画点. */
            if (count > 1)
            {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(totalX / count, totalY / count);
                CRSMapClusterAnnotation *cluAnn = [[CRSMapClusterAnnotation alloc] init];
                cluAnn.coordinate = coordinate;
                cluAnn.anns = anns;
                
                [clusteredAnnotations addObject:cluAnn];
            }
        }
    }
    
    return [NSArray arrayWithArray:clusteredAnnotations];
}

#pragma mark - cluster by distance
///按照annotation.coordinate之间的距离进行聚合
- (NSArray<CRSMapClusterAnnotation *> *)clusteredAnnotationsWithinMapRect:(MAMapRect)rect withDistance:(double)distance {
    __block NSMutableArray<id<CRSMapClusterProtocol>> *allAnnotations = [[NSMutableArray alloc] init];
    QuadTreeGatherDataInRange(self.root, BoundingBoxForMapRect(rect), ^(QuadTreeNodeData data) {
        [allAnnotations addObject:(__bridge id<CRSMapClusterProtocol>)data.data];
    });
    
    NSMutableArray<CRSMapClusterAnnotation *> *clusteredAnnotations = [[NSMutableArray alloc] init];
    for (id<CRSMapClusterProtocol> aAnnotation in allAnnotations) {
        CLLocationCoordinate2D resultCoor = CLLocationCoordinate2DMake(aAnnotation.coordinate.latitude, aAnnotation.coordinate.longitude);
        
        CRSMapClusterAnnotation *cluster = [self getClusterForAnnotation:aAnnotation inClusteredAnnotations:clusteredAnnotations withDistance:distance];
        if (cluster == nil) {
            CRSMapClusterAnnotation *aResult = [[CRSMapClusterAnnotation alloc] init];
            aResult.coordinate = aAnnotation.coordinate;
            aResult.anns = @[aAnnotation].mutableCopy;
            
            [clusteredAnnotations addObject:aResult];
        } else {
            double totalX = cluster.coordinate.latitude * cluster.count + resultCoor.latitude;
            double totalY = cluster.coordinate.longitude * cluster.count + resultCoor.longitude;
            NSInteger totalCount = cluster.count + 1;
            
            cluster.coordinate = CLLocationCoordinate2DMake(totalX / totalCount, totalY / totalCount);
            NSMutableArray *newAnns = [NSMutableArray arrayWithArray:cluster.anns];
            [newAnns addObject:aAnnotation];
            cluster.anns = newAnns;
        }
    }
    
    return clusteredAnnotations;
}

- (CRSMapClusterAnnotation *)getClusterForAnnotation:(id<CRSMapClusterProtocol>)annotation inClusteredAnnotations:(NSArray<CRSMapClusterAnnotation *> *)clusteredAnnotations withDistance:(double)distance {
    if ([clusteredAnnotations count] <= 0 || annotation == nil) {
        return nil;
    }
    
    CLLocation *annotationLocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
    for (CRSMapClusterAnnotation *aCluster in clusteredAnnotations) {
        CLLocation *clusterLocation = [[CLLocation alloc] initWithLatitude:aCluster.coordinate.latitude longitude:aCluster.coordinate.longitude];
        double dis = [clusterLocation distanceFromLocation:annotationLocation];
        if (dis < distance) {
            return aCluster;
        }
    }
    
    return nil;
}

#pragma mark Initilization

- (void)buildTreeWithAnns:(NSArray *)anns
{
    QuadTreeNodeData *dataArray = malloc(sizeof(QuadTreeNodeData) * [anns count]);
    
    BoundingBox maxBounding = quadTreeNodeDataArrayForAnns(dataArray, anns);
    
    /*若已有四叉树，清空.*/
    [self clean];
    
    NSLog(@"build tree.");
    /*建立四叉树索引. */
    self.root = QuadTreeBuildWithData(dataArray, [anns count], maxBounding, 4);
    
    free(dataArray);
}

#pragma mark Life Cycle

- (void)clean
{
    if (self.root)
    {
        NSLog(@"free tree.");
        FreeQuadTreeNode(self.root);
    }
    
}

@end
