Build:
In Godot, go to Project -> Export...

If the preset is missing, click on Add -> Web

(Optional or if preset is missing) Set Export Path to index.html inside an empty folder (folder must be created beforehand and should be outside the Godot Project, example: ../GodotBuild/index.html)
Default is set to ../build/index.html

Click on "Export All..." and select "Release"

In order to play the game in the browser, run the following command inside the build folder (you will need npx installed):

npx local-web-server --https --cors.embedder-policy "require-corp" --cors.opener-policy "same-origin" --directory "."

Go to the on of the urls shown in the console. Ignore the security concerns for HTTPS in localhost. HTTPS and CORS need to be enabled in order to run Godot in WebGL.
Press TAB to lock the mouse ingame. It may not work in the first attempt. Holding left click and pressing TAB multiple times ingame may solve this.