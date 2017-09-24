#!/bin/bash

# disable icmp echo requests (ping)
disable_icmp_echo() {
    echo "disabling icmp echo requests..."
    echo "this blocks icmp echo requests by modifying the windows firewall rules"

    # disable icmpv4 inbound echo request
    powershell -Command "New-NetFirewallRule -DisplayName 'Block ICMPv4-In' -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Block"

    # disable icmpv6 inbound echo request
    powershell -Command "New-NetFirewallRule -DisplayName 'Block ICMPv6-In' -Protocol ICMPv6 -IcmpType 128 -Direction Inbound -Action Block"
    
    echo "icmp echo requests have been disabled."
    echo "your machine will not respond to ping requests, making it less visible on the network"
}

# enable icmp echo requests (ping)
enable_icmp_echo() {
    echo "enabling icmp echo requests..."
    echo "this removes the rules blocking icmp echo requests from the windows firewall"

    # enable icmpv4 inbound echo request
    powershell -Command "Get-NetFirewallRule -DisplayName 'Block ICMPv4-In' | Remove-NetFirewallRule"

    # enable icmpv6 inbound echo request
    powershell -Command "Get-NetFirewallRule -DisplayName 'Block ICMPv6-In' | Remove-NetFirewallRule"
    
    echo "icmp echo requests have been enabled."
    echo "your machine will respond to ping requests, making it visible on the network"
}

# main script execution
if [[ $1 == "enable" ]]; then
    enable_icmp_echo
elif [[ $1 == "disable" ]]; then
    disable_icmp_echo
else
    echo "usage: $0 [enable|disable]"
    echo "use 'disable' to prevent your ip address from showing up in network scans."
    echo "use 'enable' to allow your ip address to be visible in network scans."
fi
