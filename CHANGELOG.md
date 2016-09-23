# 0.3.9

- Use https://gitlab.com/gitlab-cookbooks/gitlab-vault

# 0.3.8

- Cleanup munin recipes and files, they don't belong here

# 0.3.7

- Remove the custom header added in 0.3.6. 
- Update Cronic version checksum (Evan Felix)
- Configurable package timeout setting (Jan Skarvall)

# 0.3.6

- Add custom header to the registry config to work around a docker issue.

# 0.3.5

- Remove quotes around the storage information in gitlab.rb.erb

# 0.3.4

- Support for multiple storage shards

# 0.3.3

- Support for Container Registry config

# 0.3.2

- Support for GitLab pages config

# 0.3.1

- Support for mailroom service
- Support for gitlab-workhorse(name change from gitlab-git-http-server)

# 0.3.0

- Support gitlab-git-http-server config
- Support mattermost config
- Support for secrets stored in Chef Vault

# 0.2.0

- Render omnibus-gitconfig in gitlab.rb
- Update Vagrantfile for easier development
- Switch from package file downloads to packages.gitlab.com

We no longer support entering a URL+SHA256 in the attributes to select the
package that gets installed. Instead, we add packages.gitlab.com as an apt/yum
repo and install the package with apt or yum. You can control which version
gets installed with the `node['omnibus-gitlab']['package']['version']`
attribute.

GitLab CE:

```
{
  "omnibus-gitlab": {
    "package": {
      "version": "INSERT VERSION"
    }
  }
}
```

GitLab EE:

```
{
  "omnibus-gitlab": {
    "package": {
      "repo": "gitlab/gitlab-ee",
      "name": "gitlab-ee",
      "version": "INSERT VERSION"
    }
  }
}
```

# 0.1.3

- Create the SSL key and certificate for GitLab CI

- Also render ci_external_url and git_data_dir in gitlab.rb

# 0.1.2

- Prevent storing secrets in the Chef node object

Cookbook-omnibus-gitlab allows you to keep secret Omnibus-gitLab settings
(passwords, keys) in an encrypted data bag. These secrets then get decrypted
during the Chef client run on your GitLab server. Due to a programming error,
the cookbook-omnibus-gitlab would then send the plaintext secrets back to the
Chef server to be stored in the node's database record. This defeats one of the
purposes of using encrypted data bags, namely to keep plaintext secrets off of
the Chef server.

In version 0.1.2 we make sure that the secrets stored in the encrypted data bag
do not get sent back to the server.

If you have been using cookbook-omnibus-gitlab with an encrypted data bag you
should upgrade to cookbook-omnibus-gitlab 0.1.2 or newer and inspect your
GitLab nodes to look for secrets:

```
knife node show gitlab.example.com --format json
```

If some of your cookbook-omnibus-gitlab secrets got uploaded to the Chef server
you can delete them from the node object using `knife node edit
gitlab.example.com` **after** you upgrade cookbook-omnibus-gitlab to 0.1.2 or
newer.

As an additional measure you may want to consider changing the affected
passwords and keys.

# 0.1.1

# 0.1.0

Initial release of cookbook-omnibus-gitlab
