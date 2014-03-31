;; ====== LAB 7 ======  
;;    Author(s):  Adam Eickhoff, Daniel Goodman
;;               
;;  Lab Section: 5


;;;; Utility Functions

;; Reloads the current file.
(define (reload)
  (load "lab7new.scm")  ; Change file name if copied to a new file.
)

;; display+ displays all of the values with a newline at the end.
(define (display+ . args)
  (for-each
    (lambda (item) (display item))
    args)
  (newline))



;; REMINDER:
;;   You must include test cases for all procedures you write.
;;   No credit will be given without test cases showing working code.
;;   
;;   This lab gives specific instructions for testing the code.
;;   These are minimum requirements, but you may do further tests as needed.
;;   Use define to store the results of your tests so they can be used in future
;;   steps.
;;
;;   Read through the lab writeup for full instructions and hints on how to
;;   approach this lab.
;;
;;   Also pay attention to hints and clarifications provided in this template
;;   regarding the test cases.



;;;;
;;;; Step 1 - Getting Warmed Up
;;;;

;; Recursive accumulate procedure from Lab 5:
(define (accumulate combiner null-value term a next b)
  (cond ((> a b) null-value)
        (else (combiner
                (term a)
                (accumulate combiner null-value term (next a) next b)))))


;; Test Code
(newline)
(display+ "--- STEP 1 - Integers From 1 to 10 ---")
;; Example Of How To Call/Display:
;;  (display+ (accumulate ... ))
(display (accumulate cons ( ) + 1 1+ 10)) (newline)
; Returns (1 2 3 4 5 6 7 8 9 10)
(display+ "--- STEP 1 - Squares of Integers From 23 to 28 ---")
(display (accumulate cons ( ) square 23 1+ 28)) (newline)
; Returns (529 576 625 676 729 784)
(display+ "--- STEP 1 - Powers of 2 from 2 to 4096 ---")
(display (accumulate cons ( ) (lambda (x) (expt 2 x)) 1 1+ 12)) (newline)
; (2 4 8 16 32 64 128 256 512 1024 2048 4096)
(display+ "--- STEP 1 - Integers from 1 to 10 (Iterative) ---")

(define (accumulate-it combiner null-value term a next b)
  (define (helper b total)
    (if (< b a)
	total
	(helper (next b) (combiner b total))))
(helper b null-value))

