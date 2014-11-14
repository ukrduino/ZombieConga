// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
let π = CGFloat(M_PI) // 3.14


func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (inout left: CGPoint, right: CGPoint) {
    left = left + right
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
func -= (inout left: CGPoint, right: CGPoint) {
    left = left - right
}
func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}
func *= (inout left: CGPoint, right: CGPoint) {
    left = left * right
}
func * (point: CGPoint, scalar: CGFloat) -> CGPoint { return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func *= (inout point: CGPoint, scalar: CGFloat) {
    point = point * scalar
}

func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

func /= (inout left: CGPoint, right: CGPoint) {
    left = left / right
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

func /= (inout point: CGPoint, scalar: CGFloat) {
    point = point / scalar
}

#if !(arch(x86_64) || arch(arm64))
    func atan2(y: CGFloat, x: CGFloat) -> CGFloat {
    return CGFloat(atan2f(Float(y), Float(x))) }
    
    func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    func normalized() -> CGPoint {
        return self / length()
    }
    var angleDeg: CGFloat {
        return (atan2(y, x))*(180/CGFloat(M_PI))
    }
    var angleRad: CGFloat {
        return atan2(y, x)
    }
}



func shortestAngleBetween(angle1: CGFloat, angle2: CGFloat) -> CGFloat {
    let twoπ = π * 2.0
    var angle = (angle2 - angle1) % twoπ
    //в XCODE углы в радианах,
    //1 радиан — центральный угол, длина дуги которого равна радиусу окружности см. Circle_radians.gif в Supporting Files.
    //Далее преобразования углов: α[рад] — угол в радианах, α[°] — угол в градусах,
    //α[°] = α[рад] × (180° / π) или α[рад] × (360° / 2π)
    //α[рад] = α[°] : (180° / π) = α[°] × (π / 180°)
    //таким образом, 180° = π радиан, 360° = 2π радиан
    //в тригонометрии обозначение  π  подразумевает не его числовое значение (3,1415926535), а  π * Rad, то есть 180° и т. п.
    //в данной функции angle это остаток от деления разницы углов на 360° (2π)
    
    if (angle >= π) { //   >=180
        angle = angle - twoπ // -360
    }
    //сравниваем остаток от деления(angle) с π (π * Rad, то есть 180°) и если angle >= 180 то от angle отнимаем 360. Например 195 больше чем 180, 195-360= -165
    
    if (angle <= -π) {  // <= 180
        angle = angle + twoπ // +360
    }
    return angle
}

extension CGFloat {
    func sign() -> CGFloat {
        return (self >= 0.0) ? 1.0 : -1.0 }
}

extension CGFloat {
    func degr() -> CGFloat {
        return self * (180/CGFloat(M_PI))
    }
}

extension CGFloat {
    func rad() -> CGFloat {
        return self * (CGFloat(M_PI)/180)
    }
}



let testPoint1 = CGPoint(x: -7, y: -7)
let testPoint2 = CGPoint(x: -7, y: 1)

var ang1 = testPoint1.angleRad

var ang2 = testPoint2.angleRad


var shortestAngle = shortestAngleBetween(ang1, ang2)

var shortestAngleDeg = shortestAngle.degr()



