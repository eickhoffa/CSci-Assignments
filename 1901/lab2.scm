;;    Author(s):  Danny Goodman & Adam Eickhoff
;;                
;;  Lab Section:  5



;;; Utility Functions

;; Reloads the current file.
(define (reload)
  (load "lab2.scm")  ; Change file name if copied to a new file.
)


;;;; Example Procedure

;; Increments a number by a value of 1.
;; Inputs:  x -- a numerical value
;; Output:  Number that has been incremented.
;; Usage Example: (increment 3) returns 4

(define (increment x)
  (+ x 1))


;; Test Cases (Examples)
(newline)
(display (increment 5))    ;; Returns 6
(newline)
(display (increment -1))   ;; Returns 0
(newline)
(display (increment 0.5))  ;; Returns 1.5
(newline)



;;;; Step 1 - Primitive Data
;;;; ---------------------------------------------------

;; Answers:
;;  1:  Yes
;;  2:  No
;;  3:  Yes
;;  4:  Yes
;;  5:  Yes
;;  6:  Yes
;;  7:  Yes
;;  8:  No
;;  9:  No
;; 10:  No
;; 11:  Yes
;; 12:  No
;; 13:  No
;; 14:  No
;; 15:  No
;; 16:  No
;; 17:  Yes
;; 18:  No
;; 19:  No
;; 20:  Yes

;; Step 2 - Common Errors in Scheme
;;
;; 1. Unbound variable, bind fib to an operand so that it will do something
;; 2. Not using prefix notation, put the + in front followed by 1 and 2
;; 3. Has two arguments, square command uses one argument
;; 4. There is no 'then' command, so if it is any number other than 0, there is an error
;; 5.There is only one input (argument) and the command requires two
;; 6.It is missing the last parentheses
;;

;;;; Step 3 - Expressions
;;;; ---------------------------------------------------

;; Part A - Exercise 1.2
(display (/ (+ 4 5 (- 2 (- 3 (+ 6 (/ 4 5))))) (* 3 (- 6 2) (- 2 7))))
(newline)
;; Part B - Average of 13, 92, 3, 16
(display (/ (+ 13 92 3 16) 4))
(newline)


;;;; Step 4 - Abstracting Using Define
;;;; ---------------------------------------------------

;; Your Full Name  [myfullname]
(define myfullname "Adam Eickhoff")
(display myfullname)
(newline)
;; Your Lab Section  [mylabsection]
(define mylabsection "5")
(display mylabsection)
(newline)
;; Your Shorter Name  [myshortname]
(define myshortname "Adam")
(display myshortname)
(newline)
;; Expression From Step 3, Part B  [avg]
(define avg (/ (+ 13 92 3 16) 4))
(display avg)
(newline)
;; Rules for Naming Identifiers:
;;  Yes, there are keyboard characters that are not allowed in the names of identifiers ex: [], ""
;;  Must use quotations when defining something as a sentence
;;  No, some characters are not allowed in the middle of an identifier but not at the beginning
;;  We covered a fair amount of characters, but not all


;;;; Step 5 - Abstractions
;;;; ---------------------------------------------------

;; Do parts a through c at the Scheme interpreter prompt.

;; Answer to part d:
;; Yes, the old and new bindings can co-exist
;; 


;;;; Step 6 - Procedure Abstractions
;;;; ---------------------------------------------------

;; Cube Procedure:
(define (cube a) (* a a a))
;; Tests
(display (cube 2)) ;; Display 8
(newline)
(display (cube 3)) ;; Display 27
(newline)
;; We gave variable to cube, "a", then said multiply "a" by itself twice
;; Invert Procedure:
(define (invert x) (/ 1 x)) ;; Takes your input and puts it under 1

;; Test Cases:
(display (invert -2)) ;; Display 1/-2
(newline)
(display (invert 5)) ;; Display 1/5
(newline)



;;;; Step 7 - Larger Abstractions
;;;; ---------------------------------------------------

;; Positive Root Procedure  [quadpositive]
(define (quadpositive a b c) (/ (+ (- 0 b) (sqrt(- (* b b) (* 4 a c)))) (* 2 a)))
;; Negative Root Procedure  [quadnegative]
(define (quadnegative a b c) (/ (- (- 0 b) (sqrt(- (* b b) (* 4 a c)))) (* 2 a)))

;; What happens when taking the square roots of negative numbers?
;; Answer:  It returns with an imaginary number
;; 

;; Test Cases:
(display (quadpositive 1 5 2))
(newline)
(display (quadnegative 1 5 2))
(newline)
(display (quadnegative -1 -7 -2))
(newline)

;; What values can be successfully handled by the two procedures?
;; Answer:  The procedures can handle all real numbers except for 0 in the a term
;; 

;; What values CANNOT be successfully handled by the two procedures?
;; Answer:  The procedures cannot handle a 0 for the a term value
;; 



;;;; Step 8 - Procedures
;;;; ---------------------------------------------------

;; y=3x^2 - 8x - 3  [f]
(define (y x) (- (* 3 (* x x)) (* 8 x) 3)) ;; y=3x^2-8x-3
;; Test Cases:
(display (y 0))
(newline)
(display (y 5))
(newline)
(display (y 2))
(newline)

;; y=ax^2 - bx - c  [g]
(define (y a b c x) (- (* a (* x x)) (* b x) c)) ;; y=ax^2-bx-c
;; Test Cases:
(display (y 3 8 3 0))
(newline)
(display (y 5 1 2 9))
(newline)

;;;; Step 9 - Symbolism
;;;; ---------------------------------------------------

;; Define new bindings:


;; Modify original cube procedure:
(define cube1 cube)
(define cube2 cube)
(define (cube3 x) (* x x x))
(define (cube x) (+ (* x x x) 1))

;;Test cases
(display (cube 3))
(newline)
(display (cube1 3))
(newline)
(display (cube2 3))
(newline)
(display (cube3 3))
(newline)
;; How does this new definition affect the other three cube procedures?
;; Answer:  This new definition did not affect the other cube procedures because when you defined cube1 as cube, it set cube1 to (* x x x) because that is what cube was set to when we set the two procedures equal to each other.



