# Kraken API

This is just a playground for testing Combine and SwiftUI. 

I have created a main project (Kraken) and a core project (KrakenCore). The main project contains the code related to the lifecycle and front end of the app, and the core project currently contains network and model classes. Other objects could in theory be placed in the core project, e.g. access to files on disc, formatters that could be used within multiple other projects, user defaults acess etc. It is a bit overkill for a small demo project, but I wanted to show how I normally setup projects

It is a pure SwiftUI project, something I haven't done before - I have only used SwiftUI within UIKit projects for certain screens/views. I am still undecided if I would recommend using pure SwiftUI, as I find that there are still places that need awkward workarounds.

Every View has a ViewModel, to keep with the MVVM architecture pattern. On 'normal' UIKit ViewController based projects, I would use MVVM+C, but I am not yet sure how to use it with SwiftUI. I have seen articles around this, but I haven't read them. The basic UI structure of the app is:

The SceneDelegate creates a UIHostingController, with the AssetsView as the root. The AssetsView has a navigation stack, and a list with NavigationLinks, which contain an AssetCellView. The NavigationLink displays the AssetDetailView. There are only basic layouts/designs, with some font changes for titles etc. 

The Models were generated from the JSON response, via https://app.quicktype.io. I find that this generator does a lot of the heavy lifting, but you still need to go in and make some changes.

Main thinking points:
- I am not a crypto-bro, so I dn't really know what some of the terms in the api/documentation mean, or how to find out what they are. I wasn't particularly excited with using the API, and I am sure there are good reasons why it was designed that way, but I think I would have made it differently. Lots of arrays of jargon, with nothing in the documentation to say what it is. I had to put on my sherlock holmes hat and do some detecting.
- SwiftUI. I wanted the main Trading Pairs list to refresh every 60 seconds, so I used a Timer, and .onReceive(timer) on the List. This worked fine, but when tapping on the NavigationLink, the timer would go off, the view would automatically pop to the main list and reload. I couldn't work out what was going on there, so I have commented it out.
- Lots of API calls. I think if I had the time, I would have looked into putting the trade pair api calls into an operation queue. 
- There is no handling of the errors returned from the API. There is information about that here: https://docs.kraken.com/rest/#section/General-Usage/Requests-Responses-and-Errors
- Authentication is not needed as we only use the public API. Private API calls require 2FA and Nonce, and setting headers in the requests
