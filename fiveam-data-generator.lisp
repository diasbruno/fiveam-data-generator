(defpackage #:fiveam-data-generator
  (:use #:cl)
  (:export
   #:gen
   #:generate))

(in-package #:fiveam-data-generator)

;;;; Generator protocol

(defclass generator ()
  ((function
    :initarg :function
    :reader generator-function)))

(defgeneric generate (generator)
  (:documentation
   "Generate a value from GENERATOR."))

(defmethod generate ((generator generator))
  (funcall (generator-function generator)))

(defun make-generator (function)
  (make-instance 'generator
                 :function function))

(defgeneric gen (type &rest args)
  (:documentation
   "Construct a generator for TYPE."))

;;;; Numeric generators

(defmethod gen ((type (eql :integer))
                &rest args
                &key
                  (min most-negative-fixnum)
                  (max most-positive-fixnum)
                &allow-other-keys)
  (declare (ignore args))
  (make-generator
   (lambda ()
     (+ min
        (random (1+ (- max min)))))))

(defmethod gen ((type (eql :float))
                &rest args
                &key
                  (min 0.0)
                  (max 1.0)
                &allow-other-keys)
  (declare (ignore args))
  (make-generator
   (lambda ()
     (+ min
        (* (random 1.0)
           (- max min))))))

(defmethod gen ((type (eql :double-float))
                &rest args
                &key
                  (min 0d0)
                  (max 1d0)
                &allow-other-keys)
  (declare (ignore args))
  (make-generator
   (lambda ()
     (+ min
        (* (random 1d0)
           (- max min))))))

(defmethod gen ((type (eql :complex))
                &rest args
                &key
                  (part-generator (gen 'float))
                &allow-other-keys)
  (declare (ignore args))
  (make-generator
   (lambda ()
     (complex
      (generate part-generator)
      (generate part-generator)))))

;;;; Boolean generator

(defmethod gen ((type (eql :boolean))
                &rest args)
  (declare (ignore args))
  (make-generator
   (lambda ()
     (zerop (random 2)))))

;;;; Character generator

(defmethod gen ((type (eql :character))
                &rest args)
  (declare (ignore args))
  (make-generator
   (lambda ()
     (code-char
      (random char-code-limit)))))

;;;; String generator

(defmethod gen ((type (eql :string))
                &rest args
                &key
                  (min-length 0)
                  (max-length 20)
                  (character-generator (gen :character))
                &allow-other-keys)
  (declare (ignore args))
  (make-generator
   (lambda ()
     (let ((length
             (+ min-length
                (random (1+ (- max-length min-length))))))
       (coerce
        (loop repeat length
              collect (generate character-generator))
        'string)))))

;;;; Symbol generator

(defmethod gen ((type (eql :symbol))
                &rest args
                &key
                  (package *package*)
                  (intern t)
                &allow-other-keys)
  (declare (ignore args))
  (make-generator
   (lambda ()
     (let ((name
             (string-upcase
              (generate
               (gen :string
                    :min-length 1
                    :max-length 12)))))
       (if intern
           (intern name package)
           (make-symbol name))))))

(defmethod gen ((type (eql :keyword))
                &rest args)
  (declare (ignore args))
  (make-generator
   (lambda ()
     (intern
      (symbol-name
       (generate
        (gen :symbol
             :intern nil)))
      "KEYWORD"))))

;;;; Collection generators

(defmethod gen ((type (eql :list))
                &rest args
                &key
                  of
                  (min-length 0)
                  (max-length 20)
                &allow-other-keys)
  (declare (ignore args))
  (make-generator
   (lambda ()
     (loop repeat (+ min-length
                     (random (1+ (- max-length min-length))))
           collect (generate of)))))

(defmethod gen ((type (eql :vector))
                &rest args
                &key
                  of
                  (min-length 0)
                  (max-length 20)
                &allow-other-keys)
  (declare (ignore args))
  (make-generator
   (lambda ()
     (coerce
      (generate
       (gen :list
            :of of
            :min-length min-length
            :max-length max-length))
      'vector))))

(defmethod gen ((type (eql :array))
                &rest args
                &key
                  of
                  (dimensions '(10))
                &allow-other-keys)
  (declare (ignore args))
  (make-generator
   (lambda ()
     (let ((array (make-array dimensions)))
       (dotimes (i (array-total-size array) array)
         (setf (row-major-aref array i)
               (generate of)))))))

