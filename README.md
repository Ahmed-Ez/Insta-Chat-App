# Chat-App

A chat app for Instabug challenge, Please note this might not be the best Ruby/Rails structure and conventions since this is my first time ever using Ruby or Rails.

## How to run

Just clone this repository and run docker-compose up in root directory

```bash
docker-compose up
```

if you face vm.max_map_count issue with the Elastic search container it's a docker vertual memory issue and has to be handled on the host machine ( your pc or server), Refer to this stackoverflow issue.

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

4- Use Redis in caching Apps, Chats and latest messages, Right now Redis is only used in storing and generating Chats and Messages numbers so numbers are up to date instead of using DB which could be off-sync
