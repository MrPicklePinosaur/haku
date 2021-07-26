#lang racket
(define (f x) (* x (+ x 1)))

(define (本)
  (let
      ((x 44) (y 2))
  (displayln (f 6))
  (displayln (g 6 7))
    (displayln (- x y))
   )
  )

(define (g x y) (+ 1 (* x y)))

(本)

