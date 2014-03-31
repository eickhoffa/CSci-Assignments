;; ====== LAB 11 ======
;;    Author(s):  
;;                
;;  Lab Section:  

;;;; Utility Functions

;; Reloads the current file.
(define (reload)
  (load "lab11.scm")  ; Change file name if copied to a new file.
)

;; Square
(define (square x) (* x x))

;;;; Test Case Code:
;;;;   This will handle execution of the test cases we've included below.
;;;;   To run test cases for a step, uncomment the (do-tests #) line.
;;;;   Note:  This code will run on MIT Scheme, but would have to be modified
;;;;          to work with other versions of Scheme. 
;;;;          Change #t to #f in the line below to use for Dr Scheme / STk.
;;;;          Behavior under Dr Scheme / STk is not tested.
(define (do-tests n)
  (let* ((in-mit-scheme #t)  ;; ** Change this value 
	 (tests-symbol 
	  (string->symbol 
	   (string-append "test-cases-step-" 
			  (number->string n))))

	 (test-cases 
	  (if in-mit-scheme 
	      (eval tests-symbol user-initial-environment)
	      (eval tests-symbol)))

	 (display-string (string-append 
			  "\n--- Test Cases for Step "
			  (number->string n)
			  " ---\n")))

    (display display-string)

    (for-each 
     (lambda (x)
       (if (and (pair? x) (eq? (car x) 'define))
	   (if in-mit-scheme 
	       (eval x user-initial-environment) 
	       (eval x))
	   (begin 
	     (display x)
	     (newline)
	     (display (if in-mit-scheme 
			  (eval x user-initial-environment) 
			  (eval x)))
	     (newline))))
     test-cases)))
;;;;
;;;; Step 1.  A First Object
;;;;


(define count 
  (let ((a 0))
    (lambda ()
      (if (= a 3)
	  (begin (set! a 0) a)
	  (begin (set! a (+ a 1)) a))))
)

; Suppose we have the following additional definitions:
     (define counter1 count)
     (define counter2 count)
     (define counter3 count)
; Do these counters behave independently of each other when called as in
; the examples below?
;  (counter1)
 ;   (display (counter1))
  ;  (display (counter3))
   ; (display (counter2))
; Explain:
; Your answer here...
; No, the counter functions do not behave independently because they are all calling the same function.
;

(define test-cases-step-1
  '(
    (count)
    (count)
    (count)
    (count)
    (count)))

(do-tests 1) 


;;;;
;;;; Step 2.  An Object Builder
;;;;

;; make-count
(define (make-count)
(define count
  (let ((a 0))
    (lambda ()
      (if (= a 3)
	  (begin (set! a 0) a)
	  (begin (set! a (+ a 1)) a)))))
count)

(define test-cases-step-2
  '(
    (define a (make-count))
    (define b (make-count))
    (a) (a)
    (b) (b) (b) (b)
    (a)
))

 (do-tests 2) 


;;;;
;;;; Step 3.  What's all the flap about?
;;;;

(define (make-flip)
    (let ((a 0))
      (lambda ()
	(if (= a 1)
	    (begin (set! a 0) a)
	    (begin (set! a (+ a 1)) a)))))


(define test-cases-step-3
  '(
    (define flip1 (make-flip))
    (define flip2 (make-flip))
    (flip1)
    (flip1)
    (flip2)
    (flip1)))

 (do-tests 3) 


;;;;
;;;; Step 4. Don't flip out.
;;;;

(define test-cases-step-4
  '(
    (define flip (make-flip))
    (define flap1 (flip))
    (define (flap2) (flip))
    (define flap3 flip)
    (define (flap4) flip)))

 (do-tests 4) 

; Evaluate each of these by hand in your interpreter and try to figure out what
; interaction causes each return value.
; Answers for each here:
; flap1      returns 1 because it is resetting the function each time it is              called.
; (flap2)    alternates between 1 and 0
; flap3      defining flap3 as a function
; flap4      returns a procedure
; (flap4)    returns a procedure
; (flap1)    error because there is no (flap1) function
; flap2      returns a procedure
; (flap3)    alternates between 1 and 0


;;;;
;;;; Step 5. List Mutation
;;;;

(define (list-set-nth lst n newvalue)
  (cond ((null? lst) "Improper n value")
	((= n 0)
	 (begin (set-car! lst newvalue) lst))
	(else (cons (car lst) (list-set-nth (cdr lst) (- n 1) newvalue)))))

(define test-cases-step-5
  '(
    (define x '(9 2 7 4 5))
    (define y '(10 45 4 89))
    (list-set-nth x 3 87)
    x
    (list-set-nth y 2 'hello)
    y
))

 (do-tests 5) 

;;;;
;;;; Step 6.  Message Passing
;;;;

;; Write a "grades" object with local state that accepts the following
;; messages: 'add-grade 'get-student-average 'get-assignment-average.
;;
;; Example
;; (define grades (make-grades))
;;                      student ID   assignment #   grade
;; ((grades 'add-grade) 12           1              89)
;; ((grades 'add-grade) 19           1              94)
;; ((grades 'add-grade) 38           1              100)
;; ((grades 'add-grade) 42           1              92)
;; ((grades 'add-grade) 12           2              86)
;; ((grades 'add-grade) 19           2              84)
;; ((grades 'add-grade) 38           2              91)
;; ((grades 'add-grade) 42           2              97)
;;
;; Then
;; ((grades 'get-student-average) 12) -> 87.5
;; ((grades 'get-assignment-average) 1) -> 93.75
;;
;; If you're having trouble imagining this, it may be helpful to load
;; lab10 and examine how we represented the table. To do this, type t
;; in the interpreter after loading the lab.

(define (make-grades)
        (let ((gradebook '()))
        (define (add-grade id assignment grade)
                     (begin (set! gradebook (append gradebook (list (list id assignment grade))))) gradebook)      
        (define (get-student-average id)
                (define (helper gradebook total count)
                        (cond ((null? gradebook) (/ total count))
                              ((equal? id (caar gradebook)) (helper (cdr gradebook) (+ total (caddar gradebook)) (+ 1 count)))
                              (else (helper (cdr gradebook) total count))))
                (helper gradebook 0 0))
        (define (get-assignment-average assignment)
                (define (helper gradebook total count)
                        (cond ((null? gradebook) (/ total count))
                              ((equal? assignment (cadar gradebook)) (helper (cdr gradebook) (+ total (caddar gradebook)) (+ 1 count)))
                              (else (helper (cdr gradebook) total count))))
                (helper gradebook 0 0))
        (define (dispatch x)
                (cond ((eq? x 'add-grade) add-grade)
                      ((eq? x 'get-student-average) get-student-average)
                      ((eq? x 'get-assignment-average) get-assignment-average)
                      (else "improper input")))
                dispatch))
        
        



(define test-cases-step-6
  '(
	(define grades (make-grades))
	;;                   student ID    assignment # grade
	((grades 'add-grade) 12            1            89)
	((grades 'add-grade) 19            1            94)
	((grades 'add-grade) 38            1            100)
	((grades 'add-grade) 42            1            92)
	((grades 'add-grade) 12            2            86)
	((grades 'add-grade) 19            2            84)
	((grades 'add-grade) 38            2            91)
	((grades 'add-grade) 42            2            97)
	((grades 'get-student-average) 12)
	((grades 'get-assignment-average) 1)

	))

 (do-tests 6)


;; The code for the project question does not belong here. The test
;; case for your AI will be watching it play against random.
