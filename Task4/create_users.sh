#!/bin/bash

# Создание сертификатов пользователей
for USER in developer1 security1; do
    openssl genrsa -out ${USER}.key 2048
    openssl req -new -key ${USER}.key -out ${USER}.csr -subj "/CN=${USER}/O=${USER}"
    openssl x509 -req -in ${USER}.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out ${USER}.crt -days 365
    kubectl config set-credentials ${USER} --client-certificate=${USER}.crt --client-key=${USER}.key
done

# Добавление пользователей в контекст kubectl
kubectl config set-context developer-context --cluster=minikube --user=developer1
kubectl config set-context security-context --cluster=minikube --user=security1

echo "Пользователи developer1 и security1 созданы!"
