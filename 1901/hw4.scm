;;;;CSci 1901 Spring 2012
;;;;HW 4
; =========
;;;;Author:          Adam Eickhoff
;;;;ID #:            4088090
;;;;Lab Section:     5


;; Note: Answers to some test cases are given below. For those test
;; cases not having given answers, you should check your code result
;; against what you get when you evaluate the problem manually.


;; Reloads the current file.
(define (reload)
  (load "hw4.scm")  ; Change file name if copied to a new file.
)
(newline)



;=== Problem 1 ===
(define (compute-frequencies looking-for-list pool-list)
        (define (helper count lfl pl final)
                (cond ((null? lfl) (reverse final))                                             ;if lfl is null, returns final
                      ((null? pl) (helper 0 (cdr lfl) pool-list (append (list count) final)))   ;if pl is null, cdr's down lfl, resets pl
                      ((eq? (car lfl) (car pl)) (helper (+ 1 count) lfl (cdr pl) final))        ;if car's = each other, adds 1 to count and cdr's pl
                      ((member (car lfl) pl) (helper count lfl (cdr pl) final))                 ;if car is a member of pl, cdr's down pl
                      (else (helper 0 (cdr lfl) pool-list (append (list count) final)))))       ;else recalls helper with cdr of lfl and resets pl
        (helper 0 looking-for-list pool-list '()))


; Problem 1 test cases
(define a '(1 2 1 2 1))
(define b '(4 4 3 1))
(define z '(1 4 9 1 2 0 1 4 9 2 3 5 1 2))
(define c (list 'green 'green 'green 'gray 'blue 'green 'gray 'green))
(define d (list 'green 'blue 'red))
(display "Problem 1")(newline)
(display (compute-frequencies a b))(newline) ; should return (1 0 1 0 1)
(display (compute-frequencies b a))(newline) ; should return (0 0 0 3)
(display (compute-frequencies c d))(newline) ; shoul return (1 1 1 0 1 1 0 1)

;; Write two additional test cases
(display (compute-frequencies d c))(newline) ;should return (5 1 0)
(display (compute-frequencies b z))(newline) ;should return (2 2 1 4)


;=== Problem 2 ===
; 2a
(define (superset? a b)                               
   (cond ((null? b) #t)                               ;if b is null, returns true
         ((member (car b) a) (superset? a (cdr b)))   ;checks if car of b is a member of a, then recalls
         (else #f))                                   ;else returns false
)

; 2b
(define (set-product a b)
   (define (helper na nb final)                                                                      ;defines helper with 3 inputs
           (cond ((null? na) final)                                                                  ;if new-a is null, returns final
                 ((null? nb) (helper (cdr na) b final))                                              ;if new-b is null, recalls helper cdr-ing down a
                 ((list? nb) (helper na (cdr nb) (append final (list (cons (car na) (car nb))))))    ;if new-b is a list, appends & cons' the car's
                 (else (helper (cdr na) b final))))                                                  ;else recalls helper, cdr-ing down a
   (helper a b '())
)


; Problem 2 Test Cases
(define a (list  1 8 2))
(define b (list  1 2 10 8 9))
(define c (list 2 3 5 7 11 13 17 19))
(define d (list 'apple 'orange 'kumquat))
(define e (list 'theorbo 'lute))
(define f (list 'sifakis 'emerson 'clarke 'liskov 'thacker))


(display "Problem 2a")(newline)
(display (superset? b a))(newline) ; should return true
(display (superset? c a))(newline) ; should return false
(display (superset? a '()))(newline) ;should return true
(display (superset?  e (list 'lute)))(newline) ;should return true

;; Write two additional test cases
(display (superset? a b))(newline) ;should return false
(display (superset? e a))(newline) ;should return false

(display "Problem 2b")(newline)
(display (set-product a b))(newline)(newline)
; should return
; ((1 . 1) (1 . 2) (1 . 10) (1 . 8) (1 . 9) 
;  (8 . 1) (8 . 2) (8 . 10) (8 . 8) (8 . 9) 
;  (2 . 1) (2 . 2) (2 . 10) (2 . 8) (2 . 9))

(display (set-product d e))(newline)(newline)
;should return
;  ((apple . theorbo)(apple . lute)(orange . theorbo)(orange . lute)
;   (kumquat . theorbo)(kumquat . lute))

(display (set-product e e))(newline)(newline)
; should return
; ((theorbo . theorbo) (theorbo . lute) (lute . theorbo) (lute . lute))

(display (set-product e f))(newline)(newline)
;should return
; ((theorbo . sifakis)(theorbo . emerson)(theorbo . clarke)(theorbo . liskov)(theorbo. thacker)(lute . sifakis)(lute . emerson)(lute . clarke)(lute . liskov)
;  (lute . thacker)

;; Write two additional test cases
(display (set-product a d))(newline)(newline)
;should return
; ((1 . apple)(1 . orange)(1 . kumquat)(8 . apple)(8 . orange)(8 . kumquat)
;  (2 . apple)(2 . orange)(2 . kumquat))

(display (set-product b e))(newline)
;should return
; ((1 . theorbo)(1 . lute)(2 . theorbo)(2 . lute)(10 . theorbo)(10 . lute)
;  (8 . theorbo)(8 . lute)(9 . theorbo)(9 . lute))
