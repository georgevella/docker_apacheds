#! /bin/bash

helm upgrade apacheds . -f values.yaml -f values.minikube.yaml --install