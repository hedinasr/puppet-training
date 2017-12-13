apply: ## Run `puppet apply`
	@vagrant ssh -- "sudo su -c '/opt/puppetlabs/bin/puppet apply /vagrant/1-Resources/manifests/init.pp'"
	@vagrant ssh -- "sudo su -c '/opt/puppetlabs/bin/puppet apply /vagrant/2-Relationships/manifests/init.pp'"

test: ## Run tests
	@rake spec

help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
