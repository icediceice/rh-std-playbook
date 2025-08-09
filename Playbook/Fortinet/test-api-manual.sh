#!/bin/bash
# Manual FortiGate API Test Script

FORTIGATE_IP="172.28.7.58"
USERNAME="admin"
PASSWORD="your-password"  # Update with actual password

echo "Testing FortiGate HTTPS API access..."
echo "===================================="

# Test common admin ports
for PORT in 443 8443 10443; do
    echo "Testing port $PORT..."
    
    # Test if port is open
    timeout 5 bash -c "</dev/tcp/$FORTIGATE_IP/$PORT" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "  ✓ Port $PORT is open"
        
        # Test API login
        RESPONSE=$(curl -s -k -X POST \
            "https://$FORTIGATE_IP:$PORT/logincheck" \
            -d "username=$USERNAME&secretkey=$PASSWORD" \
            -c cookies.txt \
            --connect-timeout 10 \
            --max-time 15 2>/dev/null)
            
        if [[ "$RESPONSE" == *"error"* ]] || [[ "$RESPONSE" == *"fail"* ]]; then
            echo "  ✗ Port $PORT - Authentication failed"
        elif [[ -n "$RESPONSE" ]]; then
            echo "  ✓ Port $PORT - API responding (check auth manually)"
            
            # Test API call
            API_TEST=$(curl -s -k -b cookies.txt \
                "https://$FORTIGATE_IP:$PORT/api/v2/cmdb/system/global" \
                --connect-timeout 10 2>/dev/null)
                
            if [[ "$API_TEST" == *"results"* ]]; then
                echo "  ✓ Port $PORT - API calls working!"
                echo "  → Use ansible_httpapi_port: $PORT"
                break
            fi
        else
            echo "  ? Port $PORT - Unknown response"
        fi
    else
        echo "  ✗ Port $PORT is closed or filtered"
    fi
    echo
done

# Cleanup
rm -f cookies.txt

echo "Update this password in the script and run again if needed."