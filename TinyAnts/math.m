//
//  Math.m
//
//
//  Created by Jon Como on 10/18/12.
//  Copyright (c) 2012 Jon Como. All rights reserved.
//

- (void)drawBezierFrom:(CGPoint)from to:(CGPoint)to controlA:(CGPoint)a controlB:(CGPoint)b maxWidth:(float)maxWidth resolution:(float)resolution
{
    float t = 0.0;
    float size;
    float taper;
    CGPoint startPoint;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(contextRef, kCGLineCapRound);
    
    while (t <= 1)
    {
        startPoint = [self pointOnBezierFrom:from to:to controlA:a controlB:b atT:t];
        
        taper = sinf(t * M_PI);
        size = taper * maxWidth;
        
        t += resolution;
        
        CGPoint endPoint = [self pointOnBezierFrom:from to:to controlA:a controlB:b atT:t];
        
        CGContextMoveToPoint(contextRef, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(contextRef, endPoint.x, endPoint.y);
        CGContextSetLineWidth(contextRef, size);
        CGContextSetRGBStrokeColor(contextRef, taper/3, taper/3, taper/3, 1);
        
        CGContextStrokePath(contextRef);
    }
}

- (CGPoint)pointOnBezierFrom:(CGPoint)from to:(CGPoint)to controlA:(CGPoint)a controlB:(CGPoint)b atT:(float)t
{
    float qx, qy;
    float q1, q2, q3, q4;
    
    q1 = t*t*t*-1 + t*t*3 + t*-3 + 1;
    q2 = t*t*t*3 + t*t*-6 + t*3;
    q3 = t*t*t*-3 + t*t*3;
    q4 = t*t*t;
    
    qx = q1*from.x + q2*a.x + q3*b.x + q4*to.x;
    qy = q1*from.y + q2*a.y + q3*b.y + q4*to.y;
    
    return CGPointMake(qx, qy);
}

-(float)angleFromPoint:(CGPoint)point1 toPoint:(CGPoint)point2
{
    float angle;
    
    float dx = point1.x - point2.x;
    float dy = point1.y - point2.y;
    
    angle = atan2f(dy, dx) * 180 / M_PI;
    
    return angle;
}

-(CGPoint)pointFromPoint:(CGPoint)point pushedBy:(float)pushAmount inDirection:(float)degrees
{
    CGPoint returnPoint = point;
    
    returnPoint.x += pushAmount * cosf(degrees * M_PI/180.0);
    returnPoint.y -= pushAmount * sinf(degrees * M_PI/180.0);
    
    return returnPoint;
}

-(float)distanceBetweenPoint:(CGPoint)point1 andPoint:(CGPoint)point2 sorting:(BOOL)sorting
{
    double dx = (point2.x-point1.x);
    double dy = (point2.y-point1.y);
    return sorting ? dx*dx + dy*dy : sqrt(dx*dx + dy*dy);
}