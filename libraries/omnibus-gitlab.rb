module OmnibusGitlab

  def self.environment_attributes_with_secrets(node, *path)
    if node['omnibus-gitlab']['data_bag']
      fetch_from_databag(node, path)
    else
      fetch_from_vault(node, path)
    end
  end

  def self.fetch_from_databag(node, path)
    node_attributes = GitLab::AttributesWithSecrets.fetch_path(node, path) # eg: node['omnibus-gitlab']['gitlab_rb']
    databag_secrets = environment_secrets_for_node(node) # eg: {"omnibus-gitlab": {"gitlab_rb": {}}} OR {}

    if databag_secrets.any?
      node_secrets = GitLab::AttributesWithSecrets.fetch_path(databag_secrets, path) # eg: databag_secrets['omnibus-gitlab']['gitlab_rb']
      Chef::Mixin::DeepMerge.deep_merge(node_secrets, node_attributes.to_hash)
    else
      node_attributes
    end
  end

  def self.environment_secrets_for_node(node)
    data_bag_name = node['omnibus-gitlab']['data_bag']
    data_bag_item = node.chef_environment

    if data_bag_name && Chef::Search::Query.new.search(data_bag_name, "id:#{data_bag_item}").any?
      Chef::EncryptedDataBagItem.load(data_bag_name, data_bag_item).to_hash
    else
      Hash.new
    end
  end

  def self.fetch_from_vault(node, path)
    GitLab::AttributesWithSecrets.get(node, *path)
  end
end
