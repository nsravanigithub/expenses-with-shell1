#!/bin/bash

TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
userid=$(id -u)
Validate ()
{
    if [ $1 -eq 0 ]
    then
    echo -e "Installation of $2 is:: $G Success $N"
    else
    echo -e "Installation of $2 is:: $R Failure $N"
    exit 1
    fi
}

if [ $userid -eq 0 ]
then
echo "User have root previlages"
else
echo "Run with root access"
exit 1
fi

dnf install mysql-server -y &>>$LOGFILE
Validate $? "Installing Mysql server"

systemctl enable mysqld &>>$LOGFILE
Validate $? "Enabling Mysql server"

systemctl start mysqld &>>$LOGFILE
Validate $? "Starting Mysql server"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
Validate $? "Setting Mysql server root password"