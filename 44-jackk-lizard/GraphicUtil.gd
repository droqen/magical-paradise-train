extends Node

class_name GraphicUtil


static func DistanceToLineSegment(start, end, point):
    var vector = end - start
    var length = vector.length()
    var normal = vector.normalized()
    var toPoint = point - start
    var dot = toPoint.dot(normal)
    dot = clamp(dot, 0, length)
    var closest = start + normal*dot
    return point.distance_to(closest)

static func DistanceToLine(line_point, line_dir, point):
    var toPoint = point - line_point
    var dot = toPoint.dot(line_dir)
    var closest = line_point + line_dir*dot
    return point.distance_to(closest)
