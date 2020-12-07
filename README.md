# tweets

This is an interview project. It searches the twitter API based on a keyword and displays a list of posts.

![Demo video](appVideo.gif)

There are some things that I could have done better, and they broadly fall into two categories: things I didn't want to spend too much time on in an interview task, and things I intentionally left simple to avoid over-designing.

## Intentional omissions
These changes could be made, and would probably be significant improvements for a more complex application, but I like to avoid doing things in an unnecessarily complicated for the specific task, even if they are generally better practices. Keep it simple and all that.

**Better architecture:** I considered building this using MVVM, but apple's default MVC works fine for something so small. 

**Better request handling:** There are no generic methods for handling server requests in this implementation. This is intentional, since there is only one actual API request and adding extra methods for better extensibility isn't needed, and is easy enough to refactor in the future.

**Moving manager initialization outside of the VC:** There are a couple of classes (*TweetManager, TweetFetcher*), that get initialized inside the single *ViewController*. In a bigger project, these would be initialized somewhere else (probably the *AppDelegate*), but it isn't needed considering the small scope.

## Future improvements
All of the following would certainly be improvements, and would need to be made before something like this goes anywhere close to production, but I didn't want to spend too much time on an interview task.

**Pagination:** Currently, the search loads large number of posts and displays them. It would be significantly better to implement pagination/infinite scrolling, loading fewer posts, and then loading more when the user scrolls near the bottom of the table view. This would be done by adding a *max_id* parameter to the request URL, equaling to the id of the oldest loaded tweet. This request would be made when the table view's *cellForRow* method is called for one of the final currently displayed rows. This would also require adding a couple of variables in the view controller, to avoid sending infinite requests once there are no more results.

**Actual JSONs in tests:** In the unit tests for the app, the model is taken from dictionaries hardcoded into a helper class. It would be better to add *json* files, reading from them and parsing them instead.

**Better error handling:** The error handling of the server request is pretty basic, not considering the various possible status codes that the API can return (https://developer.twitter.com/en/support/twitter-api/error-troubleshooting). Also, the current error messages leave a lot to be desired and should be replaced with more user-friendly ones.
