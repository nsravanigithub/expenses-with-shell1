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
    echo -e "$2 is:: $G Success $N"
    else
    echo -e "$2 is:: $R Failure $N"
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

dnf module disable nodejs -y &>>$LOGFILE
Validate $? "Disabling Nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
Validate $? "Enabling Nodejs"

dnf install nodejs -y &>>$LOGFILE
Validate $? "Installing Nodejs"

id expense

if [ $? -ne 0 ]
then
useradd expense
else
"User is already added"
fi
mkdir -p /app
rm -rf /tmp/*
curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
cd /app
unzip /tmp/backend.zip
npm install

cp /home/ec2-user/expenses-with-shell1/backend.service /etc/systemd/system/backend.service