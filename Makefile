PYTHONPATH=./app

deps:  ## Install dependencies
	poetry install --no-root

lint:  ## Lint and static-check
	poetry run flake8 --jobs 1 --statistics --show-source --max-line-length 120
	poetry run pylint --jobs 1 $(PYTHONPATH)
	poetry run mypy --install-types --ignore-missing-imports $(PYTHONPATH)

format:  ## Format code
	poetry run autoflake --recursive --in-place $(PYTHONPATH)
	poetry run black --target-version py311 --skip-string-normalization $(PYTHONPATH)
	poetry run isort $(PYTHONPATH)
	poetry run unify --in-place --recursive --quote='"' $(PYTHONPATH)

push:  ## Push code with tags
	git push && git push --tags

run:  ## Run server from project root directory
	poetry run uvicorn app.main:app --reload

run_open:  ## Run server from project root directory
	poetry run uvicorn app.main:app --host 0.0.0.0 --reload

help: ## Show help message
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##/:/'`); \
	printf "%s\n\n" "Usage: make [task]"; \
	printf "%-20s %s\n" "task" "help" ; \
	printf "%-20s %s\n" "------" "----" ; \
	for help_line in $${help_lines[@]}; do \
		IFS=$$':' ; \
		help_split=($$help_line) ; \
		help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
		printf '\033[36m'; \
		printf "%-20s %s" $$help_command ; \
		printf '\033[0m'; \
		printf "%s\n" $$help_info; \
	done