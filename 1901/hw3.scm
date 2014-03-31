;;;;CSci 1901 Spring 2012
;;;;HW 3
; =========
;;;;Author:      Adam Eickhoff
;;;;ID #:        4088090
;;;;Lab Section: 5? (Thursday 2:30-4:20)


;; Note: Answers to some test cases are given below. For those test
;; cases not having given answers, you should check your code result
;; against what you get when you evaluate the problem manually.
;; If there are no test cases, be sure to write some.

;;; Utility Functions

;; Reloads the current file.
(define (reload)
  (load "hw3.scm")  ; Change file name if copied to a new file.
)
(newline)

;; map, etc. from Section 2.2 in text. Used in Problem 3
(define (map proc items)
   (if (null? items)
       '()
       (cons (proc (car items))
             (map proc (cdr items)))))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (filter predicate sequence)
   (cond ((null? sequence) '())
         ((predicate (car sequence))
          (cons (car sequence)
                (filter predicate (cdr sequence))))
         (else (filter  predicate (cdr sequence)))))
       
;; other functions
(define (identity x) x)
(define (square x) (* x x))
(define (cube x) (* x x x))


;=== Problem 1 ===
;Manipulating Lists
(define (mode lst)
   (define (helper dwnlst current maxcount count)
                   (cond ((null? dwnlst) current)                                                      ;if lst is empty, returns current
                         ((> count maxcount) (helper (cdr dwnlst) (car dwnlst) 0 0))                   ;if count>maxcount, changes the mode to new #
                         ((= current (car dwnlst)) (helper (cdr dwnlst) current (+ 1 maxcount) count)) ;if car lst = current mode, adds 1 to maxcount
                         (else (helper (cdr dwnlst) current maxcount (+ 1 count)))))                   ;else adds 1 to count
   (helper lst 0 0 0))



(define (greatsum x)  ;;finds sum of the lists
        (if (null? x)
            0
            (+ (car x) (greatsum (cdr x)))))

(define (greatest-sum lst1 lst2)
        (cond ((null? lst1) (greatsum lst2))                        ;if lst1 is null, returns with sum of lst2
              ((null? lst2) (greatsum lst1))                        ;if lst2 is null, returns with sum of lst1
              ((> (greatsum lst1) (greatsum lst2)) (greatsum lst1)) ;if sum of lst1 is > lst2, returns lst1 sum
              ((> (greatsum lst2) (greatsum lst1)) (greatsum lst2)) ;if sum of lst2 is > lst1, returns lst2 sum
              ((= (greatsum lst1) (greatsum lst2)) "equal")         ;if sum is equal, returns 'equal'
              (else "invalid inputs")))                             ;else invalid inputs
              

