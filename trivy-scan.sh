#!/bin/bash

# Scan the local filesystem
echo "Running Trivy filesystem scan..."
trivy fs --security-checks vuln,config,secret --exit-code 1 --severity CRITICAL,HIGH .

# Scan the built Docker image
echo "Running Trivy image scan..."
trivy image --exit-code 1 --severity CRITICAL,HIGH your-dockerhub-username/integrating-security-scanning:latest

# Generate HTML report
echo "Generating Trivy reports..."
trivy fs --security-checks vuln,config,secret --format template --template "@contrib/html.tpl" -o trivy-report.html .
trivy image --format template --template "@contrib/html.tpl" -o trivy-image-report.html your-dockerhub-username/integrating-security-scanning:latest
