# cookbook-omnibus-gitlab-cookbook

Install GitLab Community Edition or Enterprise Edition omnibus packages from
packages.gitlab.com.

## Supported versions

Latest version of this cookbook should be able to support installation of all versions of packages listed on packages.gitlab.com/gitlab/ .

## Supported Platforms

See packages.gitlab.com/gitlab/gitlab-ce.


## Attributes

- `node['omnibus-gitlab']['package']['repo']` defaults to `gitlab/gitlab-ce`. Use `gitlab/gitlab-ee` for GitLab Enterprise Edition
- `node['omnibus-gitlab']['package']['name']` defaults to `gitlab-ce`. Use `gitlab-ee` for GitLab Enterprise Edition

For more available attributes see `attributes/default.rb`.

### Examples

Install GitLab Community Edition `7.11.1~omnibus-1`.

```
{
  "omnibus-gitlab": {
    "package": {
      "version": "7.11.1~omnibus-1"
    },
    "gitlab_rb": {
      "external_url": "http://gitlab.example.com"
    }
  }
}
```

Install GitLab Enterprise Edition `7.11.1~ee.omnibus-1`.

```
{
  "omnibus-gitlab": {
    "package": {
      "repo": "gitlab/gitlab-ee",
      "name": "gitlab-ee",
      "version": "7.11.1~ee.omnibus-1"
    },
    "gitlab_rb": {
      "external_url": "http://gitlab.example.com"
    }
  }
}
```

## Usage

### omnibus-gitlab::default

Installs a GitLab omnibus package, renders `/etc/gitlab/gitlab.rb`, manages SSL
certificates.

### omnibus-gitlab::backup_cron_job

Create/remove a cron job for GitLab backups. Defaults to daily backups at 0:30.

Use 'gitlab.rb' to configure parameters like rotation and cloud uploads.

#### Examples

Disable backups of repositories and uploaded files:

```
{
  "omnibus-gitlab": {
    "backup_cron_job": {
      "skip": [
        "repositories",
        "uploads"
      ]
    }
  }
}
```

Run the backup script with progress messages:

```
{
  "omnibus-gitlab": {
    "backup_cron_job": {
      "silent": false
    }
  }
}
```

## Secrets

Starting with version 0.3.0, this cookbook supports reading secrets from [Chef Vault](https://docs.chef.io/chef_vault.html) or [Encrypted Data Bags](https://docs.chef.io/data_bags.html#encrypt-a-data-bag-item).

### Chef Vault

To get the cookbook to read a Chef Vault item, you need to specify `chef_vault` attribute with the name of the Vault.

Eg. In a role "gitlab-example-com" we can read secrets from Vault named `gitlab-example-com`:

```json
{ "name": "gitlab-example-com",
  "default_attributes": {
    "omnibus-gitlab": {
      "chef_vault": "gitlab-example-com",
      "package": {
        "repo": "gitlab/gitlab-ce",
        "version": "7.14.1-ce.0"
      },
      "gitlab_rb": {
        "external_url": "http://gitlab.example.com"
        "gitlab_rb": {
          "gitlab-rails": {
            "secret_token": "Read from Vault."
          }
        }
      }
    }
  }
}
```

Chef Vault item will look similar to:

```json
{
  "id": "_default",
  "omnibus-gitlab": {
    "gitlab_rb": {
      "gitlab-rails": {
        "secret_token": "12334qwerty"
      }
    }
  }
}

```

### Encrypted Data Bag

To get the cookbook to read an Encrypted Data Bag item, you need to specify `data_bag` attribute with the name of the data bag. As a prerequisite, node needs to have the `encrypted_data_bag_secret` in `/etc/chef/` directory in order to be able to decrypt the secrets.

Eg. In a role "gitlab-example-com" we can read secrets from Encrypted Data Bag named `gitlab-example-com`:

```json
{ "name": "gitlab-example-com",
  "default_attributes": {
    "omnibus-gitlab": {
      "data_bag": "gitlab-example-com",
      "package": {
        "repo": "gitlab/gitlab-ce",
        "version": "7.14.1-ce.0"
      },
      "gitlab_rb": {
        "external_url": "http://gitlab.example.com"
        "gitlab_rb": {
          "gitlab-rails": {
            "secret_token": "Read from Data Bag."
          }
        }
      }
    }
  }
}
```

Encrypted data bag item will look similar to:

```json
{
  "id": "_default",
  "omnibus-gitlab": {
    "gitlab_rb": {
      "gitlab-rails": {
        "secret_token": "12334qwerty"
      }
    }
  }
}

```

## Contributing

1. Fork the repository on GitLab.com
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: Marin Jankovski (marin@gitlab.com)
Author:: Jacob Vosmaer (jacob@gitlab.com)
