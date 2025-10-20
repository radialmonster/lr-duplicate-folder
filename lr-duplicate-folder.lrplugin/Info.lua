return {
	LrSdkVersion = 6.0,
	LrSdkMinimumVersion = 4.0, -- Mac App Store version of Lr requires 4.0

	LrToolkitIdentifier = 'com.radialmonster.lr-duplicate-folder',
	LrPluginName = "lr-duplicate-folder",
	
	LrPluginInfoUrl = "https://github.com/radialmonster/lr-duplicate-folder",
	LrHelpUrl = "https://github.com/radialmonster/lr-duplicate-folder/issues",
	
	LrPluginDescription = "A simple plugin from radialmonster.com to duplicate a folder and its contents.",
	
	LrLibraryMenuItems = {
		{
			title = "Duplicate Folder",
			file = "lr-duplicate-folder.lua",
		},
	},
	
	VERSION = { major=1, minor=0, revision=0, build=1, },
}
