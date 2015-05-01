module OmnibusGitlab
  def self.environment_secrets_for_node(node)
    data_bag_name = node['omnibus-gitlab']['data_bag']
    data_bag_item = node.chef_environment

    if data_bag_name && Chef::Search::Query.new.search(data_bag_name, "id:#{data_bag_item}").any?
      Chef::EncryptedDataBagItem.load(data_bag_name, data_bag_item).to_hash
    else
      Hash.new
    end
  end
end
