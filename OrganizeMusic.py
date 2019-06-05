#End goal for this code is to completly automate music file organization
#   
#   Will need to figure out how to find .mp3, .m4a and .mp4 file data
#       Get that data to create directories for artists and albums 
#
#   Also check for .zip files, unpack them, sort music files, then move 
#   the .zip file to another directory


#Edit directories and files with recursion
#	Delete specific files
#	Move zip files to one folder
#

#Used for cleaning up music files in linux storage
#
#TODO: Create test cases

#TODO: Create a 'help' page of some sort
#
#TODO: Set a way to get files from another directory

#TODO: Set error checks so that program can only be run in Music direc, or
#      from download direc.
#
#TODO Set way to rename a file based on track number, song name, artist and
#     album name, good idea? 
#     EX: num_title album artist.mp3

import os
import shutil
import sys
import zipfile

from tinytag import TinyTag

def moveFiles(rootDir):
    """Look through files and directories and move them to specified locations
    """

    homedir = os.environ['HOME']
    albumDirec = 'AlbumCoverImages'
    #Check if a directory exists
    if not os.path.isdir(os.path.join(homedir, 'Pictures', albumDirec)):
        print('AlbumCoverImages not found, trying to make...')
        os.makedirs(os.path.join(homedir, 'Pictures', albumDirec))
        
    for root, dirs, files in os.walk(rootDir, topdown=False):
        #print('testtest')
        for name in files:
    

            #Find image files, and move them to albumCoverImages
            #For some bullshit reason or statments won't work here, have to
            #   parse this out to elif statements, ughhhh...
            
            if '.jpg' in name:
                os.rename(os.path.join(root, name), os.path.join(homedir, 'Pictures', albumDirec, name))
                print('{0} moved to {1}!'.format(name, os.path.join(homedir, 'Pictures', albumDirec)))
            
            elif '.png' in name:
                os.rename(os.path.join(root, name), os.path.join(homedir, 'Pictures', albumDirec, name))
                print('{0} moved to {1}!'.format(name, os.path.join(homedir, 'Pictures', albumDirec, name)))
            
            elif '.gif' in name:
                os.rename(os.path.join(root, name), os.path.join(homedir, 'Pictures', albumDirec, name))
                print('{0} moved to {1}!'.format(name, os.path.join(homedir, 'Pictures', albumDirec, name)))
            
            elif '.pdf' in name:
                os.rename(os.path.join(root, name), os.path.join(homedir, 'Pictures', albumDirec, name))
                print('{0} moved to {1}!'.format(name, os.path.join(homedir, 'Pictures', albumDirec, name)))

            else:
                try:
                    #Use tinytag to get file metadata
                    tag = TinyTag.get(os.path.join(root, name))
                    artistName = tag.artist
                    albumName = tag.album
                    
                    #TODO: Need to add more conditions
                    if isinstance(artistName, str):
                        artistName = artistName.replace('/', '_')

                    elif isinstance(albumName, str):
                        albumName.replace('/', '_')
                      

                #Check if the artists directory exists, if not make it
                    try:
                        if not os.path.isdir(os.path.join(rootDir, artistName)):
                            os.makedirs(os.path.join(rootDir, artistName))
                            print('{0} directory made!'.format(artistName))
            
                    except ValueError:
                            print('ValueError with {0}'.format(root+'/'+name))
                            continue

                    except TypeError:
                        print('TypeError with {0}'.format(root+'/'+name))
                        continue

                #Check if the songs album exists, if not make it
                    try:
                        if not os.path.isdir(os.path.join(rootDir, artistName, albumName)):
                            os.makedirs(os.path.join(rootDir, artistName, albumName))
                            print('{0} directory made!'.format(albumName))
                
                    except TypeError:
                        print('TypeError with {0}! Look at album directory making.'.format(root+'/'+name))
                        continue

                #TODO: Check if album is in artist direc, if not, move it

                #Check if song is in album, if not move it 
                    try:
                        if os.path.isfile(os.path.join(rootDir, artistName, albumName, name)) == False:
                            os.rename(os.path.join(root, name), os.path.join(rootDir, artistName, albumName, name))
                            print('{0} moved to {1}!'.format(name, albumName))
                
                    except TypeError:
                        print('TypeError with file {0}! Look at line song moving'.format(root+'/'+name))
                        continue
                
                #TODO: Check if this part works
                except LookupError:
                    if (".jpg") or (".png") or (".7z") or ("README") or (".zip") in name:
                        continue
                
                    else:
                        print('No reader support for {0}'.format(name))
                        continue



def cleanDirecs(rootDir):
    """Look thorugh diretories, if empty directory is found, remove it.
    """
    for root, dirs, files in os.walk(rootDir, topdown=False):
                    
        if not files:
            if not dirs:
                print("Removing {0}".format(root))
                os.rmdir(os.path.join(rootDir, root))

