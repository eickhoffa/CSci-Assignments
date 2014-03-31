;; ====== LAB 4 ======  
;;    Author(s):  Adam Eickhoff, Danny Goodman
;;                
;;  Lab Section:  5


;;;; Utility Functions

;; Reloads the current file.
(define (reload)
 (load "lab4.scm")  ; Change file name if copied to a new file.
  )

(newline) ;; Ensures first line of test cases is on new line.


;;;;;;;;;;;;;;;;;;
;; REMINDER:
;;   You must include test cases for all procedures you write.
;;   Thoroughly test each procedure and be prepared to demonstrate that the code works as expected.
;;;;;;;;;;;;;;;;;;



;;;;
;;;; Step 1 - A Recursive Process
;;;;

;; count-div357
(define (count-div357 a b)
  (if (> a b) ; Base case
      0
      (if (= (remainder a 3) 0) ; If a divides by 3, inc. count by 1
	  (+ 1 (count-div357 (+ a 1) b))
	  (if (= (remainder a 5) 0) ; If a divides by 5, inc count 1
	      (+ 1 (count-div357 (+ 1 a) b))
	      (if (= (remainder a 7) 0) ; If a divides by 7, inc count 1
		  (+ 1 (count-div357 (+ 1 a) b))
		  (count-div357 (+ a 1) b)))))) ; If not divis, add a+1, restart

;; Test Code
(display "=== STEP 1 TEST CASES ===") (newline)
(display (count-div357 3 5)) ; Returns 2
(newline)
(display (count-div357 7 5)) ; Returns 0
(newline)
(display (count-div357 3 10)) ; Returns 6
(newline)
;;;;
;;;; Step 2 - Now Try It Iteratively
;;;;

;; iter-div357
(define (iter-div357 a b)
  (define (helper a count)
    (if (> a b)
	count
	(if (or (= (remainder a 3) 0)
		(= (remainder a 5) 0)
		(= (remainder a 7) 0))
	    (helper (+ a 1) (+ count 1))
	    (helper (+ a 1) count))))
  (helper a 0))

;; Test Code
(display "=== STEP 2 TEST CASES ===") (newline)
(display (iter-div357 3 5)) (newline) ; Returns 2
(display (iter-div357 7 5)) (newline) ; Returns 0
(display (iter-div357 3 10)) (newline) ; Returns 6


;;;;
;;;; Step 3 - Modulo Calculation
;;;;
(define (mod a b)
  (if (< a b) ;;if a>b, returns with a
      a
      (mod (- a b) b))) ;;calls mod with (a-b) and b

;; Solution
;;

(display "=== STEP 3 TEST CASES ===") (newline)
(display (mod 5 4)) (newline) ;;1
(display (mod 4 5)) (newline) ;;4
(display (mod 5 3)) (newline) ;;2


;;;;
;;;; Step 4 - Tree Recursion
;;;;
(define (function n)
        (if (< n 3) ;;if n<3, returns n
        n
        (+ (function (- n 1)) 
           (* 2 (function (- n 2))) 
           (* 3 (function (- n 3)))))) ;;if n>=3, calls function with the new numbers

;; Recursive Procedure


;; Test Code
(display "=== STEP 4 TEST CASES ===") (newline)
(display (function 2)) (newline) ;;2
(display (function 3)) (newline) ;;4
(display (function 4)) (newline) ;;11

;;;;
;;;; Step 5 - Solving for e
;;;
(define (factorial limit) ;;creates a factorial function
        (if (= limit 0) ;;if taking factorial of 0, returns 1
	    1
	    (* limit (factorial (- limit 1))))) ;;else calls function with limit-1
(define (e limit)
        (if (= limit 0) ;;if finding e of 0, returns with 1
	    1
	    (+ (/ 1.0 (factorial limit)) (e (- limit 1))))) ;;else calls (1/factorial function)



;; Test Code
(display "=== STEP 5 TEST CASES ===") (newline)

(display "--- n = 3 ---") (newline)
(display (e 3)) (newline) ;;1/6

(display "--- n = 5 ---") (newline)

(display (e 5)) (newline) ;;1/120

(display "--- n = 10 ---") (newline)

(display (e 10)) (newline) ;;1/3628800

;;;;
;;;; Step 6 - Revisiting Fibonacci From the Text
;;;;

;; Recursive Fibonacci Procedure From Text
(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))

;; Draw Graph on Paper

;; How many times does (fib 2) get called when calculating (fib 5)?
;; Answer:  (fib 2) will be called 3 times when calculating (fib 5)