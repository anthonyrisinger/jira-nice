# JIRA Sane

JIRA CLI integrations useful in daily development.

The connector is installed in one of two ways. They differ only on config search path:

* _Standalone_ searches `.jira.d/config`.
* _Embedded_ searches `.jira.d/config` and `.jira.d/../.jira.config`.

_Embedded_ is used when `jira-sane` is running inside a parent git repo. In this setup,
configs in the parent are found and merged, thus impacting all commands. This enables
repo-specific defaults, overrides, and git-based installation (submodule or clone).
In all other cases, _Standalone_ is used.

## Quickstart (Standalone)

### Ready environment
```console
$ bin/installer install clean
```

### Ready user config (`~/.jira.d/config.yml`)
```bash
user=NAME
login=NAME@COMPANY
endpoint=https://COMPANY.atlassian.net
project=PROJECT
```
```console
$ bin/jira config user=$user login=$login endpoint=$endpoint
$ bin/jira config project=$project password-source=keyring 
$ bin/jira config
{
	"endpoint": "https://COMPANY.atlassian.net",
	"login": "NAME@COMPANY",
	"password-source": "keyring",
	"project": "PROJECT",
	"user": "NAME"
}
```

### Ready API token (https://id.atlassian.com/manage/api-tokens)
```console
$ bin/jira list # Can timeout if token not entered in time, ignore.
? Jira API-Token [FIRST.LAST@COMPANY]:  [? for help] ************************
```

### Try it out
```console
$ bin/jira --help
$ bin/jira list
```

## Quickstart (Embedded)

### TODO
