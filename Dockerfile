FROM ruby:3.1.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /chat-app
WORKDIR /chat-app
ADD Gemfile /chat-app/Gemfile
ADD Gemfile.lock /chat-app/Gemfile.lock
RUN bundle install
ADD . /chat-app