#!/bin/sh

kubectl create -f nginx-config.yaml
kubectl create -f deployment.yaml
kubectl expose deploy phpfpm-nginx --type=NodePort --port=80