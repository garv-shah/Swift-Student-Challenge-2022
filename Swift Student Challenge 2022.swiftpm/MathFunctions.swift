//
//  File.swift
//  Swift Student Challenge 2022
//
//  Created by Garv Shah on 17/4/2022.
//

import CoreGraphics
import SceneKit

func -(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(x: left.x - right.x , y: left.y - right.y, z: left.z - right.z)
}

func *(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(x: left.x * right.x , y: left.y * right.y, z: left.z * right.z)
}

func *(left: SCNVector3, right: Double) -> SCNVector3 {
    return SCNVector3(CGFloat(left.x) * CGFloat(right), CGFloat(left.y) * CGFloat(right), CGFloat(left.z) * CGFloat(right))
}

func /(left: SCNVector3, right: Double) -> SCNVector3 {
    return SCNVector3(CGFloat(left.x) / CGFloat(right), CGFloat(left.y) / CGFloat(right), CGFloat(left.z) / CGFloat(right))
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(x: left.x + right.x , y: left.y + right.y, z: left.z + right.z)
}

func distance(point1: CGPoint, point2: CGPoint) -> CGFloat {
    return CGFloat(hypotf(Float(point1.x - point2.x), Float(point1.y - point2.y)))
}

func sqrMagnitude (point: SCNVector3) -> CGFloat {
    return CGFloat(point.x * point.x + point.y * point.y + point.z * point.z);
}

extension SCNVector3 {
    // Returns the length of the vector
    var length: CGFloat {
        return CGFloat(sqrt(self.x * self.x + self.y * self.y + self.z * self.z))
    }
    var normalized: SCNVector3 {
        let length = self.length
        return SCNVector3(CGFloat(self.x)/length, CGFloat(self.y)/length, CGFloat(self.z)/length)
    }
}
