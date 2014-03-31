;; ====== LAB 5 ====== 
;;    Author(s): 
;;                
;;  Lab Section: 


(define pi 3.14159265358979)
(define (inc x) (+ 1 x))
(define (factorial x)
        (if (= x 0)
            1
            (* x (factorial (- x 1)))))

;;;; Utility Functions

;; Reloads the current file.
(define (reload)
  (load "lab5.scm")  ; Change file name if copied to a new file.
)



;; REMINDER:
;;   You must include test cases for all procedures you write.
;;   Thoroughly test each procedure and be prepared to demonstrate that the code works as expected.


;;;;
;;;; Step 1 - Using the Sum Abstraction
;;;;

;; Sum Abstraction Procedure from Text
(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
	 (sum term (next a) next b))))

;; Test Code
(display "--- STEP 1 [PART A] TEST CASES ---") (newline)

(display "--- STEP 1 [PART B] TEST CASES ---") (newline)

(display "--- STEP 1 [PART C] TEST CASES ---") (newline)


;; Part A Answers:
;; 

;; Part B Answers:
;; 

;; Part C Answers:




;;;;
;;;; Step 2 - Writing the Product Abstraction
;;;;

;; Step 2 Helper Procedures
(define (find-pi a)  (* 1.0 (/ (* 2 a (* 2 (+ a 1))) (expt (+ 1 (* 2 a)) 2))))
  

;; 1.31 Recursive Solution for Product
(define (product term a next b)
        (if (> a b)
            1
            (* (term a) (product term (next a) next b))))



;; 1.31 Iterative Solution for Product
(define (product-i term a next b)
        (define (helper count total)
                (cond ((> count b) total)
                      (else (helper (next count) (* (term count) total)))))
(helper a 1))

;; Test Code
(display "--- STEP 2 [PART A - FACTORIAL] TEST CASES ---") (newline)
(display (product factorial 1 1+ 3)) (newline) ;;returns 12
(display (product factorial 2 1+ 5)) (newline) ;;returns 34560
(display (product factorial 3 1+ 7)) (newline) ;;returns 62705664000

(display "--- STEP 2 [PART A - PI] TEST CASES ---") (newline)
(display (* 4 (product find-pi 1 1+ 5))) (newline) ;;returns 3.275101041334807
(display (* 4 (product find-pi 1 1+ 8))) (newline) ;;returns 3.230036466411717
(display (* 4 (product find-pi 1 1+ 12))) (newline) ;;returns 3.2025773968946005

(display "--- STEP 2 [PART B - FACTORIAL] TEST CASES ---") (newline)
(display (product-i factorial 1 1+ 3)) (newline) ;;returns 12
(display (product-i factorial 2 1+ 5)) (newline) ;;returns 34560
(display (product-i factorial 3 1+ 7)) (newline) ;;returns 62705664000

(display "--- STEP 2 [PART B - PI] TEST CASES ---") (newline)
(display (* 4 (product-i find-pi 1 1+ 5))) (newline) ;;returns 3.275101041334807
(display (* 4 (product-i find-pi 1 1+ 8))) (newline) ;;returns 3.230036466411717
(display (* 4 (product-i find-pi 1 1+ 12))) (newline) ;;returns 3.2025773968946005

;;;;
;;;; Step 3 - Taking the Abstraction Further
;;;;
;; 1.32 Recursive Solution
(define (accumulate combiner null-value term a next b)
        (if (> a b)
            null-value
            (combiner (term a) (accumulate combiner null-value term (next a) next b))))

;; 1.32 Iterative Solution
(define (accumulate-i combiner null term a next b)
        (define (helper count total)
                (cond ((> count b) total)
                      (else (helper (next count) (combiner (term count) total)))))
        (helper a null))
        
;;(define (accumulate-i combiner null-value term a next b)
  ;;      (define (helper combiner a b)
    ;;            (if (= b a)
      ;;              null-value
        ;;            (combiner (term b) (helper combiner (next a) b))))
        ;;(helper combiner a b))



;; Test Code (newline)
(display "--- STEP 3 [PART A] TEST CASES ---") (newline)
(display (accumulate + 0 square 1 inc 2)) (newline) ;;returns 5
(display (accumulate * 1 square 1 inc 3)) (newline) ;;returns 36
(display (accumulate + 0 square 4 inc 6)) (newline) ;;returns 77

(display "--- STEP 3 [PART B] TEST CASES ---") (newline)
(display (accumulate-i + 0 square 1 inc 2)) (newline) ;;returns 5
(display (accumulate-i * 1 square 1 inc 3)) (newline) ;;returns 36
(display (accumulate-i + 0 square 4 inc 6)) (newline) ;;returns 77



;;;;
;;;; Step 4 - Compound Procedure 
;;;;

;; 1.42 Solution
(define (compose f g)
        (lambda (x) (f (g x))))


;; Test Code
(display "--- STEP 4 TEST CASES ---") (newline)
(display ((compose square inc) 6)) (newline) ;;returns 49
(display ((compose factorial inc) 3)) (newline) ;;returns 24
(display ((compose square factorial) 3)) (newline) ;;returns 36

;;;;
;;;; Step 5 - Estimating Cosine x
;;;;
(define (cos n)
        (if (= n 0)   ;;if n=0, returns with 1
            1
            (+ (* (/ (expt -1 n) (factorial (* 2 n))) (expt (/ pi 3) (* 2 n))) (cos (- n 1)))))  ;;else recalls cos with (n-1)


;; Test Code
(display "--- STEP 5 TEST CASES ---") (newline)
(display (cos 5)) (newline)   ;;returns .499999996390944
(display (cos 8)) (newline)   ;;returns .5000000000000012
(display (cos 12)) (newline)  ;;returns .5000000000000009