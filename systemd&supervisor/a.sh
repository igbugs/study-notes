#!/bin/bash

sleep 5
curl -H "source:50" -H "business_id:123" -H "Content-Type:application/json" -d "{'bean_name':'packetHandle'}" http://127.0.0.1:8170/usp-nhap/consumer/active 
curl -H "source:50" -H "business_id:123" -H "Content-Type:application/json" -d "{'bean_name':'nhapProcessCenterPush'}" http://127.0.0.1:8170/usp-nhap/process/service/start 
curl -H "source:50" -H "business_id:123" -H "Content-Type:application/json" -d "{'bean_name': 'nhapProcessCenterTimeOut'}" http://127.0.0.1:8170/usp-nhap/process/service/shutdown

