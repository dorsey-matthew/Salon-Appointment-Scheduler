#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"
# show services

services=$($PSQL "select service_id,name from services")
echo "$services" | while IFS="|" read service_id service_name
do
echo "$service_id) $service_name"
done
# choice selection
read SERVICE_ID_SELECTED

# validation of service
service_name=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
while [[ -z $service_name ]]
do
echo -e "\nI could not find that service. What would you like today?"
echo "$services" | while IFS="|" read service_id service_name
do
echo "$service_id) $service_name"
done
read SERVICE_ID_SELECTED
service_name=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
done
# ask for phone number
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
# check if a customer
CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_NAME ]]
then
# ask for name if no phone number
echo -e "\nI don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME
# insert new customer
insert_customer=$($PSQL "insert into customers(name,phone) values ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
fi
# get id
customer_id=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
# ask for requested appointment time
echo -e "\nWhat time would you like your $service_name, $CUSTOMER_NAME?"
read SERVICE_TIME
# insert time
insert_appointment=$($PSQL "insert into appointments(customer_id,service_id,time) values($customer_id,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
# verify appointment
echo -e "\nI have put you down for a $service_name at $SERVICE_TIME, $CUSTOMER_NAME."
