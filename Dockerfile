# -------------------------------------
# Builder image
# -------------------------------------

FROM ruby:2.6.1 as builder
RUN apt-get update && apt-get install -y --no-install-recommends
WORKDIR /app
COPY Gemfile* /app/
ENV BUNDLER_VERSION 2.0.1
RUN gem install bundler && \
    bundle config set without 'development test' && \
    bundle config set deployment 'true' && \
    bundle install

# -------------------------------------
# Production image
# -------------------------------------

FROM ruby:2.6.1-slim
RUN apt-get update --fix-missing && apt-get install -y libpq-dev && apt-get install sqlite3 -y
WORKDIR /app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY . .
ENV RAILS_ENV production
CMD ["bundle", "exec", "rails", "server"]
