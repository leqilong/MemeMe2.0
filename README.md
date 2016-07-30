# MemeMe
MemeMe is an application that lets user create fun memes and share them with friends. 

##View Controller Scenes
###SentMemesCollectionViewController
SentMemesCollectionViewController is the initial view when the app first launches. It would show a history of memes made by the user. This collection view is nested in a tab bar view controller.

###SentMemesTableViewController
SentMemesTableViewController is also part of the tab bar view controller. It also shows the history of sent memes but in a different form. In each cell, there's an image view and a UILabel that displays the meme text.

###MemeEditorViewController
MemeEditorViewController conforms to UIImagePickerControllerDelegate, whose methods gives the app the function that the user can select a picture from the phone's Photos album and present it on an UIImageView.The buttom tool bar has a bar item Font that navigate to a popover picker view controller that allows the user to choose fonts for the meme text. There's also a camera button that's eitehr disabled or enabled depending on the device this program runs on. If you use the simulator to run this program, this button would be disabled. A share button at the top left tool bar lets the user share a custom meme with friends and save it to Photo album. 

###MemeDetailViewController
MemeDetailViewController can be navigated to from selecting any of the photos in either collection view or table view mentioned above. It shows the original size of meme.

##Credits
Leqi Long

##Contacts
longleqi89@gmail.com