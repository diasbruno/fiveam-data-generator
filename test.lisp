(defpackage #:fiveam-data-generator.test
  (:use #:cl #:fiveam)
  (:import-from #:fiveam-data-generator
                #:gen
                #:generate))

(in-package #:fiveam-data-generator.test)

(def-suite fiveam-data-generator.test)

(in-suite fiveam-data-generator.test)

(test integer-generator
  (loop repeat 100
        for value = (generate (gen :integer
                                   :min 1
                                   :max 10))
        do
           (is (integerp value))
           (is (<= 1 value 10))))

(test float-generator
  (loop repeat 100
        for value = (generate (gen :float
                                   :min 0.0
                                   :max 1.0))
        do
           (is (floatp value))
           (is (<= 0.0 value 1.0))))

(test double-float-generator
  (loop repeat 100
        for value = (generate (gen :double-float
                                   :min 0d0
                                   :max 1d0))
        do
           (is (typep value 'double-float))
           (is (<= 0d0 value 1d0))))

(test complex-generator
  (loop repeat 100
        for value = (generate (gen :complex))
        do
           (is (complexp value))))

(test boolean-generator
  (loop repeat 100
        for value = (generate (gen :boolean))
        do
           (is (typep value 'boolean))))

(test character-generator
  (loop repeat 100
        for value = (generate (gen :character))
        do
           (is (characterp value))))

(test string-generator
  (loop repeat 100
        for value = (generate (gen :string
                                   :min-length 5
                                   :max-length 10))
        do
           (is (stringp value))
           (is (<= 5 (length value) 10))))

(test symbol-generator
  (loop repeat 100
        for value = (generate (gen :symbol))
        do
           (is (symbolp value))))

(test keyword-generator
  (loop repeat 100
        for value = (generate (gen :keyword))
        do
           (is (keywordp value))))

(test list-generator
  (loop repeat 100
        for value = (generate (gen :list
                                   :of (gen :integer)
                                   :min-length 5
                                   :max-length 10))
        do
           (is (listp value))
           (is (<= 5 (length value) 10))
           (is (every #'integerp value))))

(test vector-generator
  (loop repeat 100
        for value = (generate (gen :vector
                                   :of (gen :string)
                                   :min-length 5
                                   :max-length 10))
        do
           (is (vectorp value))
           (is (<= 5 (length value) 10))
           (is (every #'stringp value))))

(test array-generator
  (loop repeat 100
        for value = (generate (gen :array
                                   :of (gen :integer)
                                   :dimensions '(3 3)))
        do
           (is (arrayp value))
           (is (equal '(3 3)
                      (array-dimensions value)))
           (is (loop for i below (array-total-size value)
                     always
                     (integerp
                      (row-major-aref value i))))))

(test constant-generator
  (loop repeat 100
        for value = (generate
                     (gen :constant
                          :value 42))
        do
           (is (= 42 value))))

(test member-generator
  (loop repeat 100
        for value = (generate
                     (gen :member
                          :members '(red green blue)))
        do
           (is (member value '(red green blue)))))

(test one-of-generator
  (loop repeat 100
        for value = (generate
                     (gen :one-of
                          :generators
                          (list (gen :integer)
                                (gen :string)
                                (gen :boolean))))
        do
           (is (or (integerp value)
                   (stringp value)
                   (typep value 'boolean)))))

(test map-generator
  (loop repeat 100
        for value = (generate
                     (gen :map
                          :generator
                          (gen :integer
                               :min 1
                               :max 10)
                          :function
                          (lambda (n)
                            (* n n))))
        do
           (is (integerp value))
           (is (member value
                       '(1 4 9 16 25 36 49 64 81 100)))))

(test filter-generator
  (loop repeat 100
        for value = (generate
                     (gen :filter
                          :generator (gen :integer)
                          :predicate #'evenp))
        do
           (is (integerp value))
           (is (evenp value))))

(test optional-generator
  (loop repeat 100
        for value = (generate
                     (gen :optional
                          :generator (gen :integer)))
        do
           (is (or (null value)
                   (integerp value)))))

(test tuple-generator
  (loop repeat 100
        for value = (generate
                     (gen :tuple
                          :generators
                          (list (gen :string)
                                (gen :integer)
                                (gen :boolean))))
        do
           (is (= 3 (length value)))
           (is (stringp (first value)))
           (is (integerp (second value)))
           (is (typep (third value) 'boolean))))

(test bind-generator
  (loop repeat 100
        for value = (generate
                     (gen :bind
                          :generator
                          (gen :integer
                               :min 1
                               :max 10)
                          :function
                          (lambda (n)
                            (gen :list
                                 :of (gen :integer)
                                 :min-length n
                                 :max-length n))))
        do
           (is (listp value))
           (is (every #'integerp value))
           (is (<= 1 (length value) 10))))
