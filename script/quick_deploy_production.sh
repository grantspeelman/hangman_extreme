git remote add production git@heroku.com:mxithangmanleague.git
git push production master && \
heroku run rake db:migrate --app mxithangmanleague && \
heroku run rake airbrake:deploy TO=production --app mxithangmanleague