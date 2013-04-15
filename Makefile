all: install test vagrant

install:
	bundle install
	bundle exec berks install

test:
	bundle exec foodcritic .
	bundle exec rspec .

vagrant:
	@if [ -d .vagrant ];\
		then vagrant provision;\
	else\
                vagrant up;\
		vagrant provision;\
	fi

ssh:
	@vagrant ssh $(filter-out $@,$(MAKECMDGOALS))

status:
	@vagrant status

clean:
	@rm -f Berksfile.lock
	@rm -f Gemfile.lock
	@if [ -d .vagrant ];\
		then vagrant destroy -f;\
		rm -rf .vagrant;\
	fi
