;; ====== LAB 8 ======
;;    Author(s):  
;;                
;;  Lab Section:  


;;;; Utility Functions

;; Reloads the current file.
(load "lab7new.scm") (newline)
(define (reload)
  (load "lab8.scm")  ; Change file name if copied to a new file.
)

;; Square
(define (square x) (* x x))


;;;; Test Case Values:
;;;;   These are to help simplify the test cases by reusing the lists.

;; Lists
(define test-list1 '(1 2 3 4 5 6 7 8 9))
(define test-list2 '(5))
(define test-list3 '(1 2))
(define test-list4 '())
(define test-list5 '(1 2 3 4))

;; Trees
(define test-tree1 '(1 (2 3) 4))
(define test-tree2 '((1 2 3 4)))
(define test-tree3 '(1 ((2) 3) (4)))
(define test-tree4 '((1 (2 (3 (4 (5)))))))
(define test-tree5 '(((((1) 2) 3) 4) 5))
(define test-tree6 '((((1 2) 3 4) 5 6) 7 8))


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
;;;; Step 1 - Skipping Over Elements
;;;;

;; get-tail
(define (get-tail lst x)
        (cond ((< x 0) "incompatible index")
              ((= x 0) lst)
              ((null? lst) "list not long enough")
              (else (get-tail (cdr lst) (- x 1)))))



;;=============;;
;;  Test Code  ;;
;;=============;;
(define test-cases-step-1 
 '(
    (get-tail test-list1 0)
    (get-tail test-list1 6)
    (get-tail test-list1 8)
    (get-tail test-list1 9)
    (get-tail test-list1 10)
    (get-tail test-list2 0)
    (get-tail test-list2 1)
    (get-tail test-list2 2)
    (get-tail test-list3 0)
    (get-tail test-list3 1)
    (get-tail test-list3 2)
    (get-tail test-list4 0)
    (get-tail test-list4 5)
    (get-tail test-list5 -1)
  ))

(do-tests 1)



;;;;
;;;; Step 2 - Yippy Skippy
;;;;

;; skip
(define (skip lst)
        (cond ((null? lst) "empty list")
              ((null? (cdr lst)) (car lst))
              (else (skip (cdr lst)))))



;;=============;;
;;  Test Code  ;;
;;=============;;
(define test-cases-step-2 
 '(
    (skip test-list1)
    (skip test-list2)
    (skip test-list3)
    (skip test-list4)
    (skip test-list5)
  ))

(do-tests 2)




;;;;
;;;; Step 3 - Reverse
;;;;

;; reverse
(define (reverse lst)
        (if (null? lst)
            '()
            (append (reverse (cdr lst)) (list (car lst)))))
              



;;=============;;
;;  Test Code  ;;
;;=============;;
(define test-cases-step-3 
 '(
    (reverse test-list1)
    (reverse test-list2)
    (reverse test-list3)
    (reverse test-list4)
    (reverse test-list5)
  ))

(do-tests 3)




;;;;
;;;; Step 4 - Accepting a Variable Number of Arguments
;;;;

;; getargs
(define (getargs . args)
        args)



;; howmanyargs?
(define (howmanyargs? . args)
        (define (helper args count)
                (if (null? args)
                    count
                    (if (pair? (car args))
                        (helper (cdr args) (+ count 1))
                        (helper (cdr args) count))))
        (helper args 0))


;;=============;;
;;  Test Code  ;;
;;=============;;
(define test-cases-step-4 
 '(
    (getargs)
    (getargs 1)
    (getargs 1 2)
    (getargs 1 2 3)
    (getargs 1 2 3 4)
    (getargs 1 (list 2 3) 4)

    (howmanyargs?)
    (howmanyargs? 1)
    (howmanyargs? (list 1))
    (howmanyargs? (list 1) 2)
    (howmanyargs? (cons 1 2) 3)
    (howmanyargs? (cons 1 2) (cons 3 4))
    (howmanyargs? (cons 1 2) (list 3 4))
    (howmanyargs? 1 (list 2 3) 4)
  ))

(do-tests 4)



;;;;
;;;; Step 5 - Mapping
;;;;

;; square-list using cons
(define (square-list-cons items)
  (if (null? items)
      '()
      (cons (square (get-first-point items)) (square-list-cons (get-rest-points items)))))


;; square-list using map
(define (square-list-map items)
  (map square items))



;;=============;;
;;  Test Code  ;;
;;=============;;
(define test-cases-step-5 
 '(
    (square-list-cons test-list1)
    (square-list-cons test-list2)
    (square-list-cons test-list3)
    (square-list-cons test-list4)
    (square-list-cons test-list5)
    (square-list-map test-list1)
    (square-list-map test-list2)
    (square-list-map test-list3)
    (square-list-map test-list4)
    (square-list-map test-list5)
  ))

(do-tests 5)




;;;;
;;;; Step 6 - Deep-Reverse
;;;;

;; deep-reverse
;(define (reverse lst)
 ;       (if (null? lst)
  ;          '()
   ;         (append (reverse (cdr lst)) (list (car lst)))))
(define (deep-reverse lst)
        (if (null? lst)
            '()
            (append (deep-reverse (cdr lst)) (list (if (list? (car lst))
                                                 (deep-reverse (car lst))
                                                 (car lst))))))


;;=============;;
;;  Test Code  ;;
;;=============;;
(define test-cases-step-6 
 '(
    (deep-reverse test-list1)
    (deep-reverse test-list2)
    (deep-reverse test-list3)
    (deep-reverse test-list4)
    (deep-reverse test-list5)
    (deep-reverse test-tree1)
    (deep-reverse test-tree2)
    (deep-reverse test-tree3)
    (deep-reverse test-tree4)
    (deep-reverse test-tree5)
    (deep-reverse test-tree6)
  ))

(do-tests 6)


;;;;
;;;; Step 7 - Using Accumulate
;;;;

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

;; map
(define (my-map proc sequence)
  (accumulate (lambda (x y) (cons (* x x) y)) () sequence))

;; append
(define (my-append seq1 seq2)
  (accumulate cons seq2 seq1))

;; length
(define (my-length sequence)
  (accumulate (lambda (x y) (+ y 1)) 0 sequence))

;;=============;;
;;  Test Code  ;;
;;=============;;
(define test-cases-step-7 
 '(
    (my-map square test-list4)
    (my-map square test-list2)
    (my-map square test-list3)
    (my-map square test-list5)

    (my-append test-list4 test-list5)
    (my-append test-list5 test-list4)
    (my-append test-list3 test-list3)
    (my-append test-list2 test-list3)

    (my-length test-list1)
    (my-length test-list2)
    (my-length test-list3)
    (my-length test-list4)
    (my-length test-list5)
    (my-length test-tree1)
    (my-length test-tree2)
    (my-length test-tree3)
  ))

(do-tests 7)

