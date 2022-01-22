#!/bin/bash
# Sia host price pinning script
#
# First: Change the last line to your correct siac path
# To use: run script with ./set-bandwidth-price.sh PRICE
#

if [ "$#" -ne 1 ]; then
    echo "Missing price argument, run with "./set-bandwidth-price.sh PRICE""
    exit 1
fi

if ! command -v jq &> /dev/null
then
    echo "jq needs to be installed for script to function"
    exit 1
fi

input_usd=$1

# Get price from Kraken
current_kraken_price_raw=$(curl -q -s "https://api.kraken.com/0/public/Ticker?pair=SCUSD" | jq '.result.SCUSD.a[0]')

# Remove Quotes
current_kraken_price=$(echo "$current_kraken_price_raw" | tr -d '"')

# USD to SC Conversion
sc_tb=$(echo "$input_usd / $current_kraken_price" | bc)

# Set host configuration
/path/to//sia/siac host config mindownloadbandwidthprice ${sc_tb}SC
