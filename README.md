# zenform-rb

```sh
$ cd <path-to-zenform-rb.git>
$ bundle exec zenform apply --config-path <CONFIG_PATH>
```

zenform-rb is a configuration management tool for Zendesk,
which creates below Zendesk contents from configuration files which you made.

* [Ticket Fields](https://developer.zendesk.com/rest_api/docs/core/ticket_fields)
* [Ticket Forms](https://developer.zendesk.com/rest_api/docs/core/ticket_forms)
* [Triggers](https://developer.zendesk.com/rest_api/docs/core/triggers)

## Table of Contents

* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
* [Configurations](#configurations)
* [When you find a bug](#when-you-find-a-bug)
* [License](#license)
* [Author](#author)

## Requirements

* Ruby (the specified version in  [`.ruby-version`](/.ruby-version))

## Installation

```sh
$ git clone git@github.com:xflagstudio/zenform-rb.git
$ cd zenform-rb
$ ./bin/setup
```

## Usage

You can see commands list by executing `bundle exec zenform help`.
This part explains simply how to use each command.
See `bundle exec zenform help [COMMAND]` for further details.

### apply

`apply` creates Zendesk contents according to configuration files.

```sh
$ cd <path-to-zenform-rb.git>
$ bundle exec zenform apply --config-path <CONFIG_PATH>
```

`<CONFIG_PATH>` is a path of the directory including configuration files.
default: `<path-to-zenform-rb.git>/zendesk_config`.

## Configurations

### Location of configuration files

Put configuration files in any directory `<CONFIG_PATH>` as below.

```
<CONFIG_PATH>/
  ├ auth_info.json
  ├ ticket_fields.csv
  ├ ticket_forms.csv
  └ triggers.csv
```

`auth_info.json` includes authentication information.

`ticket_fields.csv`, `ticket_forms.csv` and `triggers.csv` include settings of each contents.

### Types of parameters

Though there are many params in configuration files, there are 4 types of parameters.

Type    | Example
:--     | :--
string  | `user_id`, `os`, `os_version`, ...
integer | ..., `-2`, `-1`, `0`, `1`, `2`, `3`, ...
bool    | `TRUE`, `true` or `FALSE` , `false`
string[]<br>(string array with JSON format) | `["user_id","os","os_version"]`, `["app_version"]`, ...
string[][]<br>(2-dimensional string array with JSON format) | `[["requester_id","title of comment","body of comment"], ["solved"]]`, ...

### Formats of configurations

See wiki pages for further details.

* auth_info.json ([wiki](../../wiki/auth_info.json) / [sample](/example/configurations/auth_info.json))
* ticket_fields.csv ([wiki](../../wiki/ticket_fields.csv) / [sample](/example/configurations/ticket_fields.csv))
* ticket_forms.csv ([wiki](/../../wiki/ticket_forms.csv) / [sample](/example/configurations/ticket_forms.csv))
* triggers.csv ([wiki](/../../wiki/triggers.csv) / [sample](/example/configurations/triggers.csv))

#### About `slug` param

Configuration files other than `auth_info.json` has `slug` param,
which is an identifier for each contents in Zenform.
Even though you can assign just numbers to slug, we recommend you to assign a meaningful name representing the configuration.

## When you find a bug

We would be grateful if you make a pull requests or report an issue :blush:

## License

[MIT](/LICENSE.txt)

## Author

[XFLAG Studio](https://career.xflag.com/) CRE Team
