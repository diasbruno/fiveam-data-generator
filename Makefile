ENV?=development

## run through roswell
LISP?=sbcl

LISPFLAGS=--non-interactive --quit

.PHONY: tests
tests:
	ENV=$(ENV) \
	$(LISP) \
	$(LISPFLAGS) --quit --load tests-runner.lisp
