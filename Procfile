release: bundle exec rails db:migrate
web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
web: bin/rails server -p 3000
js: yarn build --watch
css: yarn build:css --watch
