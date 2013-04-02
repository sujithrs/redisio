Vagrant::Config.run do |config|

  config.vm.box = "Yipit12.04.1-10.18.2"

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      "username" => "vagrant"
    }

    chef.log_level = "debug"

    chef.run_list = [
      "recipe[redisio::test]",
    ]
  end
end
