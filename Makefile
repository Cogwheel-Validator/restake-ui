SHELL := /bin/bash

restake:
		docker stop restakeui || true
		docker rm restakeui || true
		docker build -t restakeui .
		docker run -p 1000:80 -d -t --name restakeui restakeui
