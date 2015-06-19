FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup | bash
RUN apt-get install -qq -y nodejs

ENV APP_HOME /myapp
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

# --- Add this to your Dockerfile ---
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=10 \
  BUNDLE_PATH=/bundle

RUN bundle install

ADD . $APP_HOME
