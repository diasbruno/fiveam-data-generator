(require :sb-cover)
(declaim (optimize sb-cover:store-coverage-data))

(push (uiop:getcwd)
      ql:*local-project-directories*)

(ql:quickload '(:fiveam #:fiveam-data-generator.test))

(defun run-tests (coverage)
  (prog1 (5am:run-all-tests)
    (when coverage
      (sb-cover:report #P"./coverage/"))))

(setf *debugger-hook*
      (lambda (c h)
	(declare (ignore c h))
	(uiop:quit -1))
      fiveam:*on-error* nil)

(unless (run-tests t)
  (uiop:quit :code -1 :abort t))
