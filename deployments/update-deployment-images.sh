#!/bin/bash

FRONTEND_IMAGE=$1
BACKEND_IMAGE=$2
FRONTEND_TEMPLATE_PATH="template/frontend-template.yaml"
BACKEND_TEMPLATE_PATH="template/backend-template.yaml"
FRONTEND_DEPLOYMENT_PATH="k8s/frontend-deployment.yaml"
BACKEND_DEPLOYMENT_PATH="k8s/backend-deployment.yaml"

cp $FRONTEND_TEMPLATE_PATH $FRONTEND_DEPLOYMENT_PATH
cp $BACKEND_TEMPLATE_PATH $BACKEND_DEPLOYMENT_PATH

sed -i "s|__FRONTEND_IMAGE__|$FRONTEND_IMAGE|g" $FRONTEND_DEPLOYMENT_PATH
sed -i "s|__BACKEND_IMAGE__|$BACKEND_IMAGE|g" $BACKEND_DEPLOYMENT_PATH

git add $FRONTEND_DEPLOYMENT_PATH $BACKEND_DEPLOYMENT_PATH
git commit -m "Update deployment image tags: Frontend: $FRONTEND_IMAGE, Backend: $BACKEND_IMAGE [skip-ci]"
git push git@gitlab.lnu.se:ps222vt/internet-architectures.git