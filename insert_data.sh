#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

Truncate=$($PSQL "TRUNCATE TABLE games, teams")
cat games.csv | while IFS=',' read y r winner opponent winner_g opponent_g
do 
  echo $y, $r, $winner
  teams=$($PSQL "select name from teams where name='$winner'")
  if [[ $winner  != 'winner' ]]
  then 
    if [[ -z $teams ]]
    then 
    insert_team=$($PSQL "insert into teams(name) values('$winner')")
    if [[ insert_team == 'INSERT 0 1' ]]
    then
    echo Insert into teams, $winner
    fi
  fi
fi
   teams_opponent=$($PSQL "select name from teams where name='$opponent'")
   if [[ $opponent  != 'opponent' ]]
  then 
    if [[ -z $teams_opponent ]]
    then 
    insert_opponent=$($PSQL "insert into teams(name) values('$opponent')")
    if [[ insert_opponent == 'INSERT 0 1' ]]
    then
    echo Insert into teams, $opponent
    fi
  fi
fi

team_id_w=$($PSQL "select team_id from teams where name='$winner'")
team_id_o=$($PSQL "select team_id from teams where name='$opponent'")

if [[ -n $team_id_w || -n $team_id_o ]]
then 
    if [[ $y != "year" ]]
    then
      insert_games=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($y, '$r', $team_id_w, $team_id_o, $winner_g, $opponent_g)")
    if [[ $insert_games == "INSERT 0 1" ]]
    then 
      echo Inserted into games, $y
    fi
  fi
fi
echo $y, $r, $team_id_w, $team_id_o, $winner_g, $opponent_g
done
