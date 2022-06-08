FROM eu.gcr.io/oi-tset/ruby:3.1.2-alpine3.16

LABEL maintainer='devs@test.io'

ARG APP_UID=7321
ARG USER=appuser
ARG GROUP=appgroup

RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    postgresql-client \
    tzdata

RUN addgroup -S ${GROUP} -g $APP_UID && adduser -S ${USER} -G ${GROUP} -u $APP_UID

WORKDIR /app
RUN chown ${USER}:${GROUP} /app
USER ${USER}

COPY --chown=${USER}:${GROUP} Gemfile Gemfile.lock ./

RUN bundle lock --add-platform ruby && \
    bundle config set --local path '~/.cache/bundle' && \
    bundle config set --local clean 'true' && \
    bundle install

COPY --chown=${USER}:${GROUP} . .

RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