(display (accumulate-it cons '() + 1 -1+ 10)) (newline)
; Returns (1 2 3 4 5 6 7 8 9 10)

;;;;
;;;; Step 2 - Point Abstraction: Starting a 2-Dimensional Point System
;;;;

;; make-point
(define (make-point x y z)
  (cons x (cons y (cons z '()))))

;; get-x
(define (get-x l1)
  (car l1))

;; get-y
(define (get-y l1)
  (car (cdr l1)))
  
;; get-z
(define (get-z l1)
  (car (cdr (cdr l1))))
  
  (display+ (make-point 1 2 3))

;; Test Code Instructions:
;;   Define a new point.  Display it.
;;   Display the x and y values separately using your selectors.
;;   You may use this point in future tests as well.

;; Note:
;;   The above is done for you below -- just uncomment those lines.
;;   You may want to define some other points here to use in future steps.

(display+ "--- STEP 2 TEST CASES ---")
;; Example Test Case:
   (define pt1 (make-point 2 4 6))
   (display+ "Point: "pt1)            ;; Expecting (2 . 4)
   (display+ "X-Coord: " (get-x pt1)) ;; Expecting 2
   (display+ "Y-Coord: " (get-y pt1)) ;; Expecting 4
   (display+ "Z-Coord: " (get-z pt1)) ;; expecting 6

(define pt2 (make-point 1 3 5))
(display+ "Point: "pt2) ; (1 . 3)
(display+ "X-Coord: " (get-x pt2)) ; 1
(display+ "Y-Coord: " (get-y pt2)) ; 3
(display+ "Z-Coord: " (get-z pt2)) ; 5

;; Define Additional Points:
(define pt3 (make-point 3 5 7))
(display+ "Point: "pt3) ; (3 . 5)
(display+ "X-Coord: " (get-x pt3)) ; 3
(display+ "Y-Coord: " (get-y pt3)) ; 5
(display+ "Z-Coord: " (get-z pt3)) ; 7
(define pt4 (make-point 4 6 8))
(define pt5 (make-point 1 5 9))
(define pt6 (make-point 2 3 4))
(define pt7 (make-point 4 1 3))
;;;;
;;;; Step 3 - Maintaining a List of Points
;;;;

;; make-pt-list
(define (make-pt-list p pt-list)
  (cons p pt-list))

;; the-empty-pt-list
(define the-empty-list '())

;; get-first-point
(define (get-first-point pt-list)
  (car pt-list))

;; get-rest-points
(define (get-rest-points pt-list)
  (cdr pt-list))


;; Test Code:
;;   Using make-pt-list and the-empty-pt-list, define a list with 6+ points.
;;   Show the list after each point is added.
;;   Display the entire list, the first point, and all but the first point.
;;   Display the second point.
;;   Display all except the first two points.

(display+ "--- STEP 3 - Building The List ---")
;; How to start building the list:

;; Continue adding points...
(define my-point-list (make-pt-list pt1 the-empty-list))
(display+ my-point-list)

(define my-point-list (make-pt-list pt2 my-point-list))
(display+ my-point-list)

(define my-point-list (make-pt-list pt3 my-point-list))
(display+ my-point-list)

(define my-point-list (make-pt-list pt4 my-point-list))
(display+ my-point-list)

(define my-point-list (make-pt-list pt5 my-point-list))
(display+ my-point-list)

(define my-point-list (make-pt-list pt6 my-point-list))
(display+ my-point-list)

(define my-point-list (make-pt-list pt7 my-point-list))
(display+ my-point-list)

(display+ "--- STEP 3 - First Point ---")
(display+ (get-first-point my-point-list))
(display+ "--- STEP 3 - Second Point ---")
(display+ (get-first-point (get-rest-points my-point-list)))
(display+ "--- STEP 3 - All Except First Two Points ---")
(display+ (get-rest-points (get-rest-points my-point-list)))
;;;;
;;;; Step 4 - Operations on pt-lists
;;;;


;; sum-xcoord
(define (sum-xcoord pt-list)
    (cond ((null? pt-list) "list empty -0-")
	  ((null? (get-rest-points pt-list)) (get-x (get-first-point pt-list)))
	  (else (+ (get-x (get-first-point pt-list))
	   (sum-xcoord (get-rest-points pt-list))))
	  )
    )
  
   
;; max-xcoord
(define (max-xcoord pt-list)
  (cond ((null? pt-list) 0)
	((null? (get-rest-points pt-list)) (get-x (get-first-point pt-list)))
	(else (max (get-x (get-first-point pt-list))
		   (max-xcoord (get-rest-points pt-list))))))

;; distance
(define (distance p1 p2)
  (sqrt (+ (square (- (get-x p2) (get-x p1)))
	   (square (- (get-y p2) (get-y p1))))))

;; max-distance
(define (max-distance p pt-list)
  (cond ((null? pt-list) 0)
	((null? p) 0)
	((null? (get-rest-points pt-list)) (distance p (get-first-point pt-list)))
	(else (max (distance p (get-first-point pt-list))
		   (max-distance p (get-rest-points pt-list))))))

;; Test Code
;;   Use the list you created in step 3 and the point created in step 2.
;;   Show the results you get using these values in the above operations.
;;   Test the procedures with an empty point list as well.

(display+ "--- STEP 4 - sum-xcoord ---")
(display+ "List: " my-point-list)
(display+ "Sum of x values: " (sum-xcoord my-point-list))
(display+ "List: " the-empty-list)
(display+ "Sum of x values: " (sum-xcoord the-empty-list))

(display+ "--- STEP 4 - max-xcoord ---")
(display+ "List: " my-point-list)
(display+ "Max of x values: " (max-xcoord my-point-list))
(display+ "List: " the-empty-list)
(display+ "Max of x values: " (max-xcoord the-empty-list))

(display+ "--- STEP 4 - distance ---")

(display+ "Distance between pt1 and pt3: " (distance pt1 pt3))
(display+ "Distance between pt2 and pt5: " (distance pt2 pt5))
(display+ "Distance between pt1 and pt4: " (distance pt1 pt4))

(display+ "--- STEP 4 - max-distance ---")
(display+ "Max Distance between pt1 and my-pt-list: " (max-distance pt1 my-point-list))
(display+ "Max Distance between pt2 and my-pt-list: " (max-distance pt2 my-point-list))
(display+ "Max Distance between pt4 and my-pt-list: " (max-distance pt1 my-point-list))


;;;;
;;;; Step 5 - One More Operation on pt-lists
;;;;

;; max-range
(define (max-range pt-list)
  (cond ((null? pt-list) 0)
	((null? (get-rest-points pt-list)) 0)
	(else (max (max-distance (get-first-point pt-list) (get-rest-points pt-list))
			     (max-range (get-rest-points pt-list))))))

;; Test Code:
;;   Use the list from part 3 to test this operation.
;;   Create a second point list with at least 5 entries for additional tests.

(display+ "--- STEP 5 TEST CASES ---")
 (display+ "List: " my-point-list)
 (display+ "Maximum distance: " (max-range my-point-list))
 (display+ "List: " the-empty-list)
 (display+ "Maximum distance: " (max-range the-empty-list))




;;;;
;;;; Step 6 - A Question
;;;;

;; Answer to Question:
;; I think we are asked to make use of previous abstractions wherever possible because it facilitates our learning about lists and how they work. 


;;;;
;;;; Step 7 - Maintaining a Sorted Point-List
;;;;

(define (make-pt-list p pt-list)
  (cons p pt-list))

;; make-sorted-pt-list

(define origin (make-point 0 0 0))
(define (make-sorted-pt-list p pt-list)
  (if (null? pt-list)
      (make-pt-list p pt-list)
      (if (> (distance p origin) (distance (get-first-point pt-list) origin))
	  (make-pt-list (get-first-point pt-list) 
			(make-sorted-pt-list p (get-rest-points pt-list)));(cons pt-list p)
	  (make-pt-list p pt-list))))

;; Answer to Question:
;;
;;
;;

;; Test Code:
;;   Create a sorted list of at least 6 points.
;;   Be sure to test addition of points to the front, back, and middle.
;;   Show the list after each point is added.


(display+ "--- STEP 7 TEST CASES ---")
(define my-pt-list (make-sorted-pt-list pt1 the-empty-list))
(display+ my-pt-list)
(define my-pt-list (make-sorted-pt-list pt2 my-pt-list))
(display+ my-pt-list)
