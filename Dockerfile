ARG APP_PATH=./koppie
ARG BUNDLE_WITHOUT=""
FROM ghcr.io/samvera/hyrax/hyrax-base:hyrax-v5.0.0.rc2 as koppie-workshop

COPY --chown=1001:101 ./koppie /app/samvera/hyrax-webapp

WORKDIR /app/samvera/hyrax-webapp

RUN bundle install --jobs "$(nproc)"

RUN RAILS_ENV=production SECRET_KEY_BASE=workshop_key DB_ADAPTER=nulldb DATABASE_URL='postgresql://fake' bundle exec rake assets:precompile


ARG APP_PATH=./koppie
ARG BUNDLE_WITHOUT=""
FROM ghcr.io/samvera/hyrax/hyrax-worker-base:hyrax-v5.0.0.rc2 as koppie-workshop-worker

COPY --chown=1001:101 ./koppie /app/samvera/hyrax-webapp

WORKDIR /app/samvera/hyrax-webapp

RUN bundle install --jobs "$(nproc)"

RUN RAILS_ENV=production SECRET_KEY_BASE=workshop_key DB_ADAPTER=nulldb DATABASE_URL='postgresql://fake' bundle exec rake assets:precompile