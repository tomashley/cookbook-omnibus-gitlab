# This recipe will overwrite SSH host keys with values from the same encrypted
# data bag used by the omnibus-gitlab::default recipe.
#
# Use with care! If you supply invalid host keys, you may loose SSH access to
# your server.

environment_secrets = OmnibusGitlab.environment_secrets_for_node(node)

environment_secrets['omnibus-gitlab'] ||= Hash.new
environment_secrets['omnibus-gitlab']['ssh'] ||= Hash.new
environment_secrets['omnibus-gitlab']['ssh']['host_keys'] ||= Hash.new
ssh = Chef::Mixin::DeepMerge.deep_merge(environment_secrets['omnibus-gitlab']['ssh'], node['omnibus-gitlab']['ssh'].to_hash)

ssh['host_keys'].each do |filename, key_material|
  key_path = "/etc/ssh/#{filename}"

  # The script below first tries to generate a public key from the supplied
  # private key. If this fails, the Chef run will fail and the target file is
  # not overwritten.
  bash "install SSH host key #{filename}" do
    code %Q{
set -e
set -u

temp_suffix=.install-ssh-key.$(date +%s).$$
temp_key=#{key_path}${temp_suffix}

mkdir -p /etc/ssh

umask 077
cat > ${temp_key} <<EOF
#{key_material}
EOF

# The next step will fail or time out if the key material is invalid
ssh-keygen -y -f ${temp_key} > ${temp_key}.pub

# The key looks legit, move it into place
chmod 644 ${temp_key}.pub
mv ${temp_key} #{key_path}
mv ${temp_key}.pub #{key_path}.pub


# If this script timed out, you probably provided an invalid SSH host key!
    }
    # This timeout is crucial. If the user supplies an invalid SSH host key
    # then ssh-keygen will prompt the user for a password, effectively making
    # the script hang.
    timeout 10
    not_if { File.exists?(key_path) && File.read(key_path).strip == key_material.strip }
  end
end
