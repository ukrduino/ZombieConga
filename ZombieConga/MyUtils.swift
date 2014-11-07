//
//  MyUtils.swift
//  ZombieConga
//
//  Created by Romaniuk Sergey on 07.11.14.
//  Copyright (c) 2014 Romaniuk Sergey. All rights reserved.
//

import Foundation
import CoreGraphics

let testPoint1 = CGPoint(x: 100, y: 100)
let testPoint2 = CGPoint(x: 50, y: 50)
let testPoint3 = testPoint1 + testPoint2
let testPoint5 = testPoint1 * 2
let testPoint6 = testPoint1 / 10

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (inout left: CGPoint, right: CGPoint) { left = left + right
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
func -= (inout left: CGPoint, right: CGPoint) { left = left - right
}
func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}
func *= (inout left: CGPoint, right: CGPoint) { left = left * right
}
func * (point: CGPoint, scalar: CGFloat) -> CGPoint { return CGPoint(x: point.x * scalar, y: point.y * scalar)
}
func *= (inout point: CGPoint, scalar: CGFloat) { point = point * scalar
}
func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}
func /= (inout left: CGPoint, right: CGPoint) {
    left = left / right }
func / (point: CGPoint, scalar: CGFloat) -> CGPoint { return CGPoint(x: point.x / scalar, y: point.y / scalar)
}
func /= (inout point: CGPoint, scalar: CGFloat) { point = point / scalar
}
