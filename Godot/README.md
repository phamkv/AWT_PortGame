# Godot Port

This is the Godot version.

## Installation

#### Godot Editor

Run Godot 4.2 and click on `Import`. Select the folder `AWT_PortGame` and click on `Select & Edit`.

#### Build

Inside Godot Editor, go to `Project -> Export...`

If the preset is missing, click on `Add -> Web`

_(Optional or if preset is missing)_
Set Export Path to `index.html` inside an empty folder (folder must be created beforehand and should be outside the Godot Project, example: `../GodotBuild/index.html`)
_Default is set to `../build/index.html`_

Click on `Export All...` and select `Release`

## Usage

#### Godot Editor

Click on the Play button on the top right or press `F5`.

#### WebGL

In order to play the game in the browser, you need to host a web service of the build.

After building the project, run the following command inside the build folder (you need npx installed):

`npx local-web-server --https --cors.embedder-policy "require-corp" --cors.opener-policy "same-origin" --directory "."`

Go to one of the URLs shown in the console. Ignore the security concerns for HTTPS in localhost. HTTPS and CORS have to be enabled in order to run Godot games in WebGL (see Godot Documentation for further information).

Press TAB to lock the mouse ingame. It may not work in the first attempt. Holding left click and pressing TAB multiple times ingame may solve this.

#### Controls

`TAB` or `Esc` to open options menu ingame (`TAB` is recommended for WebGL)

Move with `WASD` and jump with `Space`

`Left click` to attack

Hold `Shift` to run

Open inventory with `E`
