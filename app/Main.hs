{-# LANGUAGE BangPatterns #-}
module Main where

-- import Lib
import Prelude
import qualified Prelude as P

import Data.Maybe
import Control.Concurrent (threadDelay)
import Control.Parallel (par)

import Vector
import Ray
import Shape
import Intersection
import Image

main :: IO ()
main = do
  animateTimes 300


-- render :: Camera -> Scene -> Image
-- render camera scene image = undefined

animateTimes times =
  let fps = 30
      delay = 1 * 1000 * 1000 `P.div` fps
      animateTimes' 0 = return ()
      animateTimes' left = do
        let angle = ((fromIntegral left) / (fromIntegral times) * 360)
        let image = show $ render 0 (angle * 2) (angle / 2)
        let !_ = seqList image
        putStrLn $ image
        threadDelay delay
        animateTimes' (left-1)
  in animateTimes' times

-- render :: Image
render x y z =
  let scene = translate (Vec3 0 0 5) $ rotate x y z $ translate (Vec3 2 0 0) $ cube (Vec3 0 0 0) 1
  in renderImage scene 40 40 8

renderImage :: Shape -> Int -> Int -> Float -> Image
renderImage scene width height pixelsPerUnit =
  let renderPixel scene x y =
        let ray = makeRay width height x (height-y-1) pixelsPerUnit
            shape = scene
            cast = intersect ray shape
            didHit' = isJust cast
            didHit = par didHit' didHit'
        in didHit
  in makeImage width height (renderPixel scene)

seqList :: [a] -> ()
seqList [] = ()
seqList (x:xs) = seqList xs
