module Shape (
  Shape(Sphere, Plane, Box),
  cube
) where

import Prelude as P
import Vector as V
import Ray


data Shape = Sphere { sphere_position :: Vec3
                    , sphere_radius :: Float }
           | Plane { plane_normal :: Vec3
                   , plane_distance :: Float }
           | Box { box_min :: Vec3
                 , box_max :: Vec3 }
  deriving (Show)


cube :: Vec3 -> Float -> Shape
cube (Vec3 x y z) side = Box (Vec3 (x - half) (y - half) (z - half))
                             (Vec3 (x + half) (y + half) (z + half))
  where half = side / 2