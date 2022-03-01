;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname spacial-rotation) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #t)))
(require 2htdp/universe)
(require 2htdp/image)

;; data
(define-struct 3d [x y z])
(define-struct lineType [x1 y1 z1 x2 y2 z2 color rotate])

;; origin of the axis
(define ORIGIN (make-posn 250 250))

;; rotation axis
(define X-AXIS (make-lineType 0 0 0 150 0 0 "black" false))
(define Y-AXIS (make-lineType 0 0 0 0 150 0 "black" false))
(define Z-AXIS (make-lineType 0 0 0 0 0 150 "black" true))

;; lines forming the cube
(define LINE1 (make-lineType 50 80 70 100 80 70 "yellow" true))
(define LINE2 (make-lineType 100 30 70 100 80 70 "blue" true))
(define LINE3 (make-lineType 50 30 70 50 80 70 "green" true))
(define LINE4 (make-lineType 50 30 70 100 30 70 "red" true))
(define LINE5 (make-lineType 50 80 70 50 80 20 "red" true))
(define LINE6 (make-lineType 100 80 70 100 80 20 "green" true))
(define LINE7 (make-lineType 100 30 70 100 30 20 "yellow" true))
(define LINE8 (make-lineType 50 30 70 50 30 20 "blue" true))
(define LINE9 (make-lineType 50 80 20 100 80 20 "blue" true))
(define LINE10 (make-lineType 50 30 20 100 30 20 "green" true))
(define LINE11 (make-lineType 100 30 20 100 80 20 "red" true))
(define LINE12 (make-lineType 50 30 20 50 80 20 "yellow" true))

;; background
(define BACKGROUND-1 (rectangle 500 500 "solid" "white"))

;; starting rotation angles
(define START (make-3d 0 0 0))

(define (freezer line)
  (make-lineType (lineType-x1 line)
                 (lineType-y1 line)
                 (lineType-z1 line)
                 (lineType-x2 line)
                 (lineType-y2 line)
                 (lineType-z2 line)
                 (lineType-color line)
                 false))


(define BACKGROUND (add-line (add-line (add-line (rectangle 500 500 "solid" "white")
                                                 (+ (posn-x ORIGIN) (lineType-x1 X-AXIS))
                                                 (- (posn-y ORIGIN) (lineType-y1 X-AXIS))
                                                 (+ (posn-x ORIGIN) (lineType-x2 X-AXIS))
                                                 (- (posn-y ORIGIN) (lineType-y2 X-AXIS))
                                                 (make-pen (lineType-color X-AXIS) 5 "solid" "butt" "bevel"))
                                       (+ (posn-x ORIGIN) (lineType-x1 Y-AXIS))
                                       (- (posn-y ORIGIN) (lineType-y1 Y-AXIS))
                                       (+ (posn-x ORIGIN) (lineType-x2 Y-AXIS))
                                       (- (posn-y ORIGIN) (lineType-y2 Y-AXIS))
                                       (make-pen (lineType-color Y-AXIS) 5 "solid" "butt" "bevel"))
                             (+ (posn-x ORIGIN) (lineType-x1 Z-AXIS))
                             (- (posn-y ORIGIN) (lineType-y1 Z-AXIS))
                             (+ (posn-x ORIGIN) (lineType-x2 Z-AXIS))
                             (- (posn-y ORIGIN) (lineType-y2 Z-AXIS))
                             (make-pen (lineType-color Z-AXIS) 5 "solid" "butt" "bevel")))
(define CONVERT (/ pi 180))

(define (rotation p)
  (big-bang p
    [to-draw draw-lines]
    [on-key update-lines]))

(define (draw-lines p)
  (foldl (lambda (x y) (add-line y (+ (posn-x ORIGIN) (lineType-x1 x)) (- (posn-y ORIGIN) (lineType-y1 x)) (+ (posn-x ORIGIN) (lineType-x2 x)) (- (posn-y ORIGIN) (lineType-y2 x))
                                 (make-pen (lineType-color x) 10 "solid" "round" "bevel")))
         BACKGROUND-1
         (sort (map (lambda (x) (rotateOverZ x (3d-z p))) (map (lambda (x) (rotateOverY x (3d-x p))) (map (lambda (x) (rotateOverX x (3d-y p))) LINES-Y)))
               (lambda (x y) (or (< (lineType-z1 x) (lineType-z1 y))
                                 (< (lineType-z1 x) (lineType-z2 y))
                                 (< (lineType-z2 x) (lineType-z1 y))
                                 (< (lineType-z2 x) (lineType-z2 y)))))))

