APP_IMAGE     := weather-app:0.0.1
SCANNER_IMAGE := weather-scanner:0.0.1
BASE_IMAGE    := python:3.10-alpine
REPORT_DIR    := ./reports

.PHONY: all prepare build-app build-scanner scan-base scan-code scan-dockerfile scan-image scan-all clean

# IMPORTANT: Since this is a lab enviroment, when mounting with "-v" we are mounting EVERYTHING.
# In a project, this should not be the case, since we only need to mount the necessary.

all: scan-all
# Ensure reports directory exists
prepare:
	@mkdir -p $(REPORT_DIR)


# 1. Build the app image
build-app:
	docker build -t $(APP_IMAGE) .

# 2. Build the scanner image
build-scanner:
	docker build -f Dockerfile.scanner -t $(SCANNER_IMAGE) .

# 3. Scan the base image before build
scan-base: build-scanner
	docker pull $(BASE_IMAGE)
	docker run --rm \
	  -v $(REPORT_DIR):/reports \
	  $(SCANNER_IMAGE) \
	  "grype $(BASE_IMAGE) -o table | tee /reports/base-grype.txt \
		&& echo -e '\n==================================================END_GRYPE_BASE_SCAN==================================================\n'"

# 4. Scan the Python code with Bandit
scan-code: build-scanner
	docker run --rm \
	  -v $(shell pwd):/src \
	  -v $(REPORT_DIR):/reports \
	  $(SCANNER_IMAGE) \
	  "ls -l /src \
		&& bandit -r /src --exclude /src/.venv,/src/.git,/src/bandit-env | tee /reports/bandit.txt \
		&& echo -e '\n==================================================END_BANDIT_SCAN==================================================\n'"


scan-dockerfile: build-scanner
	docker run --rm \
	  -v $(shell pwd):/src/ \
	  -v $(REPORT_DIR):/reports \
	  $(SCANNER_IMAGE) \
		"checkov -f /src/Dockerfile --framework dockerfile | tee /reports/dockerfile-checkov.txt \
		&& echo -e '\n==================================================END_CHECKOV_DOCKERFILE_SCAN==================================================\n'"

# 5. Scan the built app image with Grype
scan-image: build-app build-scanner
	docker save $(APP_IMAGE) -o image.tar
	docker run --rm \
		-v $(shell pwd)/image.tar:/image.tar:ro \
	  -v $(REPORT_DIR):/reports \
	  $(SCANNER_IMAGE) \
	  "grype /image.tar -o table | tee /reports/image-grype.json \
		&& echo -e '\n==================================================END_GRYPE_APP_SCAN==================================================\n'"

# 6. Run everything in sequence, bail on first failure
scan-all: scan-base scan-code scan-dockerfile scan-image

clean:
	rm -rf $(REPORT_DIR)/*
