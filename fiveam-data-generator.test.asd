(asdf:defsystem #:fiveam-data-generator.test
  :description "Tests for fiveam-data-generator."
  :author "Bruno Dias"
  :license "Unlicense"
  :depends-on (#:fiveam-data-generator
	       #:fiveam)
  :serial t
  :components ((:file "test")))
