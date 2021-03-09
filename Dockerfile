FROM jruby:9.2.7.0-jdk as builder

WORKDIR /usr/src/app

COPY Gemfile logstash-filter-header.gemspec ./
RUN bundle install

COPY . .

RUN bundle exec rspec

RUN gem build logstash-filter-header.gemspec

FROM docker.elastic.co/logstash/logstash:6.8.14

ENV VERSION=0.1.0

COPY --from=builder /usr/src/app/logstash-filter-header-${VERSION}.gem .

RUN bin/logstash-plugin install --no-verify logstash-filter-header-${VERSION}.gem
RUN bin/logstash-plugin prepare-offline-pack logstash-filter-header

CMD ["/bin/bash", "-c", "cp logstash-offline-plugins-6.8.14.zip /output/logstash-filter-header.zip && cp logstash-filter-header-${VERSION}.gem /output"]
