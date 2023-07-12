SHELL := /bin/bash

restake:
		docker stop restakeui || true
		docker rm restakeui || true
		docker build -t restakeui .
		docker run -p 4000:4000 -d -t restakeui