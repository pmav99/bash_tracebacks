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
## TRACEBACK
 - CLI_arguments  : bash ./simple.sh
 - exit_code      : 124
 - failed_command : timeout 0.01 curl --fail https://example.com
 - stacktrace     :
    1. ./source_code.sh:19:inner
    2. ./source_code.sh:13:middle
    3. ./source_code.sh:9:my_main
    4. ./simple.sh:21:main
```

## Advanced Error Handling

If we need more advanced error handling, then we need to define a callback function.
In that function we can do stuff like printing the values of ENV variables,
POSTing the traceback to some slack channel etc.

An example of such a function can be found in `advanced.sh`:

```
./advanced.sh

## VARIABLES
 - aaa=1
 - bbb=23
 - ccc=asdfasdf
 - ddd=__unset__
 - eee=
## TRACEBACK
 - CLI_arguments  : bash ./advanced.sh
 - exit_code      : 124
 - failed_command : timeout 0.01 curl --fail https://example.com
 - stacktrace     :
    1. ./source_code.sh:19:inner
    2. ./source_code.sh:13:middle
    3. ./source_code.sh:9:my_main
    4. ./advanced.sh:32:main
```
