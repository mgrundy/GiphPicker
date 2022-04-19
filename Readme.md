# GiphPicker

Hi There! This is a sample project I did as part of an interview process at a
certain unnamed company. The project brief was:


*For this portion of the interview, we’d like you to build a basic, single view
app that allows a user to search for fun, animated GIFs.*


They also supplied a sample query URL and some tips, but A) the api is pretty 
self-explanatory in the code (and the actual docs linked to).  ¯\\_(ツ)_/¯


These open-ended take-home projects are kinda crap. They always take 2-3 times
what the interviewers estimate. Most of the time this is unpaid work. And
frequently they don't have a lot to do with what you'll be doing. I'm sure the
folks who put it together thought it was a good estimate (3-4 hours), but doubt
they tried timing themselves while they did it. My advice? Stick with the
companies who compensate you for take-home projects.


Everything is self-contained. No pods or Carthage configs. Open up the xcode
project and run it.  The user interface is basic, just a search bar and
results. When the app starts up it loads Giphy's trending feed. Thought it was
better than an empty screen or default.  Take it for a spin. And if you see the
smily face button, give it a try.


I pulled the API key out of the code and plopped this in a fresh repo. First
thing you should do is get a giphy api key and pop it in place.


## Code Tour
GiphPicker uses SwiftUI and Combine. I think code organization is pretty
straightforward. Views are in the Views folder, Models are in the Models
folder.


### Views
ContentView is the main app view. There is TextField() at the top that sends
it's input to the apiSearch class's queryString. The List() takes the search
results and loads it into previewCells. Having a separate container here is
important so that the AVQueuePlayer and AVPlayerLooper in
AVPlayerControllerRepresented can maintain state.  *WAIT!* Yes, I know, you're
thinking "AVPlayer? Isn't this a gif app?" So, hard truth: gifs are big. MP4s
are considerably smaller (especially the preview versions).  The trick to
keeping it gif-like is setting up an AVQueuePlayer and using AVPlayerLooper to
keep repeating the file. That is also why I wrapped the video player up in a
UIViewControllerRepresentable (standard way to pack UIKit stuff into SwiftUI).
The SwiftUI VideoPlayer is good and easy, but doesn't have the level of control
needed here.

ButtonViews contains different button layouts (obvious names are good)

SplashView uses AVPlayerControllerRepresented for a "help" screen. I think
you'll enjoy it.

### Models
GifSearchResponse is all of the Structs and Enums used by JSONDecoder to decode the api responses.

GiphyApi takes a search string in on queryString, uses a separate dataTask to
do the gets and parses, and updates searchResults on the main thread. During
init() the results are populated with the trending feed.

ImageDownload was intended to grab stills in case the bandwidth was too tight
for pulling mp4s. I didn't do that. But code is not wasted, it's generic enough
to rename to AssetDownload and use that in the Preview view to show a complete
preview of the selected gif.

## To do or things that might be nice for pair programming
- Flesh out Preview to show a looping version of the complete video / gif.
- Update Download image to be an ObservableObject that uses a @Published URL input and provides a @Published local URL of a downloaded file
- Infinite scrolling of results (currently limited to 25)
- Share sheet / share buttons on full Preview
