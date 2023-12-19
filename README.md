# `bash_traceback`

Ever faced the frustration of a bash script failing silently, leaving you clueless?
Imagine if you could get a helpful traceback instead. Well, you can!

Simply add the following lines to your script:

```diff
+source ./bash_traceback.sh
+trap 'print_traceback $LINENO ${?}' ERR
```

## Example

Consider this bash script that fails silently:

```
$ ./initial.sh

START
Called with arguments: 1 23 asdfasdf
Before bad command.
```

Now, with the added lines in our script, the output transforms to:

```
$ ./simple.sh

START
Called with arguments: 1 23 asdfasdf
Before bad command.
=== TRACEBACK ===
CLI_arguments  : bash ./simple.sh
exit_code      : 124
failed_command : timeout 0.01 curl --fail https://example.com
stacktrace     :
  - ./source_code.sh:18:inner
  - ./source_code.sh:12:middle
  - ./source_code.sh:8:my_main_func
  - ./simple.sh:21:main
=== TRACEBACK ===
```

## Advanced Error Handling

If we need more advanced error handling, then we need to define a callback function.
In that function we can do stuff like printing the ENV variables,
POSTing the traceback to some slack channel etc.

An example of such a function can be found in `advanced.sh`:

```
./advanced.sh

=== ENVIRONMENT ===
[...snip...]
XDG_SESSION_CLASS=user
XDG_SESSION_ID=1
XDG_SESSION_TYPE=tty
XDG_VTNR=1
_=posix
__MODULES_LMINIT='module use --append /etc/modules/modulefiles'
aaa=1
bbb=23
ccc=asdfasdf
=== ENVIRONMENT ===
=== TRACEBACK ===
CLI_arguments  : bash ./advanced.sh
exit_code      : 124
failed_command : timeout 0.01 curl --fail https://example.com
stacktrace     :
  - ./source_code.sh:18:inner
  - ./source_code.sh:12:middle
  - ./source_code.sh:8:my_main_func
  - ./advanced.sh:26:main
=== TRACEBACK ===
```
