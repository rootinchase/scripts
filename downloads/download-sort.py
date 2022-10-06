#!/usr/bin/python
# This uses python3.5+ stuff


# OS libs
from os import chdir, environ, getpid, mkdir, remove, scandir
import sys
import re
# import filetype

# Moving/path stuff
from pathlib import Path
import shutil

# Extracting
# import patoolib
import rarfile
# import tarfile
import zipfile

# This one is not in gentoo repositories
import py7zr

# Read configs
import json
import tomli
# import yaml

DEBUG = True


archives = [".tar", ".tar.bz", ".tar.gz"]
audio = [".aac", ".flac", ".mp3", ".m4a", ".ogg", ".wav"]
books = [".azw", ".epub", ".mobi", ".pdf", ".txt"]
documents = [".doc", ".docx", ".odt", ".ppt", ".pptx", ".pub"]
executables = ['.AppImage', '.bin', ".exe"]
images = [".bmp", ".eps", ".gif", ".jpg", ".jpeg", ".png", ".raw", ".tif", ".tiff"]
minecraft = [".jar", ".zip"]
os = [".img", ".iso"]
packages = [".deb", ".ebuild", ".rpm"]
scripts = [".cmd", ".ps1", ".py", ".rb", ".sh"]
skyrim = [".7z", ".rar", ".zip"]
skyrim_content = [".bsa", ".esm", ".esp", ".hkx", ".nif", ".pex", ".psc"]
terraria = [".plr", ".tmod", ".twld", ".wld"]
videos = [".mov", ".mp4", ".webm"]


def make_dir_tree():
    # Create directories
    Path(download_dir + "/archives").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/audio").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/books").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/documents").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/executables").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/images").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/java").mkdir(parents=True, exist_ok=True)

    Path(download_dir + "/minecraft/datapacks").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/minecraft/fabric/1.16").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/minecraft/fabric/1.17").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/minecraft/fabric/1.18").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/minecraft/forge/1.12").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/minecraft/forge/1.16").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/minecraft/forge/1.17").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/minecraft/forge/1.18").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/minecraft/modpacks").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/minecraft/optifine").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/minecraft/shaders").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/minecraft/resourcepacks").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/minecraft/texturepacks").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/minecraft/worlds").mkdir(parents=True, exist_ok=True)

    Path(download_dir + "/misc").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/os/iso").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/os/packages").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/scripts").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/skyrim").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/terraria").mkdir(parents=True, exist_ok=True)
    Path(download_dir + "/videos").mkdir(parents=True, exist_ok=True)
    return


def extract_from_zip(zip_file, file):
    zips = zipfile.ZipFile(zip_file, 'r')
    zips.extract(file, script_tmpdir)
    zips.close()
    return


def json_branch_parse(json_obj, branch):
    var = json_obj.get(branch)
    if var is None:
        return None
    else:
        print(branch)
        out = json_obj.get(branch).get('minecraft')
        if out is None:
            return None
        else:
            raw_ver = json_parse(json_obj, branch)
            print(re.search("\d\.\d\d", raw_ver[0]))
            return json_parse(json_obj, branch)


def json_test_branch(json_obj, branch):
    out = json_obj.get(branch).get('minecraft')
    if out is None:
        print("No embedded info")
        return False
    else:
        print(out)
        return True


def json_parse(json_obj, branch):
    raw_ver = json_obj.get(branch).get('minecraft')
    return re.search("1\.\d\d", raw_ver[0])


def filename_parse(test_jar):
    print("trying filename parsing")
    var = re.search("1\.\d\d", test_jar)
    if var is None:
        print("filename parsing failed")
        return None
    print(var.group())
    return var.group()


