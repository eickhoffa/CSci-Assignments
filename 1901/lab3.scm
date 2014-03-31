;;;;    Author(s):  
;;;;                
;;;;  Lab Section:



;;; Utility Functions

;; Reloads the current file.
(define (reload)
  (load "lab3.scm")  ; Change file name if copied to a new file.
)


;;;; Example Procedure

;; Determines if a object is a positive negative integer or real.
;; Inputs:  object -- a numerical value
;; Output:  String with number type information.
;; Usage Example: (num_type 5.2)

(define (num_type object)
  (cond ((eq? 0 object) "Zero")
        ((integer? object)      ; True if integer, big int, 
                                ;   or floating point integer
          (if (positive? object)
            "Positive Integer"
            "Negative Integer"))
        ((real? object)          ; True for all other floating point values.
          (if (positive? object) 
            "Positive Floating Point Number"
            "Negative Floating Point Number"))
        (else "Not A Number")))  ; Object is not a numerical type.


;; Test Cases (Examples)
(newline)(newline)
(display "== Example Test Cases ==") (newline)
(display (num_type 5))     ; "Positive Integer"
(newline)
(display (num_type 5.0))   ; "Positive Integer"
(newline)
(display (num_type -2.3))  ; "Negative Floating Point Number"
(newline)




;;;; Step 1 - Conditional Statements
;; Returns the amount of tax per bracket
;; Inputs:  
;; Output:  
;; Usage Example: 
(define (tax x) (cond ((or (< x 35000) (= x 35000)) (* x .15)) ;;if income<=35000, calculates tax
                      ((and (> x 35000) (or (< x 100000) (= x 100000)) (> x 50000)) (+ (* 35000 .15) (* (- x 35000) .25) (* (- x 50000) .05))) ;;if 35000<income<100000 and less than 50000, calculates tax
                      ((and (> x 35000) (or (< x 100000) (= x 100000))) (+ (* 35000 .15) (* (- x 35000) .25))) ;;if  35000<income<100000, calculates tax
                      ((> x 100000) (+ (* 35000 .15) (* 65000 .25) (* (- x 50000) .05) (* (- x 100000) .35))) ;;if income>100000, calculates tax
                      (else "null")
))

;; Test Cases for Progressive Tax
(display "== Step 1 Test Cases ==") (newline)
(display (tax 10000)) (newline)  ; Expected Result: 1500
(display (tax 35000)) (newline)  ; Expected Result: 5250
(display (tax 45000)) (newline)  ; Expected Result: 7750
(display (tax 50000)) (newline)  ; Expected Result: 9000
(display (tax 75000)) (newline)  ; Expected Result: 16500
(display (tax 100000)) (newline) ; Expected Result: 24000
(display (tax 200000)) (newline) ; Expected Result: 64000



;;;; Step 2 - Normal vs. Applicative Order Evaluation
;; Part A Answer:  
;; It will return with 20 because it will not evaluate the second part of the problem.

;; Part B Answer:  
;; It will return with error because it will try to evaluate everything before returning an answer



;;;; Step 3 - Write a Procedure
;; isTriangle?
(define (istriangle? a b c)
   (cond ((and (> (+ a b) c) (> (+ b c) a) (> (+ a c) b)) "Is a triangle") ;;checks to see if valid triangle lengths
         (else (or (< (+ a b) c) (< (+ b c) a) (> (+ a c) b)) "Not a triangle"))) ;;checks to see if invalid triangle lengths

;; Test Cases for isTriangle?
(display "== Step 3 Test Cases ==") (newline)
(display (istriangle? 1 1 1))
(newline)
(display (istriangle? 1.51 3.0 1.51))
(newline)
(display (istriangle? 1 3 4))
(newline)

;;;; Step 4 - Logical Thinking
;; minimum1 -- return the smallest of 4 numbers
(display "== Step 4a Test Cases ==") (newline)
(define (minimum1 a b c d) (cond ((and (< a b) (< a c) (< a d)) a) ;;compares a to b, c, & d
                                 ((and (< b a) (< b c) (< b d)) b) ;;compares b to a, c, & d
                                 ((and (< c a) (< c b) (< c d)) c) ;;compares c to a, b, & d
                                 (else d))) ;;compares d to a, b, & c

;; Test Cases for minimum1
(display (minimum1 4 3 2 1)) (newline)
(display (minimum1 8 5 7 6)) (newline)
(display (minimum1 15 16 17 18)) (newline)
(display (minimum2 4 3 1 2)) (newline)

;; minimum2 -- return the smallest of 4 numbers (different algorithm)
(define (minimum2 a b c d) (if (< a b) a (if (< b c) b (if (< c d) c d))))

;; Test Cases for minimum2
(display "== Step 4b Test Cases ==") (newline)
(display (minimum2 4 3 2 1)) (newline)
(display (minimum2 8 5 7 6)) (newline)
(display (minimum2 15 16 17 18)) (newline)
(display (minimum2 4 3 1 2)) (newline)


;;;; Step 5 - Encapsulation

(define a 1000)

(define pi 3.1415926)            ; first pi

(define radius 2)                ; first radius

(define (area radius)            ; second radius
    (* pi radius radius))        ; second pi, third radius

(define (circumference radius)   ; fourth radius
    (define pi 3.1)              ; third pi
    (define (diameter radius)    ; fifth radius
        (* 2 radius))            ; sixth radius
    (* pi (diameter radius))     ; fourth pi, seventh radius
)

(define (volume radius)          ; eighth radius
    (define pi 3)                ; fifth pi
    (* pi radius radius radius)  ; sixth pi, ninth radius
)

;; Evaluate The Following By Hand First, Then Check In Interpreter.
;; a. (area 100)         =>  31415.926
;; b. (circumference 10) =>  62
;; c. (volume 1)         =>  3
;; d. (area radius)      =>  12.5663704
;; e. (circumference a)  =>  6200
;; f. (volume radius)    =>  24
;; g. In general, how will the above code be affected if the third pi line
;;    is deleted?
;;          When calculating circumference, it would have pi be 3.1415926 ins            tead of 3.1
;; h. In general, how will the above code be affected if "radius" is removed
;;    as a parameter of the diameter on the "fifth radius" line?
;;          It will not affect the code at all


;;;; Step 6 - Special Cases

(define (iffy predicate consequent alternative)
  (cond (predicate consequent)
        (else alternative)
  )
)

;;(if #t 4 (/ 2 0))
;;(iffy #t 4 (/ 2 0))

;; Answer The Following:
;; Using iffy in the same way you would use if:
;; a. When will it work, if ever?
;;         It will work when you are able to do the computations asked
;; b. When will it fail, if ever?
;;         It does not work when you are unable to do the computations asked
;; c. Is it really nessecary for if to be a special form?  Why?
;;         Yes, because that makes it so that the program only needs to perform the action IF and ONLY IF the if command is true.




