
tests: ## Clean and Make unit tests
	python3 -m pytest -v tests --cov=pynqpandas


test: lint ## run the tests for travis CI
	# @ python3 -m nose2 -v tests --with-coverage --coverage=pynqpandas

lint: ## run linter
	pylint pynqpandas || echo
	flake8 pynqpandas

annotate: ## MyPy type annotation check
	mypy -s pynqpandas

annotate_l: ## MyPy type annotation check - count only
	mypy -s pynqpandas | wc -l 

clean: ## clean the repository
	find . -name "__pycache__" | xargs  rm -rf 
	find . -name "*.pyc" | xargs rm -rf 
	rm -rf .coverage cover htmlcov logs build dist *.egg-info
	make -C ./docs clean

install:  ## install to site-packages
	python3 setup.py install

docs:  ## make docs
	make -C ./docs html

# Thanks to Francoise at marmelab.com for this
.DEFAULT_GOAL := help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo '$*=$($*)'

.PHONY: clean run test help annotate annotate_l docs
