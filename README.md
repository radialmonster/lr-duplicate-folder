# Lightroom Duplicate Folder Plugin

A simple Adobe Lightroom plugin to duplicate a folder and its contents, including photos, develop settings, and keywords.

## Features

*   **Duplicate Folders:** Creates a complete copy of a selected folder.
*   **Copy Photos:** Duplicates all photos within the selected folder.
*   **Preserve Settings:** Copies develop settings and keywords from the original photos to the new copies.
*   **Smart Naming:** If a folder named `My Folder (copy)` already exists, it will automatically try `My Folder (copy) (copy)` and so on, until a unique name is found.

## Installation

1.  On the [repository page](https://github.com/radialmonster/lr-duplicate-folder), click the green "Code" button and select "Download ZIP".
2.  Unzip the downloaded file. You will have a folder named `lr-duplicate-folder-main`.
3.  Inside that folder, you will find the `lr-duplicate-folder.lrplugin` directory.
4.  Open Adobe Lightroom.
5.  Go to `File > Plug-in Manager...`.
6.  Click the "Add" button on the bottom left.
7.  Navigate to the `lr-duplicate-folder.lrplugin` folder you unzipped and select it.
8.  Click "Add Plug-in".
9.  The plugin should now appear in your Plug-in Manager. Click "Done".

## Usage

1.  In Lightroom's **Library** module, select a folder in the **Folders** panel on the left.
2.  Go to the main menu and select `Library > Plug-in Extras > Duplicate Folder`.
3.  The plugin will create the duplicate folder, copy all the photos and their settings, and import the new folder into your catalog.
4.  A confirmation message will appear when the process is complete.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)
