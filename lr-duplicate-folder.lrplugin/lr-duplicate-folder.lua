local LrApplication = import 'LrApplication'
local LrFileUtils = import 'LrFileUtils'
local LrTasks = import 'LrTasks'
local LrDialogs = import 'LrDialogs'
local LrPathUtils = import 'LrPathUtils'
local LrProgressScope = import 'LrProgressScope'

LrTasks.startAsyncTask(function()
    local catalog = LrApplication.activeCatalog()
    local activeSources = catalog:getActiveSources()

    -- Find the first LrFolder in the active sources
    local targetFolder = nil
    for _, source in ipairs(activeSources) do
        if source:type() == "LrFolder" then
            targetFolder = source
            break
        end
    end

    if not targetFolder then
        LrDialogs.message("No Folder Selected", "Please select a folder in the Folders panel before running this command.", "error")
        return
    end

    local photos = targetFolder:getPhotos()

    if #photos == 0 then
        LrDialogs.message("No Photos", "The selected folder contains no photos (subfolders are not included).", "info")
        return
    end

    local originalPath = targetFolder:getPath()
    local parentPath = LrPathUtils.parent(originalPath)
    local folderName = LrPathUtils.leafName(originalPath)
    local newFolderName = folderName .. " (copy)"
    local newPath = LrPathUtils.child(parentPath, newFolderName)

    -- Loop to find a unique folder name if the default already exists
    while LrFileUtils.exists(newPath) == "file" or LrFileUtils.exists(newPath) == "directory" do
        newFolderName = newFolderName .. " (copy)"
        newPath = LrPathUtils.child(parentPath, newFolderName)
    end

    -- Create the new folder
    local success, errorMsg = LrFileUtils.createDirectory(newPath)
    if not success then
        LrDialogs.message("Error Creating Folder", "Could not create folder: " .. (errorMsg or "Unknown error"), "error")
        return
    end

    -- Show progress for copying files
    local progressScope = LrProgressScope({
        title = "Duplicating Folder",
        functionContext = nil
    })

    -- Copy all photos to the new folder with error handling
    local copiedCount = 0
    local failedFiles = {}

    for i, photo in ipairs(photos) do
        progressScope:setPortionComplete(i - 1, #photos)
        progressScope:setCaption("Copying " .. i .. " of " .. #photos .. " photos...")

        local photoPath = photo:getRawMetadata('path')
        local photoName = LrPathUtils.leafName(photoPath)
        local newPhotoPath = LrPathUtils.child(newPath, photoName)

        local copySuccess, copyError = pcall(function()
            LrFileUtils.copy(photoPath, newPhotoPath)
        end)

        if copySuccess then
            copiedCount = copiedCount + 1
        else
            table.insert(failedFiles, photoName)
        end
    end

    progressScope:done()

    -- Import the photos into Lightroom catalog and copy settings
    if copiedCount > 0 then
        catalog:withWriteAccessDo("Import and Copy Settings", function()
            for i, photo in ipairs(photos) do
                local photoPath = photo:getRawMetadata('path')
                local photoName = LrPathUtils.leafName(photoPath)
                local newPhotoPath = LrPathUtils.child(newPath, photoName)

                -- Only process photos that were successfully copied
                if LrFileUtils.exists(newPhotoPath) then
                    local newPhoto = catalog:addPhoto(newPhotoPath)

                    if newPhoto then
                        -- Copy develop settings
                        local developSettings = photo:getDevelopSettings()
                        if developSettings and next(developSettings) ~= nil then
                            newPhoto:applyDevelopSettings(developSettings, "Duplicate Folder Settings", false)
                        end

                        -- Copy keywords
                        local keywords = photo:getRawMetadata('keywords')
                        if keywords and #keywords > 0 then
                            for _, keyword in ipairs(keywords) do
                                newPhoto:addKeyword(keyword)
                            end
                        end
                    end
                end
            end
        end)
    end

    -- Show results
    local message = "The folder has been duplicated.\n\n" .. copiedCount .. " photo(s) successfully copied and imported."

    if #failedFiles > 0 then
        message = message .. "\n\n" .. #failedFiles .. " photo(s) failed to copy:\n" .. table.concat(failedFiles, "\n")
        LrDialogs.message("Completed with Errors", message, "warning")
    else
        LrDialogs.message("Success", message, "info")
    end
end)