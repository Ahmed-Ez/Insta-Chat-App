# Chat-App

A chat app for Instabug challenge, Please note this might not be the best Ruby/Rails structure and conventions since this is my first time ever using Ruby or Rails.

## How to run

Just clone this repository and run docker-compose up in root directory

```bash
docker-compose up
```

if you face vm.max_map_count issue with the Elastic search container it's a docker vertual memory issue and has to be handled on the host machine ( your pc or server), Refer to this stackoverflow issue. I could run a bash file to set it in the container but that might also change the host machine which is something that I didn't want to do without permission.

```
https://stackoverflow.com/questions/69214301/using-docker-desktop-for-windows-how-can-sysctl-parameters-be-configured-to-per
```

## Containers

These are the containers that will be created and run

1- Elastic search container

2- Redis container

3- MySQL container

4- RabbitMQ container

5- The Rails application container

##Usage
This is how I used each technology in the previously mentioned containers to responded to each requirement in the challenge description

1- Elastic search was used to Partially search messages content, I attached the ES model into the ActiveRecord and used the Search method to partially search the content

2- Redis was used to generate numbers for Chats and Messages, As The number was required to be up to date and the database could be off-sync, So redis was a good solution to this.

3- MYSql was used as the primary Database where Apps, Chats and Messages are stored

4- RabbitMQ was used as a message queue between the Application and the Worker that consumes the messages and persists the data in database


## Documentation
I created a simple Postman collection and documentation to make it easier to try the Application out, It's attached in the link below

```
https://documenter.getpostman.com/view/20503975/Uz5GowKg
```

## Improvements

Some improvements I would do If I had more time or was more familiar with Ruby and Rails since this is my first time using either of them.

1- Separate consumer worker that takes MQ message into it's own application in a separate container, As I consider it a separate service.

2- I thought about using token and number to as foreign keys in the relations to make it easier to join the table , , However that would make ids obsolete.

3- Improve overall project structure and separate some logic from the controllers into separate methods.

4- Use Redis in caching Apps, Chats and latest messages, Right now Redis is only used in storing and generating Chats and Messages numbers 
