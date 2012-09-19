TagLib
======

TagLib is a port-in-progress of the same-named C++ library [TagLib](http://developer.kde.org/~wheeler/taglib.html) written by Scott Wheeler et al. 

The library is built specifically to be easy to use: tags are properties of a Tags object, and the tags are provided in native types such as NSString, NSNumber, NSDate, and NSImage (backed by NSData).

All Tags objects expose the following tags (read/write):
* **title**: NSString *
* **artist**: NSString *
* **album**: NSString *
* **comment**: NSString *
* **genre**: NSString *
* **year**: NSDate *
* **trackNumber**: NSNumber *
* **diskNumber**: NSNumber *

Properties are a relatively stable API at this point, though more format-specific accessors and interaction methods are still very much subject to change.

MP4 Tags
--------
TagLib supports reading tags from MP4 files, including explicit support for many mp4-only tags, including some of the iTunes Store's purchase metadata.

Currently-exposed mp4-specific tags (read/write) include:
* **encoder**: NSString *
* **artwork**: NSImage *
* **TVShowName**: NSString *
* **TVEpisodeID**: NSString *
* **TVSeason**: NSNumber *
* **TVEpisode**: NSNumber *
* **albumArtist**: NSString *
* **totalTracks**: NSNumber *
* **totalDisks**: NSNumber *
* **copyright**: NSString *
* **compilation**: NSNumber * _(boolean)_
* **gaplessPlayback**: NSNumber * _(boolean)_
* **stik**: NSNumber *
* **rating**: NSNumber *
* **purchaseDate**: NSDate *
* **purchaserID**: NSString *
* **composer**: NSString *
* **BPM**: NSNumber *
* **grouping**: NSString *
* **mediaDescription**: NSString *
* **lyrics**: NSString *
* **podcast**: NSNumber * _(boolean)_

Currently-exposed mp4-specific properties (readonly) include:
* **channels**: NSNumber *
* **bitsPerSample**: NSNumber *
* **sampleRate**: NSNumber *
* **bitRate**: NSNumber *

Testing
=======
TagLib makes extensive use of OCUnit tests. As a rule, all commits into master must pass all tests. Commits into develop are only guaranteed to build.

Licensing
=========
As the original TagLib was released under the terms of LGPLv2 and MPLv1.1, this code is released in kind. The texts of the [LGPL version 2](http://www.gnu.org/licenses/old-licenses/lgpl-2.0.html) and [Mozilla Public License version 1.1](http://www.mozilla.org/MPL/MPL-1.1.html) are easily found on the internet and are not duplicated here.