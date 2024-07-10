# JIRA NICE

JIRA CLI integrations useful in daily development.

The connector is installed in one of two ways. They differ only on config search path:

* _Standalone_ searches `.jira.d/config`.
* _Embedded_ searches `.jira.d/config` and `.jira.d/../.jira.config`.

_Embedded_ is used when `jira-nice` is running inside a parent git repo. In this setup,
configs in the parent are found and merged, thus impacting all commands. This enables
repo-specific defaults, overrides, and git-based installation (submodule or clone).
In all other cases, _Standalone_ is used.

## Quickstart (Standalone)

### HOME is where JIRA lives rent-free

Paste the following in your _terminal_, **one line at a time**, and **exactly as written**. It will `install` the connector into your home directory then `clean` up temporary outputs.

```bash
DESTDIR=~ bin/jira-nice-installer install clean
PATH=~/.jira.d/bin:$PATH
```

### JIRA --login at the right --endpoint

Paste the following in your _terminal_, **one line at a time**, and **exactly as written**. It creates shell variables for the next step.
* Update `NAME` to match the username part of _your_ email!
* Update `COMPANY` to the second- or third-level of _your_ email!
    > ie. drop any TLD, such as ".com". It's less common (but possible) that your JIRA endpoint is different from your email domain --- look at the URL in the JIRA UI for the correct value.

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

### Generate a fresh API token (https://id.atlassian.com/manage/api-tokens)
```console
$ bin/jira list # Can timeout if token not entered in time, ignore.
? Jira API-Token [FIRST.LAST@COMPANY]:  [? for help] ************************
```

### This is the moment of truth
```console
$ bin/jira --help
$ bin/jira list
```
