#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

SYMBOL=$1

#Function displaying message that does not exist
NEXIST(){
echo "I could not find that element in the database."
}

if [[ -z $SYMBOL ]]
then
 echo "Please provide an element as an argument."
else
  #if input is not a number
  if [[ ! $SYMBOL =~ ^[0-9]+$ ]]
  then
    #if input is greater than two letter
    LENGTH=$(echo -n "$SYMBOL" | wc -m)

    if [[ $LENGTH -gt 3 ]]
    then
      #get details full name
      DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name= '$SYMBOL'")
      if [[ -n $DATA ]]
      then
        DATA_T=$(echo $DATA | tr "|" " ")
        echo "$DATA_T" | while read TYPE_ID A_NUMBER LETTER NAME A_MASS MELTING BOILING TYPE 
        do
          echo "The element with atomic number $A_NUMBER is $NAME ($LETTER). It's a $TYPE, with a mass of $A_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius." 
        done
      else
        NEXIST
      fi
    else
      #get details symbol
      DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol= '$SYMBOL'")
      if [[ -n $DATA ]]
      then
        DATA_T=$(echo $DATA | tr "|" " ")
        echo "$DATA_T" | while read TYPE_ID A_NUMBER LETTER NAME A_MASS MELTING BOILING TYPE 
        do
          echo "The element with atomic number $A_NUMBER is $NAME ($LETTER). It's a $TYPE, with a mass of $A_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius." 
        done
      else
        NEXIST
      fi
    fi

  else
  #get details by Atomic_number
  DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number= $SYMBOL")
  if [[ -n $DATA ]]
  then
    DATA_T=$(echo $DATA | tr "|" " ")
    echo "$DATA_T" | while read TYPE_ID A_NUMBER LETTER NAME A_MASS MELTING BOILING TYPE 
    do  
      echo "The element with atomic number $A_NUMBER is $NAME ($LETTER). It's a $TYPE, with a mass of $A_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius." 
    done
    else
      NEXIST
    fi
  fi
fi