#TODO: Make a way to extract .rar files 
def extractZipFiles(rootDir, zipDir):
    """Find zip files, and extract their contents 
    """
    for root, dirs, files in os.walk(zipDir, topdown=False):
        for name in files:
           
            zipFiles = os.path.join(root, name)
           
           #Check file extension here
            if ".zip" not in zipFiles:
                continue
            
            else:
                zipPath = zipfile.ZipFile(zipFiles, 'r')
                #print(zipPath) 
        
                filesInZip = zipPath.namelist()
                i = 0    
                for i in range(len(filesInZip)):
                    #print(filesInZip[i])
                    #print(zipPath.getinfo(filesInZip[i]))
                
                    if ".mp3" in filesInZip[i]:
                        zipPath.extract(filesInZip[i], rootDir)
                        print("{0} extracted to {1}".format(filesInZip[i], rootDir))

                    elif ".m4a" in filesInZip[i]:
                        zipPath.extract(filesInZip[i], rootDir)
                        print("{0} extracted to {1}".format(filesInZip[i], rootDir))

                    elif ".mp4" in filesInZip[i]:
                        zipPath.extract(filesInZip[i], rootDir)
                        print("{0} extracted to {1}".format(filesInZip[i], rootDir))

                    elif ".png" in filesInZip[i]:
                        zipPath.extract(filesInZip[i], rootDir)
                        print("{0} extracted to {1}".format(filesInZip[i], rootDir))

                    elif ".jpg" in filesInZip[i]:
                        zipPath.extract(filesInZip[i], rootDir)
                        print("{0} extracted to {1}".format(filesInZip[i], rootDir))
                
                    elif ".pdf" in filesInZip[i]:
                        zipPath.extract(filesInZip[i], rootDir)
                        print("{0} extracted to {1}".format(filesInZip[i], rootDir))

                    else:
                        print("No media found in zip file {0}".format(name))
                
                zipPath.close()

#TODO: Rethink this function. Is'nt checking for the music zip folder
#      redundant?
def moveZips(rootDir, zipDir):
    """Look through zipDir directory and move zip files to the rootDir
    """

    if (os.path.isdir(os.path.join(rootDir, "MUSzipFiles"))):
        
        for root, dirs, files in os.walk(zipDir, topdown=False):
            for name in files:
                
                if ".zip" in name:
                    os.rename(os.path.join(root, name), os.path.join(rootDir, "MUSzipFiles", name))
                    print("{0} moved to {1}".format(files, rootDir))

                elif ".7z" in name:
                    os.rename(os.path.join(root, name), os.path.join(rootDir, "MUSzipFiles", name))
                    print("{0} moved to {1}".format(files, rootDir))
                
                #TODO: Figure out how to extract .rar files.
                #elif ".rar" in name:
                #    os.rename(os.path.join(root, name), os.path.join(rootDir, "MUSzipFiles", name))
                #    print("{0} moved to {1}".format(files, rootDir))

                else:
                    print("Cannot move {0} to {1}!".format(name, os.path.join(rootDir, "MUSzipFiles")))

    else:
        print("{0} does not exist!".format(os.path.join(rootDir, "MUSzipFiles")))


def edMusFiles(rootDir):
    """Look through directories and files with recursion
    """

    #Check for zip files directory first, then go through music files
    if os.path.exists(os.path.join(rootDir, 'MUSzipFiles')) == False:
        print("MUSzipFiles does not exist, trying to make...")
        os.makedirs(os.path.join(rootDir, 'MUSzipFiles'))

    for root, dirs, files in os.walk(rootDir, topdown=False):
        
        for name in files:
            
            if "desktop.ini" in name:
                os.remove(os.path.join(root, name))
                print("dektop.ini removed!") 
            
            elif "Folder.jpg" in name:
                os.remove(os.path.join(root, name))
                print("Folder.jpg removed!")
    
            elif "_Small.jpg" in name:
                os.remove(os.path.join(root, name))
                print("_Small.jpg removed!")

            elif "AlbumArtSmall.jpg" in name:
                os.remove(os.path.join(root, name))
                print("AlbumArtSmall.jpg removed!")
        
            elif "README" in name:
                os.remove(os.path.join(root, name))
                print("README removed!")
            
            #Set so that if the file is already in zip file folder, leave it alone.
            elif ".zip" in name:
                if (os.path.isfile(os.path.join(rootDir, 'MUSzipFiles', name)) == False): 
                    os.rename(os.path.join(root, name), os.path.join(rootDir, 'MUSzipFiles', name))
                    print("Moved {0} to MUSzipFiles!".format(name))   

            elif '.7z' in name:
                if (os.path.isfile(os.path.join(rootDir, 'MUSzipFiles', name)) == False):
                    os.rename(os.path.join(root, name), os.path.join(rootDir, 'MUSzipFiles', name))
                    print("Moved {0} to MUSzipFiles!".format(name))


#direc = "/home/ethan/Music/"
#editMusic(direc)

if __name__ == '__main__':
    
    if (sys.argv[1] == "edit"): 
        print("Editing and moving files/directories\n...\n...")
        moveFiles(sys.argv[2])
        edMusFiles(sys.argv[2])
        print("...\n...\nDone!")

    elif (sys.argv[1] == "clean"):
        print("Cleaning empty directories\n...\n...")
        cleanDirecs(sys.argv[2])
        print("...\n...\nDone!")


    elif (sys.argv[1] == "extract"):
        print("Extracting files from zip folders\n...\n...")
        extractZipFiles(sys.argv[2], sys.argv[3])
        print("Moving zip files\n...\n...")
        moveZips(sys.argv[2], sys.argv[3])
        print("...\n...\nDone!")
    
   
    elif (sys.argv[1] == "help"):
        print("\n\n")
        print("\n")

    else:
        print("Missing argument!")
