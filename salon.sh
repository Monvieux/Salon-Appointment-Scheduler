#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ Salon service reservation ~~~~~\n"
#delete=$($PSQL "TRUNCATE appointments, customers")

SALON_APPOINTEMENT()
{
  if [[ $1 ]]
  then
    echo -e "\n$1"
  else
    echo -e "\nWelcome to My Salon, how can I help you?"
  fi
	#List of service
  echo "List of service"
  LIST_SERVICE_ID=$($PSQL "SELECT * FROM services ORDER BY service_id")
	echo "$LIST_SERVICE_ID" | while read SERVICE_ID BAR SERVICE_NAME
	do
		echo "$SERVICE_ID) $SERVICE_NAME"
	done
  #select service
	read SERVICE_ID_SELECTED
	#if service not in list
	IS_SERVICE_ID=$($PSQL "SELECT * FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  if [[ -z $IS_SERVICE_ID ]]
	then
		SALON_APPOINTEMENT "I could not find that service. What would you like today?"
	else
		#if service in List
		echo -e "\nEnter your phone number:"
		read CUSTOMER_PHONE
		#if phone don't exist
		IS_PHONE_EXIST=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
		if [[ -z $IS_PHONE_EXIST ]]
		then
			echo -e "\nEnter your name:"
			read CUSTOMER_NAME
			INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")		
		fi
    #if phone exist
    echo -e "\nEnter appointments:"
    read SERVICE_TIME
    #insert appointment
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    INSERT_APPOINTEMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')");
    FORMAT_C_NAME=$(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')
    FORMAT_S_NAME=$(echo $SERVICE_NAME | sed -r 's/^ *| *$//g')
    echo -e "I have put you down for a $FORMAT_S_NAME at $SERVICE_TIME, $FORMAT_C_NAME."			
	fi
}

SALON_APPOINTEMENT