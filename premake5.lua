--[[
    Find The Long Dark game directory
]]

local steam_path = os.getWindowsRegistry("HKLM:SOFTWARE\\WOW6432Node\\Valve\\Steam\\InstallPath")
local libraryfolders_path = steam_path .. "\\steamapps\\libraryfolders.vdf"

local function file_exists(path)
    local f = io.open(path, "rb")
    if f then f:close() end
    return f ~= nil
end

local function read_vdf(path)
    if file_exists(path) == false then
        error("\nlibraryfolders.vdf was not found. Check your steam installation.")
    end

    local file = io.open(path, "rb")
    local text = file:read("a")
    local folders = {}
    for match in text:gmatch("\"path\".-\"(.-)\"") do
        folders[#folders+1] = match
    end

    file:close()
    return folders
end

local library_folders = read_vdf(libraryfolders_path)

local function find_game_folder(folders)
    local game_directory_name = "\\steamapps\\common\\TheLongDark"

    for i, folder in ipairs(folders) do
        if os.isdir(folder .. game_directory_name) then
            return folder .. game_directory_name
        end
    end

    return nil
end

local game_directory = find_game_folder(library_folders)

if game_directory == nil then
    error("The Long Dark directory was not found on your PC. Have you installed the Steam version of the game?")
end

local library_paths = {
    game_directory,
    game_directory .. "\\MelonLoader",
    game_directory .. "\\MelonLoader\\Managed",
    game_directory .. "\\Mods"
}

--[[
    Configure project
]]

workspace "SkyCoop"
    configurations { "Debug", "Release" }
    platforms { "AnyCPU" }

project "SkyCoop"
    language "C#"
    kind "SharedLib"
    libdirs(library_paths)
    links {
        "System",
        "0Harmony",
        "Assembly-CSharp",
        "Il2Cppmscorlib",
        "Il2CppSystem",
        "KeyboardUtilities",
        "MelonLoader",
        "UnhollowerBaseLib",
        "UnhollowerRuntimeLib",
        "UnityEngine.AIModule",
        "UnityEngine.AnimationModule",
        "UnityEngine.AssetBundleModule",
        "UnityEngine.AudioModule",
        "UnityEngine.CoreModule",
        "UnityEngine.ImageConversionModule",
        "UnityEngine.IMGUIModule",
        "UnityEngine.ParticleSystemModule",
        "UnityEngine.PhysicsModule",
        "UnityEngine.UI",
        "UnityEngine.UIModule",
        "UnityEngine.UnityWebRequestModule",
        "UnityEngine.UnityWebRequestWWWModule",
        "UnityEngine.VehiclesModule"
    }
    files { "./src/*.cs" }

    filter "configurations:Debug"
        defines { "DEBUG" }

    filter {}
