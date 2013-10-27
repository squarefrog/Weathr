# Weathr
Weathr is an open source iPhone and iPad app which aims to provide an minimalist approach to finding current local weather. No interaction is necessary - your location is found and then a weather report is downloaded using the [OpenWeatherMap](http://openweathermap.org/) API.

The secondary purpose is to show how Unit Tests work in Objective-C. 

## Key Technologies used in this project
* Frameworks
	* `Core Location`
	* `XCTest`
	* `Core Animation`
	* `OCMock`
* `NSURLSessionDataTask` - for downloading JSON data
* `NSAttributedString` - for mixing font weight in `UILabel`
* `NSDate` and `NSDateFormatter`

## Using the app
The first step is to clone the repository:
`$ git clone https://github.com/squarefrog/Weathr.git`

Then just open the project file `Weathr.xcproj` in Xcode 5 or later.

## Checking test coverage
The project is all set up for coverage testing using [Cover Story](https://code.google.com/p/coverstory/). A post on [Stack Overflow](http://stackoverflow.com/questions/19136767/generate-gcda-files-with-xcode5-ios7-simulator-and-xctest) by [Hugo Ferreira](http://stackoverflow.com/users/1380781/hugo-ferreira) was a big help setting this up.

To check the coverage of the tests, first run the test suite (`cmd+u`) and then open up Organizer. Click on `Weathr` and navigate to the folder listed in Derived Data. You'll then need to drill down into the i386 folder to find the necessary code coverage files.

`/Build/Intermediates/Weathr.build/Debug-iphonesimulator/Weathr.build/Objects-normal/i386/`

Within this folder there will be several `.gcda` files. You can open up each of these in [Cover Story](https://code.google.com/p/coverstory/) to get an understanding of the overal test coverage.

## Why open source?
I am releasing the code for this project for two reasons; to allow peer review of the code in order to improve my skills, and to provide a way for those unfamiliar unit tests in iOS to learn by example. If you have any suggestions or issues, please create a new Issue using GitHub Issue Tracker.