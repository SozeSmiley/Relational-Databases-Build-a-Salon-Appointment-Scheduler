#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon -t -c"

MAIN_MENU() {
  if [[ -z $1 ]]
  then
    echo -e "\n~~~~~ MY SALON ~~~~~"
    echo -e "\nWelcome to My Salon, how can I help you?"
  else
    echo -e "\n$1"
  fi

  echo "$($PSQL "SELECT * FROM services ORDER BY service_id")" | while read ID _ NAME
  do
    echo "$ID) $NAME"
  done
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) REGISTRATION $SERVICE_ID_SELECTED ;;
    2) REGISTRATION $SERVICE_ID_SELECTED ;;
    3) REGISTRATION $SERVICE_ID_SELECTED ;;
    *) MAIN_MENU "I could not find that service. What would you like today?";;
  esac
}

REGISTRATION (){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  
  GET_CUSTOMER=$($PSQL "SELECT customer_id, name from customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $GET_CUSTOMER ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERTING_NAME=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    ID=$($PSQL "SELECT customer_id from customers WHERE phone = '$CUSTOMER_PHONE'")
  else
    read ID _ CUSTOMER_NAME <<< $GET_CUSTOMER
  fi

  echo -e "\nWhat time would you like your appointment, $CUSTOMER_NAME?"
  read SERVICE_TIME

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $1")
  INSERTING_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($ID, $1, '$SERVICE_TIME')")

  echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed 's/\(.*\)/\L\1/; s/^ *//; s/&/and/g') at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU