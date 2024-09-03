#!/bin/bash

get() {
    json=$(curl -s --location "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
        --header 'Content-Type: application/json' \
        --header "Authorization: Bearer $API_KEY")
    local domain_info=$(echo $json | jq -r '.result[] | .name + " " + .id' | grep $DOMAIN_NAME)
    echo $domain_info
}


while [ $# -gt 0 ]; do
    case $1 in
        --get)
        domain_info=$(get)
        echo Domain and id: $domain_info
        exit 0
        ;;

        *)
        echo "Invalid option: $1" >&2
        usage
        exit 1
        ;;
    esac
    shift
done

set_record_id() {
    echo "Fetching DNS record id..."
    local domain_info_arr=($(get))
    DNS_RECORD_ID=${domain_info_arr[1]}
}

if [ -z "${DNS_RECORD_ID}" ]; then
    set_record_id
fi

loop() {
    local prev_ip=""

    while :
    do
        ip=$(curl -s ifconfig.me)
        echo $ip

        if [ "$prev_ip" != "$ip" ]; then
            curl -s --request PATCH \
                --url https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_RECORD_ID \
                --header 'Content-Type: application/json' \
                --header "Authorization: Bearer $API_KEY" \
                --data "{
                    \"content\": \"$ip\",
                    \"name\": \"$DOMAIN_NAME\",
                    \"type\": \"A\",
                    \"id\": \"$DNS_RECORD_ID\"
                }"
            echo
        fi

        local prev_ip=$ip
        
        sleep $TIMEOUT_SEC
    done
}

loop
