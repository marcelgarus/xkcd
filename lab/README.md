# The lab

The lab is responsible for experimental, cool stuff that makes the app actually
smart. For now, you can read this as "detecting the comic tiles".

The detection of comics happens in this process:
* Downloading the tiles: All the comics are downloaded by running the `fetchcomics.py`
  file, which simply queries the xkcd api for comic metadata and then downloads
  the comics from the given urls into the `comics` folder.
* Detection of tiles: For most comics, you can just detect the tiles using the
  `flood.py` script. It floods the background of the image and then extracts
  comic tiles. Have a look at this, it's really interesting!
  It saves the detected tiles in the `tiles_generated` folder in the format
  `<left> <top> <right> <bottom>`, one of these per line in reading order.
  If the generator encounters a comic that's not that easily parseable, it
  writes `needs review` in the first line of the file.
* Annotating the tiles: For those comics that cannot be handled
  programmatically, `annotate.py` is called. It checks which of the generated
  files starts with a `needs review`. If it finds one, it displays the comic
  for the user to annotate using drag-n-drop. The resulting tiles are saved in
  the `tiles_user` folder. *TODO: doesn't work like this yet!*
* Merging of datasets: Finally, the `tiles_generated` and `tiles_user` datasets
  are merged into one `tiles` folder, where naturally the user-generated tiles
  get priority over the generated ones.