# cookbook-omnibus-gitlab-cookbook

Install GitLab Community Edition or Enterprise Edition omnibus packages from
packages.gitlab.com.

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

Create/remove a cron job for GitLab backups. Defaults to daily backups at 0:45.

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