;TEST CASES
(display "Problem 1a")(newline)
(display (mode '(1 2 2 3 3 3 4))) (newline) ;; 3
(display (mode '(1 2 2))) (newline) ;; 2
(display (mode '())) (newline) ;; ()

(display "Problem 1b")(newline)
(display (greatest-sum '(1 2 3) '(4 5 6))) (newline) ;; 15
(display (greatest-sum '(1 2 3) '(1 2 3))) (newline) ;; "equal"
(display (greatest-sum '(1 2 3) '())) (newline) ;; 6


;=== Problem 2 ===
;CONVERT-TO-SORTED-PT-LIST
(define (distance p1 p2)
  (sqrt (+ (square (- (car p2) (car p1)))
	   (square (- (cdr p2) (cdr p1))))))
(define origin (cons 0 0))

(define (make-sorted-pt-list p pt-list)
  (if (null? pt-list)
      (cons p pt-list)
      (if (> (distance p origin) (distance (car pt-list) origin))
	  (cons (car pt-list) 
			(make-sorted-pt-list p (cdr pt-list)));(cons pt-list p)
	  (cons p pt-list))))
     
(define (convert-to-sorted-pt-list pt-list)
        (define (helper pt-list new-list)
                (cond ((null? pt-list) new-list)                                                   ;if pt-list is null, returns empty list
                      ((null? new-list) (helper (cdr pt-list) (cons (car pt-list) new-list)))      ;if new-list is null, starts new-list with first pt in pt-list
                      (else (helper (cdr pt-list) (make-sorted-pt-list (car pt-list) new-list))))) ;else calls make-sorted-pt-list
        (helper pt-list '()))

     


;TEST CASES
(display "Problem Iterative Test Cases (Problem 2)")(newline)
(display (convert-to-sorted-pt-list '((5 . 5) (3 . 3) (1 . 1) (2 . 2)))) (newline) ;((1 . 1) (2 . 2) (3 . 3) (5 . 5)
(display (convert-to-sorted-pt-list '((2 . 2) (1 . 1)))) (newline) ;((1 . 1) (2 . 2))
(display (convert-to-sorted-pt-list '((1 . 1) (2 . 2) (3 . 3)))) (newline) ;((1 . 1) (2 . 2) (3 . 3))
(display (convert-to-sorted-pt-list '())) (newline) ;()


;=== Problem 3 ===
; Using Existing Functions with Lists
; MAP, ACCUMULATE, etc.
; In each of the following, fill in the procedure body using sum,
; filter, and/or accumulate.

; 3a
(define (f3a items)
        (map (lambda (x) (filter number? x)) items)
)

; 3b
(define (f3b items)
        (map (lambda (x) (map (lambda (y) (cond ((and (number? y) (negative? y)) (square y))
                                    (else y))) x)) items))

; 3c
(define (f3c items)
        (map (lambda (x) (if (and (number? (car x)) (number? (cadr x)))
                             (list (+ (car x) (cadr x)))
                             x)) items))

; TEST CASES
(display "Problem 3")(newline) 
(display (f3a '(("sdas" 89) (239 10) ("asd" "asda") (1238 .12) (-53 "sad")))) (newline)
; should return ((89) (239 10) () (1238 .12) (-53))
(display (f3b '(("sdas" 89) (-53 "sad")))) (newline)
; should return (("sdas" 89) (2809 "sad"))
(display (f3c '(("sdas" 89) (239 10) (1238 .12)))) (newline)
; should return (("sdas" 89) (249) (1238.12))


;=== Problem 4 ===
; Refactoring Lists
(define (convert-grades gradebook)
        (define (helper final gradebook)
                (cond ((null? gradebook) '())  ;;if null, returns empty list
                      ((and (number? (car gradebook)) (negative? (car gradebook))) (cons final (helper final (cdr gradebook)))) ;;if number and negative, starts new list
                      ((string? (car gradebook)) (helper (list (car gradebook)) (cdr gradebook)))  ;;if a string, begins that new list
                      ((number? (car gradebook)) (helper (append final (list (car gradebook))) (cdr gradebook)))  ;;if number, adds to the list
                      (else (helper final (cdr gradebook)))))  ;;else recalls helper
        (helper '() gradebook))


(define (average lst) ;;sums numbers in a list
        (if (null? lst)
            '()
            (/ (greatsum lst) (length lst))))

(define (get-student-final-grade name gradebook)
        (if (null? gradebook) ;;if null, returns empty list
            '()
            (if (string=? name (caar gradebook))  ;;if name=gradebook name, averages that list of numbers
                (average (cdar gradebook))
                (get-student-final-grade name (cdr gradebook)))))  ;;else looks at next name

;TEST CASES
(display "Problem 4a")(newline) 
(define gradebook1 '("Ben Anderson" 95 90 100 -1 "Mary Johnson" 75 78 79 -5 "Michael Walter" 80 68 0 -2))
(define gradebook4 '("Adam Eickhoff" 90 91 85 -1 "Jones James" 10 22 78 -5 "Kyle Eckstrom" 100 98 48 -2))

(display (convert-grades gradebook1)) (newline)
(display (convert-grades gradebook4)) (newline)

(display "Problem 4b")(newline) 
(define gradebook2 (convert-grades gradebook1))
(define gradebook3 (convert-grades gradebook4))
(display (get-student-final-grade "Ben Anderson" gradebook2)) (newline)
(display (get-student-final-grade "Kyle Eckstrom" gradebook3)) (newline)