(define (update-lines p ke)
  (cond
    [(key=? ke "right") (make-3d (+ (3d-x p) 5) (3d-y p) (3d-z p))]
    [(key=? ke "left") (make-3d (- (3d-x p) 5) (3d-y p) (3d-z p))]
    [(key=? ke "up") (make-3d (3d-x p) (+ (3d-y p) 5) (3d-z p))]
    [(key=? ke "down") (make-3d (3d-x p) (- (3d-y p) 5) (3d-z p))]
    [(key=? ke "n") (make-3d (3d-x p) (3d-y p) (+ (3d-z p) 5))]
    [(key=? ke "b") (make-3d (3d-x p) (3d-y p) (- (3d-z p) 5))]
    [else p]))

;; rotation over Y axis
(define (rotateOverY line angle)
  (if (lineType-rotate line) (make-lineType (+ (* (cos (* angle
                                                          CONVERT))
                                                  (lineType-x1 line))
                                               (* (- (sin (* angle
                                                             CONVERT)))
                                                  (lineType-z1 line)))
                                            (lineType-y1 line)
                                            (+ (* (sin (* angle
                                                          CONVERT))
                                                  (lineType-x1 line))
                                               (* (cos (* angle
                                                          CONVERT))
                                                  (lineType-z1 line)))
                                            (+ (* (cos (* angle
                                                          CONVERT))
                                                  (lineType-x2 line))
                                               (* (- (sin (* angle
                                                             CONVERT)))
                                                  (lineType-z2 line)))
                                            (lineType-y2 line)
                                            (+ (* (sin (* angle
                                                          CONVERT))
                                                  (lineType-x2 line))
                                               (* (cos (* angle
                                                          CONVERT))
                                                  (lineType-z2 line)))
                                            (lineType-color line)
                                            true) line))



;; rotation over X axis
(define (rotateOverX line angle)
  (if (lineType-rotate line) (make-lineType (lineType-x1 line)
                                            (+ (* (cos (* angle
                                                          CONVERT))
                                                  (lineType-y1 line))
                                               (* (- (sin (* angle
                                                             CONVERT)))
                                                  (lineType-z1 line)))
                                            (+ (* (sin (* angle
                                                          CONVERT))
                                                  (lineType-y1 line))
                                               (* (cos (* angle
                                                          CONVERT))
                                                  (lineType-z1 line)))
                                            (lineType-x2 line)
                                            (+ (* (cos (* angle
                                                          CONVERT))
                                                  (lineType-y2 line))
                                               (* (- (sin (* angle
                                                             CONVERT)))
                                                  (lineType-z2 line)))
                                            (+ (* (sin (* angle
                                                          CONVERT))
                                                  (lineType-y2 line))
                                               (* (cos (* angle
                                                          CONVERT))
                                                  (lineType-z2 line)))
                                            (lineType-color line)
                                            true)
      line))

;; rotation over Z axis
(define (rotateOverZ line angle)
  (if (lineType-rotate line) (make-lineType (+ (* (cos (* angle CONVERT)) (lineType-x1 line))
                                               (* (- (sin (* angle CONVERT))) (lineType-y1 line)))
                                            (+ (* (sin (* angle CONVERT)) (lineType-x1 line))
                                               (* (cos (* angle CONVERT)) (lineType-y1 line)))
                                            (lineType-z1 line)
                                            (+ (* (cos (* angle CONVERT)) (lineType-x2 line))
                                               (* (- (sin (* angle CONVERT))) (lineType-y2 line)))
                                            (+ (* (sin (* angle CONVERT)) (lineType-x2 line))
                                               (* (cos (* angle CONVERT)) (lineType-y2 line)))
                                            (lineType-z2 line)
                                            (lineType-color line)
                                            true)
      line))


(define LINES-Y (list X-AXIS Y-AXIS (freezer (rotateOverX (rotateOverY Z-AXIS 30) 30)) LINE1 LINE2 LINE3 LINE4 LINE5 LINE6 LINE7 LINE8 LINE9 LINE10 LINE11 LINE12))

                        
;; start up the program
(rotation START)
  





