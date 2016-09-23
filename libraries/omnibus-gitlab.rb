module OmnibusGitlab
  def self.fetch_from_databag(node, *path)
    node_attributes = GitLab::Vault.fetch_path(node, path) # eg: node['omnibus-gitlab']['gitlab_rb']
    databag_secrets = environment_secrets_for_node(node) # eg: {"omnibus-gitlab": {"gitlab_rb": {}}} OR {}

    if databag_secrets.any?
      secrets = fetch_or_init(databag_secrets, path)
      Chef::Mixin::DeepMerge.deep_merge(secrets.to_hash, node_attributes.to_hash)
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

  def self.fetch_or_init(hash, path)
    result = hash

    path.each do |p|
      result[p] ||= Hash.new
      result = result[p]
    end

    result
  end
end
