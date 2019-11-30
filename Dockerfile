FROM ruby:latest

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y nodejs yarn postgresql-client --no-install-recommends \
  && yarn add highcharts \
  && gem install rails

WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bundle install

RUN yarn add highcharts

CMD ["/bin/bash"]
