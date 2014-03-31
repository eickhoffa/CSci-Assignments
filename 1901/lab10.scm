#| ====== LAB 10 ====== 
 |
 |    Author(s):  Daniel Goodman & Adam Eickhoff
 |  Lab Section: 5
 |  
 |#


;;;; Utility Functions

;; Reloads the current file.
(define (reload)
  (load "lab10.scm")  ; Change file name if copied to a new file.
)

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



;; Square
(define (square x) (* x x))

; Tagged data code from text page 176

(define (attach-tag type-tag contents)
  (cons type-tag contents))

(define (type-tag datum)
  (if (pair? datum)
      (car datum)
      (error "Bad typed datum -- TYPE")))

(define (contents datum)
  (if (pair? datum)
      (cdr datum)       
      (error "Bad typed datum -- CONTENTS")))       

; Two-Dimensional Table code Modified from Text Section 3.3

(define (2d-get key-1 key-2 table)
          (let ((subtable (assoc key-1 (cdr table))))
            (if subtable
                (let ((record (assoc key-2 (cdr subtable))))
                  (if record
                      (cdr record)
                      ()))
                ())))

(define (2d-put! key-1 key-2 value table)
          (let ((subtable (assoc key-1 (cdr table))))
            (if subtable
                (let ((record (assoc key-2 (cdr subtable))))
                  (if record
                      (set-cdr! record value)
                      (set-cdr! subtable
                                (cons (cons key-2 value)
                                      (cdr subtable)))))
                (set-cdr! table
                          (cons (list key-1
                                      (cons key-2 value))
                                (cdr table)))))
          'ok)

(define (make-table)
          (list '*table*))

; Generic operator analagous to more general apply-generic from page 184
; in the text.  Uses a specified table to be compatible with 2dtable.scm 
; for systems that do not include tables by default

(define (operate op obj t)
    (let ((proc (2d-get op (type-tag obj) t)))
        (if (not (null? proc))
            (proc (contents obj))
            (error "undefined operator for this type")
        )
    )
)  


;;;;;(type-tag obj)


;; Main Table for Data Directed Programming
(define T (make-table))

;; REMINDER:
;;   You must include test cases for all procedures you write.
;;   No credit will be given without test cases showing working code.
;;   
;;   Be prepared to demonstrate that the code works as expected.


;;;;
;;;; Step 1 - Writing a Temperature Package for Fahrenheit Temperatures
;;;;

(define (install-F-package)

  (define (make-from-F value)
    (attach-tag 'F value)
  )

  (define (make-from-C value)
    (attach-tag 'F
	  (+ (* value 1.8) 32))
  )

  (define (make-from-K value)
    (attach-tag 'F
	  (+ (* (- value 273.15) 1.8) 32))
  )

  (define (get-F value)
    value
  )

  (define (get-C value)
    (/ (- value 32) 1.8)
  )

  (define (get-K value)
    (+ (/ (- value 32) 1.8) 273.15)
  )

(2d-put! 'make-from-F 'F make-from-F T)
(2d-put! 'make-from-C 'F make-from-C T)
(2d-put! 'make-from-K 'F make-from-K T)
(2d-put! 'get-F 'F get-F T)
(2d-put! 'get-C 'F get-C T)
(2d-put! 'get-K 'F get-K T)

  ; Here insert all the above procedures into the 2D table T with
  ; appropriate labels - key 1 should be the procedure name and
  ; key 2 should be the type (for example: 'F). 

  ; Return value
  'done
)



;;;;
;;;; Step 2 - Writing a Temperature Package for Celsius and Kelvin Representations
;;;;

(define (install-C-package)

 (define (make-from-C value)
    (attach-tag 'C value)
  )

  (define (make-from-F value)
    (attach-tag 'C
		(/ (- value 32) 1.8))
    )

  (define (make-from-K value)
    (attach-tag 'C
	  (- value 273.15))
  )

  (define (get-C value)
    value
  )

  (define (get-F value)
    (+ (* value 1.8) 32)
  )

  (define (get-K value)
    (+ value 273.15)
  )

(2d-put! 'make-from-F 'C make-from-F T)
(2d-put! 'make-from-C 'C make-from-C T)
(2d-put! 'make-from-K 'C make-from-K T)
(2d-put! 'get-F 'C get-F T)
(2d-put! 'get-C 'C get-C T)
(2d-put! 'get-K 'C get-K T)

  ;; Here insert all the above procedures into the 2D table T with
  ;; appropriate labels - key 1 should be the procedure name and
  ;; key 2 should be the type (for example: 'C).
  
  
 ;; Return value
  'done
  )

(define (install-K-package)

 (define (make-from-K value)
    (attach-tag 'K value)
  )

  (define (make-from-F value)
    (attach-tag 'K
	  (+ (/ (- value 32) 1.8) 273.15))
    )

  (define (make-from-C value)
    (attach-tag 'K
	  (+ value 273.15))
  )

  (define (get-K value)
    value
  )

  (define (get-F value)
    (+ (* (- value 273.15) 1.8) 32)
  )

  (define (get-C value)
    (- value 273.15)
  )

(2d-put! 'make-from-F 'K make-from-F T)
(2d-put! 'make-from-C 'K make-from-C T)
(2d-put! 'make-from-K 'K make-from-K T)
(2d-put! 'get-F 'K get-F T)
(2d-put! 'get-C 'K get-C T)
(2d-put! 'get-K 'K get-K T)

  ;; Define all of the same procedures, but for the Kelvin
  ;; representation

  ;; Here insert all the above procedures into the 2D table T with
  ;; appropriate labels - key 1 should be the procedure name and
  ;; key 2 should be the type (for example: 'K).
  
  
  ; Return value
  'done
  )


;;;;
;;;; Step 3 - Generic Temperature Operations and Installation
;;;;

;(operate op obj t) - Applies the correct version of an operation (stored                        in the table) that corelates to the object type. 

(define (make-F-from-F value)
  (operate 'make-from-F (attach-tag 'F value) T)
)

(define (make-F-from-C value)
  (operate 'make-from-C (attach-tag 'F value) T)
)

(define (make-F-from-K value)
  (operate 'make-from-K (attach-tag 'F value) T)
)

(define (make-C-from-F value)
  (operate 'make-from-F (attach-tag 'C value) T)
)

(define (make-C-from-C value)
  (operate 'make-from-C (attach-tag 'C value) T)
)

(define (make-C-from-K value)
  (operate 'make-from-K (attach-tag 'C value) T)
)

(define (make-K-from-F value)
  (operate 'make-from-F (attach-tag 'K value) T)
)
(define (make-K-from-C value)
  (operate 'make-from-C (attach-tag 'K value) T)
)

(define (make-K-from-K value)
  (operate 'make-from-K (attach-tag 'K value) T)
)
(define (get-F temp-object)
(if (procedure? temp-object)
    (temp-object 'get-F)
  (operate 'get-F temp-object T))
)

(define (get-C temp-object)
(if (procedure? temp-object)
    (temp-object 'get-C)
  (operate 'get-C temp-object T))
)

(define (get-K temp-object)
(if (procedure? temp-object)
    (temp-object 'get-K)
  (operate 'get-K temp-object T))
)


;; Test Code for Steps 1-3:
(newline)
(display "=== TEST CASES [Steps 1-3] ===") (newline)

;; Install Packages as Shown in Lab Write-Up
(display "------ Install Packages ------") (newline)
(install-F-package)
(install-C-package)
(install-K-package)

(display "------ Created Objects and Test Cases ------")
(newline)
(define test-cases-step-3
 '(
   (define a (make-F-from-F 212)) ;212
   (define b (make-F-from-C 100))    ;212
   (define c (make-F-from-K 373.15))  ;212
   (define d (make-C-from-F 212))    ;100
   (define e (make-C-from-C 100))       ;100
   (define f (make-C-from-K 373.15))     ;100
   (define g (make-K-from-F 212))     ;373.15
   (define h (make-K-from-C 100))        ;373.15
   (define i (make-K-from-K 373.15))      ;373.15

   (get-F a) ;212
   (get-F b) ;212
   (get-F c) ;212
   (get-C a)    ;100
   (get-C b)    ;100
   (get-C c)    ;100
   (get-K a)     ;373.15
   (get-K b)     ;373.15
   (get-K c)     ;373.15

   (get-F d) ;212
   (get-F e) ;212
   (get-F f) ;212
   (get-C d)    ;100
   (get-C e)    ;100
   (get-C f)    ;100
   (get-K d)     ;373.15
   (get-K e)     ;373.15
   (get-K f)     ;373.15

   (get-F g) ;212
   (get-F h) ;212
   (get-F i) ;212
   (get-C g)    ;100
   (get-C h)    ;100
   (get-C i)    ;100
   (get-K g)     ;373.15
   (get-K h)     ;373.15
   (get-K i)     ;373.15

 ))

(do-tests 3)


;;;;
;;;; Step 4 - Hot, Cool, Cold?
;;;;

(define (closest-temp-category temp temp-list)
        (define (helper x)
                (cond ((<= x 5) 'freezing)
                      ((<= x 15) 'cool)
                      ((<= x 25) 'warm)
                      (else 'hot)))
(if (procedure? temp)
    (helper (temp 'get-c))
        (cond ((equal? (car temp) 'f) (let ((x (contents (make-C-from-F (cdr temp)))))
                                           (helper x)))
	            ((equal? (car temp) 'c) (let ((x (contents temp)))
                                            (helper x)))
	            ((equal? (car temp) 'k) (let ((x (contents (make-C-from-K (cdr temp)))))
                                           (helper x))))))
	      




(display "=== TEST CASES [STEP 4] ===") (newline)

  (define temp-list '(((C . 0) . freezing)
                      ((C . 10) . cool) 
                      ((C . 20) . warm)
                      ((C . 30) . hot)))

  (define t1 (make-F-from-F 100)) 
  (define t2 (make-C-from-F 30)) 
  (define t3 (make-K-from-C 15)) 
  (define t4 (make-F-from-K 290)) 
  (define t5 (make-C-from-K 320)) 
    
(define test-cases-step-4
 '(
  (closest-temp-category t1 temp-list) ; hot
  (closest-temp-category t2 temp-list) ; freezing
  (closest-temp-category t3 temp-list) ; cool
  (closest-temp-category t4 temp-list) ; warm
  (closest-temp-category t5 temp-list) ; hot
  ))

(do-tests 4)

;;;;
;;; Step 5 - An Intelligent Upgrade
;;;;

;; Part A
(define (make-mp-from-F value)
  (define f (attach-tag 'F value))
  (define (f-dispatch op)
    (cond
      ((eq? op 'get-C) (operate 'get-C f T))
      ((eq? op 'get-K) (operate 'get-K f T))
      ((eq? op 'get-F) (operate 'get-F f T))
      (else (error "Unknown op -- make-mp-from-F"))
    )
  )
  f-dispatch
)
 
(define (make-mp-from-C value)
  (define f (attach-tag 'C value))
  (define (c-dispatch op)
    (cond
      ((eq? op 'get-C) (operate 'get-C f T))
      ((eq? op 'get-K) (operate 'get-K f T))
      ((eq? op 'get-F) (operate 'get-F f T))
      (else (error "Unknown op -- make-mp-from-C"))
    )
  )
  c-dispatch
)

;; Part B: Now modify your procedures in part 3 to handle the 
;;         message passing representation as well. The two
;;         representation should be able to coexist.

;; Part C:
;; Answer
;; Yes, I had to go through and edit the functions from step 3 and 4.
;; 

(display "--- STEP 5 TEST CASE ---") (newline)
(define j (make-mp-from-F 212))
(define k (make-mp-from-C 100))
(define t6 (make-mp-from-F 100)) 
(define t7 (make-mp-from-F 30)) 
(define t8 (make-mp-from-C 15)) 
(define t9 (make-mp-from-C 16)) 

(define test-cases-step-5
 '(
    (get-F a) ; 212
    (get-F j) ; 212
    (get-F k) ; 212
    (get-C a)    ; 100
    (get-C j)    ; 100
    (get-C k)    ; 100
    (get-K a)     ; 373.15
    (get-K j)     ; 373.15
    (get-K k)     ; 373.15

    (closest-temp-category t6 temp-list) ; hot
    (closest-temp-category t7 temp-list) ; freezing
    (closest-temp-category t8 temp-list) ; cool
    (closest-temp-category t9 temp-list) ; warm
))



(do-tests 5)
