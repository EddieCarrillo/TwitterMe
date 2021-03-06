# Project 4 - *TwitterMe*

**TwitterClient** is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).


## User Stories

The following functionality is completed:

- [x] User sees app icon in home screen and styled launch screen
- [x] User can sign in using OAuth login flow
- [x] User can Logout
- [x] User can view last 20 tweets from their home timeline
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
- [x] User can pull to refresh.
- [x] User can tap the retweet and favorite buttons in a tweet cell to retweet and/or favorite a tweet.
- [x] User can compose a new tweet by tapping on a compose button.
- [x] Using AutoLayout, the Tweet cell should adjust it's layout for iPhone 7, Plus and SE device sizes as well as accommodate device rotation.
- [x] The current signed in user will be persisted across restarts


- [x] Tweet Details Page: User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [x] User can view their profile in a *profile tab*
- Contains the user header view: picture and tagline
- Contains a section with the users basic stats: # tweets, # following, # followers
- [x] Profile view should include that user's timeline
- [x] User should display the relative timestamp for each tweet "8m", "7h"
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] Links in tweets are clickable.
- [x] User can tap the profile image in any tweet to see another user's profile
- Contains the user header view: picture and tagline
- Contains a section with the users basic stats: # tweets, # following, # followers
- [x] When composing, you should have a countdown for the number of characters remaining for the tweet (out of 140) 
- [x] User sees embedded images in tweet if available
- [x] User can switch between timeline, mentions, or profile view through a tab bar 
- [x] Profile Page: pulling down the profile page should  resize the header image. 
- [x] Sidebar menu

## GIF Walkthrough

Using active labels

<img src='https://i.imgur.com/0PQ1rw3.gif'   title=Active Labels  width='' alt='Video Walkthrough' />

Tweet Details screen

<img src='https://i.imgur.com/M4HPdZ4.gif'  title= Detail screen  width='' alt='Video Walkthrough' />

Feed Screen + Video Playback

<img src='https://i.imgur.com/yeSyhw7.gif'  title= Detail screen  width='' alt='Video Walkthrough' />

Image media

<img src='https://i.imgur.com/TQFSyBn.gif'  title= Detail screen  width='' alt='Video Walkthrough' />

New tweet

<img src='https://i.imgur.com/0uPRoE9.gif'  title= Detail screen  width='' alt='Video Walkthrough' />

Intro screen

<img src='https://i.imgur.com/cNPGvuG.gif'  title= Detail screen  width='' alt='Video Walkthrough' />

Cool sidebar

<img src='https://i.imgur.com/cCeiNEC.gif'  title= Detail screen  width='' alt='Video Walkthrough' />

Profile screen

<img src='https://i.imgur.com/1vFJRDA.gif'  title= Detail screen  width='' alt='Video Walkthrough' />



##

GIF created with [LiceCap](http://www.cockos.com/licecap/).



## Credits

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [ActiveLavel](https://github.com/optonaut/ActiveLabel.swift) - UILabel drop-in replacement for supporting Hashtags, Mentions, and URLs written in Swift
- [ImageViewer](https://github.com/MailOnline/ImageViewer) - An image viewer a la Twitter
- [DateTools](https://github.com/MatthewYork/DateTools) - Dates and times made easy in iOS
- [RSKPlaceholderTextView](https://github.com/ruslanskorb/RSKPlaceholderTextView) - A light-weight UI TextView subclass that adds support for placeholder
- [BDBOAuth1Manager](https://github.com/bdbergeron/BDBOAuth1Manager) - OAuth 1.0a library for AFNetworking 2.x






## License

Copyright [2017] [Eduardo Carrillo]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
