FROM ruby:2.6.5

RUN mkdir /memopic
ENV APP_ROOT /memopic

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn chromium-driver unzip wget

RUN wget https://ipafont.ipa.go.jp/IPAexfont/IPAexfont00401.zip
RUN unzip IPAexfont00401.zip

RUN mkdir /usr/share/fonts/japanese && mkdir /usr/share/fonts/japanese/TrueType
RUN mv IPAexfont00401/*.ttf /usr/share/fonts/japanese/TrueType

WORKDIR $APP_ROOT
COPY Gemfile Gemfile.lock $APP_ROOT/
RUN bundle install
COPY . $APP_ROOT

RUN rm -rf bin/webpack*
RUN rm -rf config/webpacker.yml
RUN bundle exec rails webpacker:install
RUN bundle exec rails webpacker:compile

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
