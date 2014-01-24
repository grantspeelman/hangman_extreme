#!/bin/sh
git remote add staging git@heroku.com:quickapps.git
heroku maintenance:on --app quickapps && \
git push staging master --force --verbose && \
heroku run rake db:migrate --app quickapps && \
heroku run rake airbrake:deploy TO=staging --app quickapps && \
heroku maintenance:off --app quickapps
