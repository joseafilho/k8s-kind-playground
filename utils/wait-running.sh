#!/bin/bash
total="${2}"

for ((i = 0; i < total; ++i)); do
    output="$(${1})"
    echo "${output}"

    # TODO - Refactor to wait status, ex.: Pod Running, 1/1, NGinx ingress attribute Adress setted as localhost, Deployment Ready.
    # if [[ $output == *"Running"* ]]; then
    #     echo "${output}"
    #     break
    # fi

    sleep 1
    echo "${i} second."
done