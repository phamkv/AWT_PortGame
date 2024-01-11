Build:
In Godot, go to Project -> Export...

If needed, click on Add -> Web

Set Export Path to index.html and in an empty folder (should be outside the Godot Project, example: ../GodotBuild/index.html)

Click on Export All...

In order to play the game in the browser, run the following command in this folder (you will need npx installed):

npx local-web-server --https --cors.embedder-policy "require-corp" --cors.opener-policy "same-origin" --directory "."

Go to the url shown in the console. Press TAB to lock the mouse ingame.
It may not work in the first attempt. Holding left click and pressing TAB multiple times ingame may solve this.