;;;;CSci 1901 Spring 2012
;;;; HW 2
; ========
;;;;Author:  Adam Eickhoff
;;;;ID #:    4088090
;;;;Lab Section: 05

;; NOTE: ANSWERS TO SOME TEST CASES ARE GIVEN BELOW. FOR THOSE TEST
;; CASES NOT HAVING GIVEN ANSWERS, YOU SHOULD CHECK YOUR CODE RESULT
;; AGAINST WHAT YOU GET WHEN YOU EVALUATE THE PROBLEM MANUALLY AND FILL
;; IN THE EXPECTED RESULT.


;;; Utility Functions

;; Reloads the current file.
(define (reload)
  (load "hw2.scm")  ; Change file name if copied to a new file.
)
(newline)

;=== PROBLEM 1 ===
; PROBLEM 1a Solution for recursive process
(define (roman-numeral n)
        (if (= n 0)
            " "
            (cond ((>= n 1000) (string-append "M" (roman-numeral (- n 1000)))) ;if n>=1000, adds M
                  ((>= n 900) (string-append "CM" (roman-numeral (- n 900))))  ;if n>=900, adds CM
                  ((>= n 500) (string-append "D" (roman-numeral (- n 500))))  ;if n>=500, adds D
                  ((>= n 400) (string-append "CD" (roman-numeral (- n 400))))  ;if n>=400, adds CD
                  ((>= n 100) (string-append "C" (roman-numeral (- n 100))))  ;if n>=100, adds C
                  ((>= n 90) (string-append "XC" (roman-numeral (- n 90))))  ;if n>=90, adds XC
                  ((>= n 50) (string-append "L" (roman-numeral (- n 50))))  ;if n>=50, adds L
                  ((>= n 40) (string-append "XL" (roman-numeral (- n 40))))  ;if n>=40, adds CL
                  ((>= n 10) (string-append "X" (roman-numeral (- n 10))))  ;if n>=10, adds X
                  ((>= n 9) (string-append "IX" (roman-numeral (- n 9))))  ;if n>=9, adds IX
                  ((>= n 5) (string-append "V" (roman-numeral (- n 5))))  ;if n>=5, adds V
                  ((> n 0) (string-append "I" (roman-numeral (- n 1)))))  ;if n>0, adds I
))

; Test cases for (Problem 1a)
(display "Problem 1a Test Cases")(newline)
(display (roman-numeral 10))(newline)  ; should return X
(display (roman-numeral 8))(newline)  ; should return VIII
(display (roman-numeral 2011))(newline)  ; should return MMXI
(display (roman-numeral 1598))(newline)  ; should return MDXCVIII
(display (roman-numeral 100)) (newline)  ;returns C
(display (roman-numeral 2500)) (newline)  ;returns MMD


; PROBLEM 1b Solution for iterative process
(define (roman-numeral n)
        (define temp "")
        (if (= n 0)
            temp
            (cond ((>= n 1000) (string-append temp "M" (roman-numeral (- n 1000))))  ;;if n>=1000, adds M
                      ((>= n 900) (string-append temp "CM" (roman-numeral (- n 900))))  ;;if n>=900, adds CM
                      ((>= n 500) (string-append temp "D" (roman-numeral (- n 500))))  ;;if n>=500, adds D
                      ((>= n 400) (string-append temp "CD" (roman-numeral (- n 400))))  ;;if n>=400, adds CD
                      ((>= n 100) (string-append temp "C" (roman-numeral (- n 100))))  ;;if n>= 100, adds C
                      ((>= n 90) (string-append temp "XC" (roman-numeral (- n 90))))  ;;if n>= 90, adds XC
                      ((>= n 50) (string-append temp "L" (roman-numeral (- n 50))))  ;;if n>=50, adds L
                      ((>= n 40) (string-append temp "XC" (roman-numeral (- n 40))))  ;;if n>=40, adds CL
                      ((>= n 10) (string-append temp "X" (roman-numeral (- n 10))))  ;;if n>=10, adds X
                      ((>= n 9) (string-append temp "IX" (roman-numeral (- n 9))))  ;;if n>=9, adds IX
                      ((>= n 5) (string-append temp "V" (roman-numeral (- n 5))))  ;;if n>=5, adds V
                      ((>= n 0) (string-append temp "I" (roman-numeral (- n 1)))))  ;;if n>0, adds I
))


; Test cases for (1b)
(display "Problem 1b Test Cases")(newline)
(display (roman-numeral 10))(newline)  ; should return X
(display (roman-numeral 8))(newline)  ; should return VIII
(display (roman-numeral 2011))(newline)  ; should return MMXI
(display (roman-numeral 1598))(newline)  ; should return MDXCVIII
(display (roman-numeral 100)) (newline)  ;returns C
(display (roman-numeral 2500)) (newline)  ;returns MMD


;=== PROBLEM 2 ===
;
; Problem 2 procedures for test cases.
(define (visits n)
   (cond ((= n 10)  20)
         ((= n 18)  18)
         ((= n 39)  52)
         ((= n 52)  12)
         ((= n 78)  23)
         ((= n 88)  34)
         ((= n 103) 18)
         ((= n 111) 11)
         ((= n 126) 33)
         (else 0)))

(define (visits-2 n)
   (cond ((= n 8)   12)
         ((= n 19)   8)    
         ((= n 21)   4)
         ((= n 22)  11)
         ((= n 34)  22)
         ((= n 48)  10)
         ((= n 88)  10)
         ((= n 89)   3)
         ((= n 102) 18)
         ((= n 110) 21)
         ((= n 128)  8)
         (else 0)))


; PROBLEM 2 Solution for procedure as parameter
                
(define (avg-visits f a b)
(define (num-visitors f a b) ;;helper function
  (if (> a b) ;;base case
      0
      (+ (f a) ;;add f of a
      (num-visitors f (+ a 1) b)))) ;;recalls num-visitors with a+1
(define (visitor-count f a b) ;;second helper function
  (if (> a b)
      0 ;;base case for second helper
      (if (> (f a) 0)
      (+ 1 (visitor-count f (+ a 1) b)) ;;add 1 to visit count
      (visitor-count f (+ a 1) b)))) ;;else try again with a+1
(if (> (visitor-count f a b) 0) ;;if visitor-count is>0 does (num-vis/vis-count)
    (/ (num-visitors f a b) (visitor-count f a b)) ;;divide num-vis by vis-count
    (/ (num-visitors f a b) 1))) ;;else divide by one

        

; Problem 2 test cases:
(display "Problem 2 Test Cases")(newline)
(display (avg-visits visits  19 78))(newline)    ; should return 29
(display (avg-visits visits  1 21))(newline)     ; should return 19
(display (avg-visits visits  89 101))(newline)   ; should return 0
(display (avg-visits visits-2  19 78))(newline)  ; should return 11 
(display (avg-visits visits-2  1 21))(newline)   ; should return 8
(display (avg-visits visits-2  89 101))(newline) ; should return 3



; PROBLEM 3 Solution for procedure as return value
(define (gen-poly a b c)
        (lambda (x) (+ (* a (* x x)) (* b x) c))  ;;inputs a,b,c & x and calculates lambda
)

; Problem 3 test cases
(display "Problem 3 Test Cases")(newline)     
(define test-poly (gen-poly 1 1 1))
(display (test-poly 1)) (newline) ;returns 3
(display (test-poly 3)) (newline) ;returns 13
(display (test-poly 5)) (newline) ;returns 31
(display (test-poly 7)) (newline) ;returns 57
;; Write 3 additional test cases












