# Re-record with:
#   DEMO=<copy of examples/get-started/hello_world> ACEDIR=<dir that holds ace> \
#   IDF_PATH=<esp-idf checkout> vhs ace-demo.tape
# Needs: vhs, ttyd, ffmpeg. The project copy must have no .ace directory.
#
# Before each command a comment says what the command does.
# `Wait+Line /^\$$/` waits until the prompt is printed again, so the tape
# never guesses how long a command runs. (`Wait+Screen` cannot be used here:
# vhs 0.11.0 reads the first screen of the scrollback, so it never sees
# output that scrolled.)

Output ace-demo.webm
Output ace-demo.gif

Set Shell bash
Set FontSize 17
Set Width 1200
Set Height 720
Set Padding 16
Set Theme "Catppuccin Mocha"
Set TypingSpeed 40ms

Hide
Type "cd $DEMO && export PATH=$ACEDIR:$PATH && . $IDF_PATH/export.sh >/dev/null 2>&1; export PS1='$ '; clear"
Enter
Wait+Line@180s /^\$$/
Show

Type "# a project with no workspace yet"
Sleep 1000ms
Enter
Type "ace status"
Sleep 1000ms
Enter
Wait+Line@30s /^\$$/
Sleep 2500ms

Type "# create a workspace: bind the project to a chip and configure the build tree"
Sleep 1000ms
Enter
Type "ace init dev esp32c6"
Sleep 1000ms
Enter
Wait+Line@180s /^\$$/
Sleep 2000ms

Type "clear"
Enter
Type "# a second workspace for another chip, next to the first one"
Sleep 1000ms
Enter
Type "ace init prod esp32s3"
Sleep 1000ms
Enter
Wait+Line@180s /^\$$/
Sleep 2000ms

Type "clear"
Enter
Type "# both workspaces; the star marks the current one"
Sleep 1000ms
Enter
Type "ace workspace list"
Sleep 1000ms
Enter
Wait+Line@30s /^\$$/
Sleep 2000ms

Type "# switch back to dev; later commands act on it"
Sleep 1000ms
Enter
Type "ace switch dev"
Sleep 1000ms
Enter
Wait+Line@30s /^\$$/
Sleep 1500ms

Type "# what ace knows about the current workspace"
Sleep 1000ms
Enter
Type "ace status"
Sleep 1000ms
Enter
Wait+Line@30s /^\$$/
Sleep 3000ms

Type "clear"
Enter
Type "# a setting for this workspace only"
Sleep 1000ms
Enter
Type "ace config set core.log-level debug"
Sleep 1000ms
Enter
Wait+Line@30s /^\$$/
Sleep 1200ms

Type "# all scopes; the workspace value is listed above the built-in value it replaces"
Sleep 1000ms
Enter
Type "ace config list --all"
Sleep 1000ms
Enter
Wait+Line@30s /^\$$/
Sleep 3500ms

Type "# a workspace that does not exist: the error names the ones that do"
Sleep 1000ms
Enter
Type "ace switch nope"
Sleep 1000ms
Enter
Wait+Line@30s /^\$$/
Sleep 3000ms
