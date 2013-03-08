all: install test vagrant

install:
	bundle install
	bundle exec berks install

test:
	bundle exec bash -i -c knife_test
	bundle exec bash -i -c foodcritic_test
	bundle exec bash -i -c rspec_test

vagrant:
	@if [ -f .vagrant ];\
		then bundle exec vagrant provision;\
	else\
		bundle exec vagrant up;\
	fi

ssh:
	@bundle exec vagrant ssh $(filter-out $@,$(MAKECMDGOALS))

master:
	echo 

status:
	@bundle exec vagrant status

clean:
	@rm -f Berksfile.lock
	@rm -f Gemfile.lock
	@if [ -f .vagrant ];\
		then bundle exec vagrant destroy -f;\
		rm -f .vagrant;\
	fi