def fabric_version(test_jar):
    print(test_jar)
    extract_from_zip(test_jar, 'fabric.mod.json')
    json_file = open(script_tmpdir + "/fabric.mod.json")
    json_obj = json.load(json_file)
    var = json_obj.get('depends')
    if var is None:
        print(test_jar + " has no known depends")
        var = json_obj.get('recommends')
        if var is None:
            print(test_jar + " has no known depends, or recommends version")
        else:
            raw_ver = json_obj.get('recommends').get('minecraft')[0]
            if raw_ver is not None:
                var = re.search("1\.\d\d", raw_ver)
                ver = var.group()
                print(test_jar + " is for fabric mc v" + str(ver))
                Path(download_dir + "/minecraft/fabric/" + ver).mkdir(parents=True, exist_ok=True)
                shutil.move(download_dir + "/" + test_jar, download_dir + "/minecraft/fabric/" + str(ver))
            else:
                ver = filename_parse(test_jar)
                if ver is None:
                    print("No known version for this")
                    return
                else:
                    print(test_jar + " is for fabric mc v" + str(ver))
                    Path(download_dir + "/minecraft/fabric/" + ver).mkdir(parents=True, exist_ok=True)
                    shutil.move(download_dir + "/" + test_jar, download_dir + "/minecraft/fabric/" + str(ver))
    else:
        raw_ver = json_obj.get('depends').get('minecraft')
        if raw_ver is not None:
            var = re.search("1\.\d\d", raw_ver)
            ver = var.group()
            print(test_jar + " is for fabric mc v" + str(ver))
            Path(download_dir + "/minecraft/fabric/" + ver).mkdir(parents=True, exist_ok=True)
            shutil.move(download_dir + "/" + test_jar, download_dir + "/minecraft/fabric/" + str(ver))
        else:
            ver = filename_parse(test_jar)
            if ver is None:
                print("No known version for this")
                return
            else:
                print(test_jar + " is for fabric mc v" + str(ver))
                Path(download_dir + "/minecraft/fabric/" + ver).mkdir(parents=True, exist_ok=True)
                shutil.move(download_dir + "/" + test_jar, download_dir + "/minecraft/fabric/" + str(ver))
    json_file.close()
    remove(script_tmpdir + "/fabric.mod.json")
    return


def forge_version(test_jar):
    extract_from_zip(test_jar, 'META-INF/mods.toml')
    toml_file = open(script_tmpdir + "/META-INF/mods.toml", "rb")
    try:
        toml_dict = tomli.load(toml_file)
    except tomli.TOMLDecodeError:
        print("malformed mods.toml in " + test_jar)
        name = filename_parse(test_jar)
        if name is None:
            return
        else:
            # Path(download_dir + "/minecraft/forge/" + ver).mkdir(parents=True, exist_ok=True)
            shutil.move(download_dir + "/" + test_jar, download_dir + "/minecraft/forge/" + str(name))
            return
    raw_ver = None
    var = None
    if 'dependencies' in toml_dict.keys():
        mod = toml_dict.get('mods')[0].get('modId')
        dep = toml_dict.get('dependencies').get(mod)
        if dep is None:
            dep = toml_dict.get('dependencies').get('examplemod')
            if dep is None:
                print("I can't find the right dependencies in: " + test_jar)
                return
        for test in dep:
            if 'minecraft' in test['modId']:
                raw_ver = test['versionRange']
                var = re.search('\d\.\d\d', raw_ver).group()
        toml_file.close()
    remove(script_tmpdir + "/META-INF/mods.toml")
    if raw_ver is None:
        var = filename_parse(test_jar)
        print(test_jar)
    # Path(download_dir + "/minecraft/forge/" + ver).mkdir(parents=True, exist_ok=True)
    shutil.move(download_dir + "/" + test_jar, download_dir + "/minecraft/forge/" + str(var))
    return


def mod_check(test_jar):
    zips = zipfile.ZipFile(test_jar)
    files = zips.namelist()
    zips.close()
    mod_files = ['META-INF/mods.toml', 'fabric.mod.json']
    found = [sub for sub in mod_files if sub in files]
    if len(found) == 0:
        print(test_jar + "doesn't seem to be a minecraft jar")
        shutil.move(download_dir + "/" + test_jar, download_dir + "/java")
        return
    elif found[0] == 'META-INF/mods.toml':
        forge_version(test_jar)
        return
    elif found[0] == 'fabric.mod.json':
        fabric_version(test_jar)
        return


def minecraft_zip_check(zip_file):
    zips = zipfile.ZipFile(zip_file, 'r')
    files = zips.namelist()
    zips.close()
    test_files = ['modlist.json', 'pack.mcmeta', 'level.dat']
    found = [sub for sub in test_files if sub in files]
    if len(found) == int(0):  # Tin foil hat
        shader_packs = ['glsl', 'shaders']
        for file in files:
            for ext in shader_packs:
                if ext in file:
                    shutil.move(download_dir + "/" + zip_file, download_dir + "/minecraft/shaders")
                    return True
                else:
                    print("File: " + zip_file + " is not a minecraft zip")
                    return False
    elif len(found) > 0:
        if test_files[0] in files:
            shutil.move(download_dir + "/" + zip_file, download_dir + "/minecraft/modpacks")
            return True
        elif found[0] == test_files[2]:
            shutil.move(download_dir + "/" + zip_file, download_dir + "/minecraft/worlds")
            return True
        datapacks = ['mcfunction', 'recipes']
        resource_packs = ['advancements', 'functions', 'items', 'recipes']
        texture_packs = ['textures', 'sounds']
        for file in files:
            for ext in datapacks:
                if ext in file:
                    print("data_pack")
                    shutil.move(download_dir + "/" + zip_file, download_dir + "/minecraft/datapacks")
                    return True
            for ext in resource_packs:
                if ext in file:
                    print("resourcepacks")
                    shutil.move(download_dir + "/" + zip_file, download_dir + "/minecraft/resourcepacks")
                    return True
            for ext in texture_packs:
                if ext in file:
                    print("texturepacks")
                    shutil.move(download_dir + "/" + zip_file, download_dir + "/minecraft/texturepacks")
                    return True
        print("File: " + zip_file + " is not a minecraft zip")
        return False


