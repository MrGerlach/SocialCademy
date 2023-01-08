# SocialCademy
![Hello World](https://github.com/MrGerlach/Content/blob/main/SocialCademy/HelloWorld.png?raw=true)
## Used technologies:
- Cloud Firebase - BAAS:
    - Firebase Database
    - Firebase Authenticator
    - Firebase Storage
- SwiftUI
- MVVM

## The app is designed to:
- User can sign in / log in and is authenticated with Firebase
- User can add profile picture, posts with text & picture, comment posts
- User can favorite posts and see favorited posts in other tab
- User can search for content (by username, content, tags, dates etc.)
- Posts contains username, date, profile picture and content (the same for comments)
- User can delete only own posts
- Show all user's posts by clicking on the user's profile picture or name


## What you can find in this project? 

### **Models**
For posts, comments and users.

### **ViewModels**
For posts, comments, user's profile, authentication, to sign in or log in and create new posts.
ViewModelFactory is responsible for navigating between comments, posts and user's posts.
Posts & comments are divided into smaller sections. We are working on rows level and then on the list of whole.

### **Views**
Just like in View Models. :)

### **SupportingViews**
Supporting views such as profile image, button style, image picker button and views displayed when error occurs.

### **Services**
The authentication engine. :)

### **Repositoriers**
Fetching and managing posts and comments.

### **Utilities**
FirebaseStorage manager, responding to errors 

![AnyComments?](https://github.com/MrGerlach/Content/blob/main/SocialCademy/AnyComments.png?raw=true)

## Below more screen shots: 

![Posts](https://github.com/MrGerlach/Content/blob/main/SocialCademy/Posts.png?raw=true)


![Tony'sPosts](https://github.com/MrGerlach/Content/blob/main/SocialCademy/TonysPosts.png?raw=true)


![Favorites](https://github.com/MrGerlach/Content/blob/main/SocialCademy/Favorites.png?raw=true)


![Profile](https://github.com/MrGerlach/Content/blob/main/SocialCademy/ProfilePic.png?raw=true)


![Search](https://github.com/MrGerlach/Content/blob/main/SocialCademy/SearchTor.png?raw=true)
