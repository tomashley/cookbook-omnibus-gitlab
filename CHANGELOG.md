# 0.1.3

## Create the SSL key and certificate for GitLab CI

## Also render ci_external_url and git_data_dir in gitlab.rb

# 0.1.2

## Prevent storing secrets in the Chef node object

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