def skyrim_check(skyrim_file):
    print(skyrim_file)
    files = []
    if ".zip" in skyrim_file:
        zips = zipfile.ZipFile(skyrim_file, 'r')
        files = zips.namelist()
        zips.close()
    elif ".rar" in skyrim_file:
        rf = rarfile.RarFile(skyrim_file)
        for f in rf.infolist():
            files.append(f.filename)
    elif ".7z" in skyrim_file:
        z = py7zr.SevenZipFile(skyrim_file)
        for f in z.list():
            files.append(f.filename)
    for file in files:
        for ext in skyrim_content:
            if ext in file:
                shutil.move(download_dir + "/" + skyrim_file, download_dir + "/skyrim")
                return True
    return False


# Driver function, finds all the files, and goes through the proper functions
def file_loop():
    file_list = []
    # Get a list of all files and folders in download_dir, then add all the
    # files the the array files. After that close the scandir object
    with scandir(download_dir) as downloads:
        for entry in downloads:
            if not entry.name.startswith('.') and entry.is_file():
                file_list.append(entry.name)
    downloads.close()

    for file in file_list:
        # Move audio files to audio
        for ext in audio:
            if ext in file:
                shutil.move(download_dir + "/" + file, download_dir + "/audio")
                continue
        # Move book files to books
        for ext in books:
            if ext in file:
                shutil.move(download_dir + "/" + file, download_dir + "/books")
                continue
        for ext in documents:
            if ext in file:
                shutil.move(download_dir + "/" + file, download_dir + "/documents")
                continue
        for ext in executables:
            if ext in file:
                shutil.move(download_dir + "/" + file, download_dir + "/executables")
                continue
        for ext in images:
            if ext in file:
                shutil.move(download_dir + "/" + file, download_dir + "/images")
                continue
        for ext in os:
            if ext in file:
                shutil.move(download_dir + "/" + file, download_dir + "/os/iso")
                continue
        for ext in packages:
            if ext in file:
                shutil.move(download_dir + "/" + file, download_dir + "/os/packages")
                continue
        for ext in scripts:
            if ext in file:
                shutil.move(download_dir + "/" + file, download_dir + "/scripts")
                continue
        for ext in terraria:
            if ext in file:
                shutil.move(download_dir + "/" + file, download_dir + "/terraria")
                continue
        for ext in videos:
            if ext in file:
                shutil.move(download_dir + "/" + file, download_dir + "/videos")
                continue

        # Now for the hard parts... to sort out Minecraft and Skyrim
        # After that we can move the archives and the rest
        if minecraft[0] in file:
            mod_check(file)
            continue

        if minecraft[1] in file:
            mc = minecraft_zip_check(file)
            if mc:
                continue

        for ext in skyrim:
            if ext in file:
                sk = skyrim_check(file)
                if sk:
                    continue
                else:
                    shutil.move(download_dir + "/" + file, download_dir + "/archives")
                    continue

        for ext in archives:
            if ext in file:
                print("moving archive: " + file)
                shutil.move(download_dir + "/" + file, download_dir + "/archives")
                continue


if __name__ == "__main__":
    # # #
    # Linux only (I don't use windows enough)
    #
    if not sys.platform.startswith('linux'):
        print("This is Linux only for now. I can only test and troubleshoot this on Linux")
        exit(1)

    # Initialize script_tmpdir
    script_tmpdir = "/tmp/sort_" + str(getpid())
    mkdir(script_tmpdir, 0o700)

    # Download folder
    if DEBUG:
        # Use a test download dir for testing
        download_dir = environ['HOME'] + "/test/Downloads"
    else:
        download_dir = environ['HOME'] + "/Downloads"

    # Create folders if needed
    make_dir_tree()

    # Change the directory to the download dir
    chdir(download_dir)
    # Loop through the files
    file_loop()
    shutil.rmtree(script_tmpdir)
