.PHONY: test
USERNAME=dejvo35
TAG=$(USERNAME)/hello-world-printer

deps:
	pip install -r requirements.txt; \
	pip install -r test_requirements.txt

test:
	PYTHONPATH=. py.test --verbose -s

lint:
	flake8 hello_world test

run:
	python3 main.py

docker_build:
	docker build -t hello-world-printer .

docker_run: docker_build
	docker run \
		--name hello-world-printer-dev \
		 -p 5000:5000 \
		 -d hello-world-printer

docker_push: docker_build
		 @docker login --username $(USERNAME) --password $${DOCKER_PASSWORD}; \
		 docker tag hello-world-printer $(TAG); \
		 docker push $(TAG); \
		 docker logout;

test_smoke:
	curl --fail 127.0.0.1:5000

test_cov:
	$ PYTHONPATH=. py.test --verbose -s --cov=.

test_xunit:
	$ PYTHONPATH=. py.test --verbose -s --cov=. --cov-report xml
