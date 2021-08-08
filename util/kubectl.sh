#!/bin/bash

function kc_stg() {
    link_kube_conf "$HOME/.kube/config_staging.yml"
}

function kc_prd() {
    link_kube_conf "$HOME/.kube/config_production.yml"
}

function link_kube_conf() {
    config=$1
    if [ -e "$config" ]; then
        ln -si "$config" "$HOME/.kube/config"
        echo_success "link"
        echo " $config -> $KUBECONFIG"
    else
        echo_failure "$config is not found.\n"
    fi
}

function ksh() {
    namespace=$(kubectl config view --minify | grep namespace | awk '{print $2}')
    if [ -z "$namespace" ]; then
        echo_failure 'namespace is empty\n'
        kubectl get namespaces
        kubectl config get-contexts
        return
    fi
    kubectl exec -it -n "$namespace" "$(kubectl get pod -n $namespace | grep Running | head -n 1 | awk '{print $1}')" -- sh
}
