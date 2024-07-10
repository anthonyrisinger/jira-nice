# JIRA Nice

JIRA CLI integrations useful in daily development.

The connector is installed in one of two ways. They differ only on config search path:

* _Standalone_ searches `.jira.d/config`.
* _Embedded_ searches `.jira.d/config` and `.jira.d/../.jira.config`.

_Embedded_ is used when `jira-nice` is running inside a parent git repo. In this setup,
configs in the parent are found and merged, thus impacting all commands. This enables
repo-specific defaults, overrides, and git-based installation (submodule or clone).
In all other cases, _Standalone_ is used.

## Quickstart (Standalone)

### Ready environment
```bash
DESTDIR=~ bin/installer install clean
PATH=~/.jira.d/bin:$PATH
```

### Ready user config (`~/.jira.d/config/20-config.yml`)
```bash
NAME=c
COMPANY=anthonyrisinger
PROJECT=PROJ
```
```bash
user=$NAME
login=$NAME@$COMPANY.com
endpoint=https://$COMPANY.atlassian.net
project=$PROJECT
```
Calls to `config` merge and update with existing `~/.jira.d/config/20-config.yml`:
```bash
jira config user=$user login=$login endpoint=$endpoint project=$project
jira config password-source=keyring
```
```console
$ jira config
{
  "endpoint": "https://anthonyrisinger.atlassian.net",
  "login": "c@anthonyrisinger.com",
  "password-source": "keyring",
  "project": "PROJ",
  "user": "c"
}
$ cat ~/.jira.d/config/20-config.yml
{
  "endpoint": "https://anthonyrisinger.atlassian.net",
  "login": "c@anthonyrisinger.com",
  "password-source": "keyring",
  "project": "PROJ",
  "user": "c"
}
$ ~/.jira.d/config.sh | jq
{
  "custom-commands": [
    "list of {...} after merging with ~/.jira.d/config/10-defaults.yml"
  ],
  "endpoint": "https://anthonyrisinger.atlassian.net",
  "login": "c@anthonyrisinger.com",
  "password-source": "keyring",
  "project": "PROJ",
  "user": "c"
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
